import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/device_controller.dart';
import 'controllers/test_controller.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'services/alcohol_device_service.dart';
import 'services/app_info.dart';
import 'services/card_reader_service.dart';
import 'services/test_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appInfo = await AppInfo.load();
  runApp(AlcoholDetectorApp(appInfo: appInfo));
}

class AlcoholDetectorApp extends StatelessWidget {
  const AlcoholDetectorApp({super.key, required this.appInfo});

  final AppInfo appInfo;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppInfo>.value(value: appInfo),
        ChangeNotifierProvider(
          create: (_) => DeviceController(
            alcoholService: MockAlcoholDeviceService(),
            cardReaderService: MockCardReaderService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              TestController(repository: InMemoryTestRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
