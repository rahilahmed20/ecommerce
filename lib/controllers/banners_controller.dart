import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // RxList to hold banner URLs
  final bannerUrls = RxList<String>();

  // Observable to track the current index of the carousel
  final carousalCurrentIndex = 0.obs;

  // Function to update the current banner index
  void updateCurrentBanner(index) {
    carousalCurrentIndex.value = index;
  }

  // Stream to get banner URLs from Firestore
  Stream<List<String>> getBannerUrls() {
    return _firestore
        .collection('banners')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['image'] as String).toList();
    }).handleError((error) {
      // Handle errors during stream subscription
      print('Error fetching banner URLs: $error');
      // You can add additional error handling logic or show a message to the user
    });
  }
}
