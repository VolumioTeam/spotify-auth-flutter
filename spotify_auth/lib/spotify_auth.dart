import 'spotify_auth_pigeon.g.dart';

class SpotifyAuth {
  static final SpotifyAuthApi _instance = SpotifyAuthApi();

  static Future<bool> canAuthenticateUsingSpotifyApp() =>
     _instance.canAuthenticateUsingSpotifyApp();

  static Future<AuthenticateReply> authenticate({
    required String clientId,
    required String redirectUri,
    required List<String> scopes,
  }) =>
     _instance.authenticate(AuthenticateRequest(clientId: clientId, redirectUri: redirectUri, scopes: scopes));
}
