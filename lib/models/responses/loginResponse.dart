class LoginResponse {
  String tokenType;
  String accessToken;
  String username;
  String email;
  List<String> roles;

  LoginResponse(
      {this.tokenType,
      this.accessToken,
      this.username,
      this.email,
      this.roles});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    tokenType = json['tokenType'];
    accessToken = json['accessToken'];
    username = json['username'];
    email = json['email'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenType'] = this.tokenType;
    data['accessToken'] = this.accessToken;
    data['username'] = this.username;
    data['email'] = this.email;
    data['roles'] = this.roles;
    return data;
  }
}
