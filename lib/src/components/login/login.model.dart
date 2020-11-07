import 'package:equatable/equatable.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class LoginModel extends MomentumModel<LoginController> with EquatableMixin {
  LoginModel(LoginController controller, {this.isLoggedIn, this.accessToken})
      : super(controller);

  final bool isLoggedIn;
  final String accessToken;

  @override
  void update({bool isLoggedIn, String accessToken}) {
    LoginModel(
      controller,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'accessToken': accessToken,
    };
  }

  LoginModel fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return LoginModel(
      controller,
      isLoggedIn: json['isLoggedIn'],
      accessToken: json['accessToken']
    );
  }

  @override
  List<Object> get props => [
        isLoggedIn,
        accessToken,
      ];
}
