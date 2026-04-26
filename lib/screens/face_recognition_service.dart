import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceRecognitionService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static List<double> extractFaceFeatures(Face face) {
    List<double> features = [];

    final landmarks = [
      FaceLandmarkType.leftEye,
      FaceLandmarkType.rightEye,
      FaceLandmarkType.noseBase,
      FaceLandmarkType.leftEar,
      FaceLandmarkType.rightEar,
      FaceLandmarkType.leftMouth,
      FaceLandmarkType.rightMouth,
      FaceLandmarkType.bottomMouth,
    ];

    for (final type in landmarks) {
      final landmark = face.landmarks[type];
      if (landmark != null) {
        features.add(landmark.position.x.toDouble());
        features.add(landmark.position.y.toDouble());
      } else {
        features.add(0.0);
        features.add(0.0);
      }
    }

    features.add(face.boundingBox.width);
    features.add(face.boundingBox.height);

    return features;
  }

  static Future<void> saveFaceData({
    required String childId,
    required String childName,
    required List<double> faceFeatures,
  }) async {
    await _db.collection('FaceData').doc(childId).set({
      'childId': childId,
      'childName': childName,
      'faceFeatures': faceFeatures,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Map<String, dynamic>>> getAllFaceData() async {
    final snapshot = await _db.collection('FaceData').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static double calculateSimilarity(
    List<double> features1,
    List<double> features2,
  ) {
    if (features1.length != features2.length) return 0.0;

    double sum = 0.0;
    for (int i = 0; i < features1.length; i++) {
      sum += pow(features1[i] - features2[i], 2);
    }

    double distance = sqrt(sum);

    double similarity = 1 / (1 + distance / 100);
    return similarity;
  }

  static Future<String> recognizeFace(List<double> currentFeatures) async {
    final allFaces = await getAllFaceData();

    String recognizedName = 'Unknown';
    double highestSimilarity = 0.0;

    const double threshold = 0.70;

    for (final faceData in allFaces) {
      final savedFeatures = List<double>.from(faceData['faceFeatures']);
      final similarity = calculateSimilarity(currentFeatures, savedFeatures);

      if (similarity > highestSimilarity && similarity >= threshold) {
        highestSimilarity = similarity;
        recognizedName = faceData['childName'];
      }
    }

    return recognizedName;
  }
}
