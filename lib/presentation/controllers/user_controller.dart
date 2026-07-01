import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_detail_model.dart';

// Updated: 2026-07-01 by Kayla
// Change: Penyatuan logika BLoC (Event, State, Bloc) ke dalam GetxController tunggal
// Reason: Standarisasi arsitektur GetX yang lebih ringan, pragmatis, dan mudah di-maintenance
class UserController extends GetxController {
  final ApiService apiService;
  UserController({required this.apiService});

  // State Variables (Reactive)
  var users = <UserModel>[].obs;
  var favoriteUsers = <UserModel>[].obs;
  var searchResult = Rxn<List<UserModel>>(); // Rxn untuk nullable
  var searchQuery = "".obs;
  var isUsersLoading = false.obs;
  var isDetailLoading = false.obs;
  var usersError = RxnString();
  var detailError = RxnString();
  
  // Non-reactive variables
  int currentPage = 1;
  bool hasReachedMax = false;
  var detailUser = Rxn<UserDetailModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      searchResult.value = null;
      searchQuery.value = "";
    } else {
      searchQuery.value = query;
      searchResult.value = users
          .where((user) => user.login.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchUserList({bool isRefresh = false}) async {
    if (hasReachedMax && !isRefresh) return;

    try {
      if (isRefresh) {
        isUsersLoading.value = true;
        users.clear();
        currentPage = 1;
        hasReachedMax = false;
        searchResult.value = null;
        searchQuery.value = "";
      } else if (users.isEmpty) {
        isUsersLoading.value = true;
      }

      final newUsers = await apiService.fetchUsers(currentPage);
      
      if (newUsers.isEmpty) {
        isUsersLoading.value = false;
        hasReachedMax = true;
      } else {
        final filteredNewUsers = newUsers.where((newUser) => 
            !users.any((existingUser) => existingUser.login == newUser.login)
        ).toList();

        isUsersLoading.value = false;
        users.addAll(filteredNewUsers);
        currentPage++;
        hasReachedMax = newUsers.length < 5;
      }
    } catch (e) {
      isUsersLoading.value = false;
      usersError.value = e.toString();
    }
  }

  Future<void> fetchUserDetail(String username) async {
    isDetailLoading.value = true;
    detailError.value = null;
    try {
      final detail = await apiService.fetchUserDetail(username);
      detailUser.value = detail;
    } catch (e) {
      detailError.value = e.toString();
    } finally {
      isDetailLoading.value = false;
    }
  }

  void toggleFavorite(dynamic userTarget) {
    UserModel userToToggle;
    if (userTarget is UserDetailModel) {
      userToToggle = UserModel(
        login: userTarget.login,
        id: 0, 
        avatarUrl: userTarget.avatarUrl,
      );
    } else {
      userToToggle = userTarget;
    }

    final isExist = favoriteUsers.any((element) => element.login == userToToggle.login);

    if (isExist) {
      favoriteUsers.removeWhere((element) => element.login == userToToggle.login);
    } else {
      favoriteUsers.add(userToToggle);
    }
  }
}