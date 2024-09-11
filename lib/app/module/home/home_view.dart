import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixa_gallery_app/app/module/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:pixa_gallery_app/app/module/image_view/image_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Pixa Gal')),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildImageGrid(context)),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search images...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.debounce(
            () => controller.resetSearch(),
            duration: const Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  int _getColumnCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 2; // Small screens (phones)
    } else if (screenWidth < 900) {
      return 3; // Medium screens (large phones, small tablets)
    } else if (screenWidth < 1200) {
      return 4; // Large screens (tablets, small laptops)
    } else if (screenWidth < 1800) {
      return 5; // Extra large screens (desktops)
    } else {
      return 6; // Very large screens
    }
  }

  Widget _buildImageGrid(BuildContext context) {
    return Obx(() {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.extentAfter == 0) {
            controller.searchImages();
          }
          return true;
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getColumnCount(context),
            childAspectRatio: 1.0,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: controller.images.length,
          itemBuilder: (context, index) {
            return _buildImageItem(controller.images[index]);
          },
        ),
      );
    });
  }

  Widget _buildImageItem(Map<String, dynamic> image) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(() => ImageView(imageUrl: image['largeImageURL'])),
        child: Hero(
          tag: image['largeImageURL'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: image['previewURL'],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Likes: ${image['likes']} Views: ${image['views']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
