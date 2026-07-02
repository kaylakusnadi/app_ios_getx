import 'package:get/get.dart';
import '../data/services/api_service.dart';
import '../data/repositories/user_repository.dart';
import '../presentation/controllers/user_controller.dart';

// Updated: 2026-07-02 by Kayla
// Change: Membuat DashboardBinding
// Reason: Memenuhi AC RND-150 terkait penggunaan GetX Binding untuk menyuntikkan Repository dan Controller
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Repository dengan memasukkan ApiService yang sudah ada
    Get.lazyPut<UserRepository>(() => UserRepository(apiService: Get.find<ApiService>()));
    // Inject Controller dengan memasukkan UserRepository
    Get.lazyPut<UserController>(() => UserController(repository: Get.find<UserRepository>()));
  }
}