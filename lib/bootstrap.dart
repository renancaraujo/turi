import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crystal_ball/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
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
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final poppins = await rootBundle.loadString(Assets.licenses.poppins.ofl);
    yield LicenseEntryWithLineBreaks(['poppins'], poppins);
  });



  runApp(await builder());
}
