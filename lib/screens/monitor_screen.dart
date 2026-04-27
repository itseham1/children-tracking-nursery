import 'dart:async';
import 'package:app/camera_view.dart';
import 'package:app/screens/face_recognition_service.dart';
import 'package:app/util/face_detector_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MonitorScreen extends StatefulWidget {
  final String childId;
  final int durationMinutes;

  const MonitorScreen({
    Key? key,
    required this.childId,
    required this.durationMinutes,
  }) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _canProcess = true;
  bool _isBusy = false;
  bool _isRecognizing = false;
  CustomPaint? _customPaint;

  String _status = 'Searching for child...';
  bool _childFound = false;
  String _recognizedName = '';

  // countdown timer
  late int _remainingSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('ParentPage');
        }
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

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

    if (faces.isNotEmpty && !_isRecognizing) {
      _isRecognizing = true;
      final features =
          FaceRecognitionService.extractFaceFeatures(faces.first);
      final name = await FaceRecognitionService.recognizeFace(features);

      if (mounted) {
        setState(() {
          if (name != 'Unknown' && !_childFound) {
            _childFound = true;
            _recognizedName = name;
            _status = 'Child Found';
            _startCountdown();
          } else if (!_childFound) {
            _status = 'Searching for child...';
          }
        });
      }

      await Future.delayed(const Duration(seconds: 2));
      _isRecognizing = false;
    }

    _isBusy = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('ParentPage');
          },
        ),
        title: Text(
          'Monitor',
          style: GoogleFonts.robotoCondensed(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Camera View
          CameraView(
            title: 'Monitor',
            customPaint: _customPaint,
            onImage: (inputImage) {
              processImage(inputImage);
            },
            initialDirection: CameraLensDirection.back,
          ),

          // Status Card at top
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _childFound ? Icons.check_circle : Icons.search,
                    color: _childFound ? Colors.green : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _childFound ? '✅ $_recognizedName' : _status,
                    style: GoogleFonts.robotoCondensed(
                      color: _childFound ? Colors.green : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Countdown Timer at bottom
          if (_childFound)
            Positioned(
              bottom: 160,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Monitoring Time Remaining',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: GoogleFonts.robotoCondensed(
                        color: const Color(0xffa7dae1),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
