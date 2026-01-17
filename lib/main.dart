import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_exposicao/core/providers/config_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_strategy/url_strategy.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  tz.initializeTimeZones();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appConfig = ref.watch(appConfigProvider);
    final companyName = appConfig.general.companyName;

    return MaterialApp.router(
      title: companyName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        fontFamily: 'system-ui',
      ),
      locale: const Locale('pt', 'BR'),
      routerConfig: router,
    );
  }
}
