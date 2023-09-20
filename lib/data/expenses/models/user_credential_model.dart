
import 'dart:convert';

UserCredentialResponse userCredentialResponseFromJson(String str) => UserCredentialResponse.fromJson(json.decode(str));

class UserCredentialResponse {
  final String token;

  UserCredentialResponse({
    required this.token,
  });

  factory UserCredentialResponse.fromJson(Map<String, dynamic> json) => UserCredentialResponse(
    token: json["token"],
  );
}
class UserCredentialModel {
  final identity = "PN0MKw";
  final password = "HjiJYh11";

  UserCredentialModel();

  Map<String, dynamic> toJson() => {
    "identity": identity,
    "password": password,
  };

}
