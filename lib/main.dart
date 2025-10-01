import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/main_tab_view.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/notification_service_provider.dart';
import 'presentation/providers/ad_service_provider.dart';
import 'presentation/controllers/first_launch_controller.dart';
import 'core/services/first_launch_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data for notifications
  tz.initializeTimeZones();

  runApp(const ProviderScope(child: H2OSyncApp()));
}

class H2OSyncApp extends ConsumerWidget {
  const H2OSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);

    // Inicializa serviços em background
    ref.watch(notificationServiceInitializerProvider);
    ref.watch(adServiceInitializerProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English (default)
        Locale('pt'), // Portuguese
      ],
      // Fallback para inglês se o idioma do sistema não for suportado
      localeResolutionCallback: (locale, supportedLocales) {
        // Se o idioma do sistema for português, use português
        if (locale?.languageCode == 'pt') {
          return const Locale('pt');
        }
        // Para todos os outros casos, use inglês como padrão
        return const Locale('en');
      },
      home: const FirstLaunchWrapper(),
    );
  }
}

class FirstLaunchWrapper extends ConsumerStatefulWidget {
  const FirstLaunchWrapper({super.key});

  @override
  ConsumerState<FirstLaunchWrapper> createState() => _FirstLaunchWrapperState();
}

class _FirstLaunchWrapperState extends ConsumerState<FirstLaunchWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = await FirstLaunchService.isFirstLaunch();

    setState(() {
      _isLoading = false;
    });

    if (isFirstLaunch) {
      // Aguarda um frame para garantir que o widget está construído
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FirstLaunchController.handleFirstLaunch(context, ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).loading),
            ],
          ),
        ),
      );
    }

    return const MainTabView();
  }
}
