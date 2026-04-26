import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdaptiveAssetImage extends StatelessWidget {
  const AdaptiveAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.errorBuilder,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final ImageErrorWidgetBuilder? errorBuilder;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  Widget _fallback(BuildContext context, Object error, StackTrace? stackTrace) {
    if (errorBuilder != null) {
      return errorBuilder!(context, error, stackTrace);
    }
    return SizedBox(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _fallback(context, snapshot.error!, snapshot.stackTrace);
          }
          if (!snapshot.hasData) {
            return SizedBox(width: width, height: height);
          }
          return SvgPicture.string(
            snapshot.data!,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
          );
        },
      );
    }
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder,
    );
  }
}
