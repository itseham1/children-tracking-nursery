import 'package:app/camera_view.dart';
import 'package:app/screens/face_recognition_service.dart';
import 'package:app/util/face_detector_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  // اسم الطفل المعرَّف
  String _recognizedChild = '';
  bool _isRecognizing = false;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraView(
            title: 'Face Detector',
            customPaint: _customPaint,
            text: _text,
            onImage: (inputImage) {
              processImage(inputImage);
            },
            initialDirection: CameraLensDirection.front,
          ),

          // عرض اسم الطفل المعرَّف في أسفل الشاشة
          Positioned(
            bottom: 160,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isRecognizing
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      _recognizedChild.isEmpty
                          ? 'Waiting for face...'
                          : _recognizedChild == 'Unknown'
                              ? '❓ Unknown Child'
                              : '✅ ${_recognizedChild}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _recognizedChild == 'Unknown'
                            ? Colors.red
                            : Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    setState(() {
      _text = '';
    });

    final faces = await _faceDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
      );
      _customPaint = CustomPaint(painter: painter);
    }

    if (faces.isNotEmpty) {
      final face = faces.first;
      final features = FaceRecognitionService.extractFaceFeatures(face);

      if (!_isRecognizing) {
        setState(() => _isRecognizing = true);

        final name = await FaceRecognitionService.recognizeFace(features);

        if (mounted) {
          setState(() {
            _recognizedChild = name;
            _isRecognizing = false;
          });
        }

        await Future.delayed(const Duration(seconds: 2));
      }
    } else {
      if (mounted) {
        setState(() {
          _recognizedChild = '';
        });
      }
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
