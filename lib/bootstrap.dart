import 'dart:async';
import 'dart:developer';

import 'package:crystal_ball/game/game.dart';
import 'package:crystal_ball/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    if (bloc is ScoreCubit) {
      return;
    }

    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    print(details.stack);
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;

  Bloc.observer = AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final macondo = await rootBundle.loadString(Assets.licenses.macondo.ofl);
    yield LicenseEntryWithLineBreaks(['macondo'], macondo);
  });

  runApp(await builder());
}
