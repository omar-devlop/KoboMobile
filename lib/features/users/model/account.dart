import 'dart:convert';

class Account {
  String username;
  String password;
  String serverUrl;

  Account({
    required this.username,
    required this.password,
    required this.serverUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'username': username, 'serverUrl': serverUrl};
  }

  String toKey() => '$username@$serverUrl';

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      username: map['username'] as String,
      password: '',
      serverUrl: map['serverUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Account(username: $username, password: $password, serverUrl: $serverUrl)';
}
