import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macstore/models/product_models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart({
    required String productName,
    required num productPrice,
    required String categoryName,
    required List imageUrl,
    required int quantity,
    required String productId,
    required String productSize,
    required num discount,
    required String description,
    required int totalQuantity,
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productId: state[productId]!.productId,
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          categoryName: state[productId]!.categoryName,
          quantity: state[productId]!.quantity + 1,
          imageUrl: state[productId]!.imageUrl,
          productSize: state[productId]!.productSize,
          discount: state[productId]!.discount,
          description: state[productId]!.description,
          totalQuantity: state[productId]!.totalQuantity,
        )
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
            productName: productName,
            productPrice: productPrice,
            categoryName: categoryName,
            imageUrl: imageUrl,
            quantity: quantity,
            productId: productId,
            productSize: productSize,
            discount: discount,
            description: description,
            totalQuantity: totalQuantity)
      };
    }
  }

  Map<String, CartModel> get getCartItems => state;

  List<CartModel> getAllCartItems() {
    return state.values.toList();
  }

  void clearCart() {
    state = {}; // Reset the state to an empty map
  }

  void decrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      // notify listeners that the state has changed
      state = {...state};
    }
  }

  void removeItem(String productId) {
    state.remove(productId);

    state = {...state};
  }

  void incrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      // notify listeners that the state has changed
      state = {...state};
    }
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.discount;
    });

    return totalAmount;
  }
}
