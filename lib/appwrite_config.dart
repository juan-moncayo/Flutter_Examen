import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static String get endpoint =>
      dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://fra.cloud.appwrite.io/v1';
  static String get projectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? 'examenf';
  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID'] ?? 'dbf';
  static String get collectionId =>
      dotenv.env['APPWRITE_COLLECTION_ID'] ?? 'medicamentos';

  static Client getClient() {
    Client client = Client();
    client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true);
    return client;
  }
}
