import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class RecognitionResult {
  final String label;
  final double confidence;

  RecognitionResult({required this.label, required this.confidence});

  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
}

class CropClassifier {
  static const String _modelPath = 'assets/models/mobilenet_v2_crop.tflite';
  static const String _labelsPath = 'assets/models/labels.txt';
  static const int inputSize = 224;

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isReady => _interpreter != null && _labels.isNotEmpty;

  /// Loads labels and model tensors into memory
  Future<void> initialize() async {
    try {
      // 1. Load labels
      final labelsRaw = await rootBundle.loadString(_labelsPath);
      _labels = labelsRaw
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // 2. Load TFLite model
      final options = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      _interpreter!.allocateTensors();

      debugPrint(' CropClassifier loaded successfully with ${_labels.length} classes.');
    } catch (e) {
      debugPrint(' CropClassifier initialization deferred: $e');
    }
  }

  /// Runs inference on an image file
  Future<List<RecognitionResult>> runInference(File imageFile) async {
    if (!isReady) {
      await initialize();
      if (!isReady) {
        throw StateError('Classifier model is not loaded or missing in assets.');
      }
    }

    // 1. Decode bytes and resize to 224x224
    final Uint8List bytes = await imageFile.readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw ArgumentError('Could not decode the image file.');
    }

    final img.Image resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
    );

    // 2. Inspect input & output tensor metadata
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);

    final inputBuffer = _preprocess(resized, inputTensor);

    // 3. Prepare output container
    final outputShape = outputTensor.shape;
    final outputType = outputTensor.type;

    dynamic outputBuffer;
    if (outputType == TensorType.int8 || outputType == TensorType.uint8) {
      outputBuffer = List<int>.filled(outputShape.reduce((a, b) => a * b), 0)
          .reshape(outputShape);
    } else {
      outputBuffer = List<double>.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);
    }

    // 4. Run inference
    _interpreter!.run(inputBuffer, outputBuffer);

    // 5. Post-process logits/probabilities
    return _postprocess(outputBuffer[0], outputTensor);
  }

  dynamic _preprocess(img.Image image, Tensor inputTensor) {
    final bool isQuantized = inputTensor.type == TensorType.int8;
    final double scale = inputTensor.params.scale;
    final int zeroPoint = inputTensor.params.zeroPoint;

    if (isQuantized) {
      return List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(
            inputSize,
            (x) {
              final pixel = image.getPixel(x, y);
              // Normalize to [-1, 1]
              final r = (pixel.r - 127.5) / 127.5;
              final g = (pixel.g - 127.5) / 127.5;
              final b = (pixel.b - 127.5) / 127.5;

              return [
                ((r / scale) + zeroPoint).round().clamp(-128, 127),
                ((g / scale) + zeroPoint).round().clamp(-128, 127),
                ((b / scale) + zeroPoint).round().clamp(-128, 127),
              ];
            },
          ),
        ),
      );
    } else {
      return List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(
            inputSize,
            (x) {
              final pixel = image.getPixel(x, y);
              return [
                (pixel.r - 127.5) / 127.5,
                (pixel.g - 127.5) / 127.5,
                (pixel.b - 127.5) / 127.5,
              ];
            },
          ),
        ),
      );
    }
  }

  List<RecognitionResult> _postprocess(List<dynamic> rawScores, Tensor outputTensor) {
    List<double> probabilities;

    if (outputTensor.type == TensorType.int8) {
      final double scale = outputTensor.params.scale;
      final int zeroPoint = outputTensor.params.zeroPoint;
      probabilities = rawScores.map((score) {
        return ((score as int) - zeroPoint) * scale;
      }).toList();
    } else {
      probabilities = rawScores.map((score) => (score as num).toDouble()).toList();
    }

    final results = <RecognitionResult>[];
    for (int i = 0; i < probabilities.length && i < _labels.length; i++) {
      results.add(RecognitionResult(label: _labels[i], confidence: probabilities[i]));
    }

    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    return results;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}