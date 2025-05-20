import 'package:pigeon/pigeon.dart';

class AuthenticateRequest {
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  const AuthenticateRequest({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
  });
}

class AuthenticateReply {
  final String? code;
  final String? refreshToken;

  const AuthenticateReply({
    required this.code,
    required this.refreshToken,
  });
}

@HostApi()
abstract class SpotifyAuthApi {
  bool canAuthenticateUsingSpotifyApp();

  @async
  AuthenticateReply authenticate(AuthenticateRequest request);
}