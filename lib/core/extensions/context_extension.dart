
import 'package:dbestech_edu/core/common/app/providers/user_provider.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  UserProvider get userProvider => read<UserProvider>();

  LocalUserModel? get currentUser => userProvider.user;
}
