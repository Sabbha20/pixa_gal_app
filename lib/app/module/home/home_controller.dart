import 'dart:ui';
import 'package:get/get.dart';
import 'package:pixa_gallery_app/app/data/pixabay_service.dart';
import 'dart:async';

class HomeController extends GetxController {
  final PixabayService _pixabayService = PixabayService();
  final RxList<Map<String, dynamic>> images = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  int _currentPage = 1;

  Future<void> searchImages() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final newImages =
          await _pixabayService.searchImages(searchQuery.value, _currentPage);
      images.addAll(newImages);
      _currentPage++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load images');
    } finally {
      isLoading.value = false;
    }
  }

  void resetSearch() {
    images.clear();
    _currentPage = 1;
    searchImages();
  }

  Timer? _debounce;

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 1000)}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(duration, callback);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
