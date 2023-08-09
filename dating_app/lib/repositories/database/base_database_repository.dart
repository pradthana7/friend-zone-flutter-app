import '/models/models.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Stream<Chat> getChat(String chatId);
  Stream<List<User>> getUsersToSwipe(User user);
  Stream<List<User>> getUsers(User user);
  Stream<List<Match>> getMatches(User user);
  Stream<List<Chat>> getChats(String userId);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  );
  Future<void> updateUserMatch(String userId, String matchId);
  Future<void> addMessage(String chatId, Message message);
}
