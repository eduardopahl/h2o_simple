import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/main_tab_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa localização para português brasileiro
  await initializeDateFormatting('pt_BR', null);

  runApp(const ProviderScope(child: H2OSimpleApp()));
}

class H2OSimpleApp extends StatelessWidget {
  const H2OSimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'H2O Simple',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('pt', 'BR'),
      home: const MainTabView(),
    );
  }
}
