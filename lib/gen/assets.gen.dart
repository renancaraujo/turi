/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $GoogleFontsGen {
  const $GoogleFontsGen();

  /// File path: google_fonts/Macondo-Regular.ttf
  String get macondoRegular => 'google_fonts/Macondo-Regular.ttf';

  /// List of all assets
  List<String> get values => [macondoRegular];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bgrockbase.png
  AssetGenImage get bgrockbase =>
      const AssetGenImage('assets/images/bgrockbase.png');

  /// File path: assets/images/bgrockpillar.png
  AssetGenImage get bgrockpillar =>
      const AssetGenImage('assets/images/bgrockpillar.png');

  /// File path: assets/images/bottomRocks1.png
  AssetGenImage get bottomRocks1 =>
      const AssetGenImage('assets/images/bottomRocks1.png');

  /// File path: assets/images/rocksl.png
  AssetGenImage get rocksl => const AssetGenImage('assets/images/rocksl.png');

  /// File path: assets/images/rocksl2.png
  AssetGenImage get rocksl2 => const AssetGenImage('assets/images/rocksl2.png');

  /// File path: assets/images/rocksr.png
  AssetGenImage get rocksr => const AssetGenImage('assets/images/rocksr.png');

  /// File path: assets/images/turilogo.png
  AssetGenImage get turilogo =>
      const AssetGenImage('assets/images/turilogo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        bgrockbase,
        bgrockpillar,
        bottomRocks1,
        rocksl,
        rocksl2,
        rocksr,
        turilogo
      ];
}

class $AssetsLicensesGen {
  const $AssetsLicensesGen();

  $AssetsLicensesMacondoGen get macondo => const $AssetsLicensesMacondoGen();
}

class $AssetsLicensesMacondoGen {
  const $AssetsLicensesMacondoGen();

  /// File path: assets/licenses/macondo/OFL.txt
  String get ofl => 'assets/licenses/macondo/OFL.txt';

  /// List of all assets
  List<String> get values => [ofl];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLicensesGen licenses = $AssetsLicensesGen();
  static const $GoogleFontsGen googleFonts = $GoogleFontsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
