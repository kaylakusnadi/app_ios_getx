import 'package:get/get.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_detail_model.dart';

// Updated: 2026-07-02 by Kayla
// Change: Modifikasi UserController untuk menggunakan UserRepository
// Reason: Mematuhi pemisahan layer antara controller dan data source (repository pattern)
class UserController extends GetxController {
  final UserRepository repository;
  
  UserController({required this.repository});

  var users = <UserModel>[].obs;
  var favoriteUsers = <UserModel>[].obs;
  var searchResult = Rxn<List<UserModel>>();
  var searchQuery = "".obs;
  var isUsersLoading = false.obs;
  var isDetailLoading = false.obs;
  var usersError = RxnString();
  var detailError = RxnString();
  
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

      // Menggunakan layer repository
      final newUsers = await repository.getUsers(currentPage);
      
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
      // Menggunakan layer repository
      final detail = await repository.getUserDetail(username);
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