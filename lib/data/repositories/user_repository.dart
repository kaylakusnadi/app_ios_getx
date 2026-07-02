import '../models/user_model.dart';
import '../models/user_detail_model.dart';
import '../services/api_service.dart';

// Updated: 2026-07-02 by Kayla
// Change: Membuat UserRepository
// Reason: Memisahkan layer service/datasource dengan controller sesuai ketentuan struktur Clean Architecture RND-150
class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<List<UserModel>> getUsers(int page) async {
    return await apiService.fetchUsers(page);
  }

  Future<UserDetailModel> getUserDetail(String username) async {
    return await apiService.fetchUserDetail(username);
  }
}