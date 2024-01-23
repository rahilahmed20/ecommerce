import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macstore/controllers/banners_controller.dart';

class BannerArea extends StatelessWidget {
  const BannerArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BannerController bannerController = Get.find<BannerController>();

    double spacing = MediaQuery.of(context).size.width < 600 ? 16.0 : 32.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 230,
      padding: EdgeInsets.fromLTRB(spacing, spacing, spacing, 0.0),
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<List<String>>(
        stream: bannerController.getBannerUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            print('Error fetching banners: ${snapshot.error}');
            return Icon(Icons.error);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No banners found.');
            return Center(
              child: Text(
                'No banners available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return Column(
              children: [
                CarouselSlider.builder(
                  itemCount:
                      snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                  itemBuilder: (context, index, realIndex) {
                    return BannerWidget(
                      imageUrl: snapshot.data![index],
                    );
                  },
                  options: CarouselOptions(
                    height: 170,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      bannerController.updateCurrentBanner(index);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                      (index) => Container(
                        height: 5,
                        width: 17,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                bannerController.carousalCurrentIndex.value ==
                                        index
                                    ? Colors.blue
                                    : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final String imageUrl;

  BannerWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: 350,
        errorWidget: (context, url, error) => Icon(
          Icons.error,
        ),
      ),
    );
  }
}
