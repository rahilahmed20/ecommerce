import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macstore/controllers/category_controller.dart';
import 'package:macstore/views/screens/inner_screen/all_category_products_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    return Obx(
      () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: List.generate(
                  categoryController.categories.length > 8
                      ? 8
                      : categoryController.categories.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AllCategoryProductScreen(
                                categoryData:
                                    categoryController.categories[index],
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        width: 83,
                        height: 110,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Column(
                          children: [
                            Image.network(
                              categoryController
                                  .categories[index].categoryImage,
                              width: 57,
                              height: 57,
                              fit: BoxFit.cover,
                            ),
                            // Material(
                            //   type: MaterialType.transparency,
                            //   borderRadius: BorderRadius.circular(12),
                            //   clipBehavior: Clip.antiAlias,
                            //   child: InkWell(
                            //     onTap: () {},
                            //     overlayColor:
                            //         const MaterialStatePropertyAll<Color>(
                            //       Color(0x0c7f7f7f),
                            //     ),
                            //     child: Ink(
                            //       color: Colors.white,
                            //       width: 63,
                            //       height: 63,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              width: 83,
                              height: 40,
                              child: Text(
                                categoryController
                                    .categories[index].categoryName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
