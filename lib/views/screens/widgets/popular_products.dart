import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macstore/views/screens/widgets/product_models.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('salesCount', isGreaterThan: 0) // Filter where salesCount is greater than 0
        .orderBy('salesCount', descending: true) // Sort by salesCount in ascending order
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length > 20 ? 20 : snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final popularProduct = snapshot.data!.docs[index];
              return ProductModel(
                productData: popularProduct,
              );
            },
          ),
        );
      },
    );
  }
}
