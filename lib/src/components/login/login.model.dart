import 'package:equatable/equatable.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class LoginModel extends MomentumModel<LoginController> with EquatableMixin {
  LoginModel(LoginController controller, {this.isLoggedIn}) : super(controller);

  final bool isLoggedIn;

  @override
  void update({bool isLoggedIn}) {
    LoginModel(controller, isLoggedIn: isLoggedIn ?? this.isLoggedIn)
        .updateMomentum();
  }


  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
    };
  }

  LoginModel fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return LoginModel(
      controller,
      isLoggedIn: json['isLoggedIn'],
    );
  }

  @override
  List<Object> get props => [
        isLoggedIn,
      ];
}