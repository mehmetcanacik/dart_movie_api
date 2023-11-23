typedef TokenType = Map<String, dynamic>;

class TokenPair {
  final String aToken;
  final String rToken;

  const TokenPair({
    required this.aToken,
    required this.rToken,
  });
  TokenType toJson() => {
        'accessToken': aToken,
        'refreshToken': rToken,
      };
}
