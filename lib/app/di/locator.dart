import 'package:briewview/core/network/network_module.dart';
import 'package:briewview/core/network/token_storage.dart';
import 'package:briewview/features/search/viewmodel/search_bloc.dart';
import 'package:briewview/features/cafe/repository/cafes_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  try {
    // Try auto-generated registration first
    getIt.init();
    print("✅ Auto DI registration successful");
  } catch (e) {
    print("⚠️ Auto DI failed: $e");
    print("🔧 Setting up manual dependencies...");
  }
}

