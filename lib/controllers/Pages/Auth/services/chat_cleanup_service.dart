import '../../../Repos/local/secure_storage_helper.dart';

class ChatCleanupService {
  static Future<void> clearChatDataForUser(String userId) async {
    final historyKey = "chatHistory_$userId";
    final messagesKey = "chatMessages_$userId";

    final historyData = await SecureStorageHelper.readValueFromKey(key: historyKey);
    final messagesData = await SecureStorageHelper.readValueFromKey(key: messagesKey);

    print("===============================> Deleting chat history: $historyData");
    print("===============================> Deleting chat messages: $messagesData");

    await SecureStorageHelper.deleteValueFromKey(key: historyKey);
    await SecureStorageHelper.deleteValueFromKey(key: messagesKey);

    final deletedHistoryData = await SecureStorageHelper.readValueFromKey(key: historyKey);
    final deletedMessagesData = await SecureStorageHelper.readValueFromKey(key: messagesKey);

    print("===============================> Deleted chat history: $deletedHistoryData");
    print("===============================> Deleted chat messages: $deletedMessagesData");
  }
}
