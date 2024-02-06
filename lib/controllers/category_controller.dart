import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macstore/models/category_models.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firestore.collection('categories').snapshots().listen((querySnapshot) {
      // Clear existing categories before updating the list
      categories.clear();

      // Update categories based on the new data from Firestore
      categories.assignAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CategoryModel(
            categoryName: data['categoryName'],
            categoryImage: data['image'],
          );
        }).toList(),
      );

      // Shuffle the categories
      categories.shuffle();

      // Now, you have shuffled categories in the 'categories' list.
    }, onError: (error) {
      // Handle errors during stream subscription
      print("Error fetching categories: $error");
      // You can add additional error handling logic or show a message to the user
    });
  }
}
