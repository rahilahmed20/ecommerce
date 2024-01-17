import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bannerUrls = RxList<String>();
  final carousalCurrentIndex = 0.obs;

  void updateCurrentBanner(index) {
    carousalCurrentIndex.value = index;
  }

  Stream<List<String>> getBannerUrls() {
    return _firestore
        .collection('banners')
        .orderBy('timestamp',
            descending: true) // Assuming 'timestamp' is your timestamp field
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['image'] as String).toList();
    });
  }
}
