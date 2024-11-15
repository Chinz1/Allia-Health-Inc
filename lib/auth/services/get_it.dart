import 'package:allia_health_inc_test_app/auth/services/secure_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<SecureStorageService>(SecureStorageService());
  serviceLocator.registerSingleton<Dio>(Dio());
}
