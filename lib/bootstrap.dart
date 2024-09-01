import 'dart:async';

import 'package:crystal_ball/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final macondo = await rootBundle.loadString(Assets.licenses.macondo.ofl);
    yield LicenseEntryWithLineBreaks(['macondo'], macondo);
  });

  runApp(await builder());
}
