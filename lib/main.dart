import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/main_tab_view.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  runApp(const ProviderScope(child: H2OSimpleApp()));
}

class H2OSimpleApp extends ConsumerWidget {
  const H2OSimpleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'H2O Simple',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: const Locale('pt', 'BR'),
      home: const MainTabView(),
    );
  }
}
