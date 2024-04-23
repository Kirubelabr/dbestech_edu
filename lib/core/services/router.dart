import 'package:dbestech_edu/core/common/views/page_under_construction.dart';
import 'package:dbestech_edu/core/extensions/context_extension.dart';
import 'package:dbestech_edu/core/services/injection_container.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:dbestech_edu/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:dbestech_edu/src/auth/presentation/views/sign_in_screen.dart';
import 'package:dbestech_edu/src/auth/presentation/views/sign_up_screen.dart';
import 'package:dbestech_edu/src/dashboard/presentation/views/dashboard.dart';
import 'package:dbestech_edu/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:dbestech_edu/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:dbestech_edu/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
