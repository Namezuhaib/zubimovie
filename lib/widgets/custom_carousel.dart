import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zubimovie/common/utils.dart'; // contains baseImageUrl
import 'package:zubimovie/models/tv_series_model.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({super.key, required this.data});
  final TvSeriesModel data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = (size.height * 0.33 < 300) ? 300 : size.height * 0.33;

    final items = data.results
        .where((r) => r.backdropPath != null && r.backdropPath!.isNotEmpty)
        .toList();

    if (items.isEmpty) {
      return SizedBox(width: size.width, height: height);
    }

    return SizedBox(
      width: size.width,
      height: height,
      child: CarouselSlider.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final item = items[index];
          final fullImageUrl =
              '$imageUrl${item.backdropPath}'; // <-- correct usage

          return GestureDetector(
            onTap: () {
              // Navigate or show details
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: fullImageUrl,
                    width: size.width * 0.9,
                    height: height,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(
                      item.name.isNotEmpty
                          ? item.name
                          : (item.originalName.isNotEmpty
                                ? item.originalName
                                : 'No Title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: height,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
