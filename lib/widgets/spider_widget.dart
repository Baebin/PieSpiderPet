import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_spider_pet/entity/spider.dart';
import 'package:pie_spider_pet/entity/window.dart';
import 'package:pie_spider_pet/utils/image_path.dart';

class SpiderWidget extends ConsumerStatefulWidget {
  const SpiderWidget({
    super.key,
    required this.spider,
    this.leftEyeXWeight, this.leftEyeYWeight,
    this.rightEyeXWeight, this.rightEyeYWeight
  });

  final Spider spider;

  final double? leftEyeXWeight, leftEyeYWeight;
  final double? rightEyeXWeight, rightEyeYWeight;

  @override
  ConsumerState<SpiderWidget> createState() => _SpiderWidgetState(spider);
}

class _SpiderWidgetState extends ConsumerState<SpiderWidget> {
  _SpiderWidgetState(this.spider);

  final Spider spider;

  final double weight = 1.0;

  final Window _bodySize = Window(width: (126.4), height: (96.1));
  final Window _eyeSize = Window(width: 55.3, height: 51.8);
  final Window _legSize = Window(width: (101.5)/1.5, height: 47.8);

  Widget _buildImage({ required Window size, required String image }) {
    return SizedBox(
      width: size.width * weight,
      height: size.height * weight,
      child: Image.asset(
        image,
      ),
    );
  }

  // Positioned 사용 시에 FittedBox 사용 불가 -> 커스텀 위젯으로 대체
  Widget _buildPositionedWidget({ double top = 0.0, double left = 0.0, required Widget widget }) {
    return Column(
      children: [
        SizedBox(height: top),
        Row(
          children: [
            SizedBox(width: left),
            widget,
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    double left = 1.2 * (_legSize.width * weight)/2;
    return _buildPositionedWidget(
      left: left,
      widget: _buildImage(
        size: _bodySize,
        image: ImagePath.spiderBody,
      ),
    );
  }

  Widget _buildWhiteEyes() {
    double left = 1.2 * (_legSize.width * weight)/2 + (_eyeSize.width * weight)/2;
    double top = (_eyeSize.height * weight)/2;
    return Stack(
      children: [
        _buildPositionedWidget(
          top: top,
          left: left,
          widget: _buildImage(
            size: _eyeSize,
            image: ImagePath.spiderEyeWhite,
          ),
        ),
        _buildPositionedWidget(
          top: top,
          left: left + (_bodySize.width * weight)/3,
          widget: _buildImage(
            size: _eyeSize,
            image: ImagePath.spiderEyeWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildBlackEyes({
    // Left Black Eye's X Weight [0.0, 100.0](left, right)
    required double lxw,
    // Left Black Eye's Y Weight [0.0, 100.0](bottom, top)
    required double lyw,
    // Right Black Eye's X Weight [0.0, 100.0](left, right)
    required double rxw,
    // Right Black Eye's Y Weight [0.0, 100.0](bottom, top)
    required double ryw,
  }) {
    double top = (_eyeSize.height * weight)/2;
    double left = 1.2 * (_legSize.width * weight)/2 + (_eyeSize.width * weight)/1.5;
    return Stack(
      children: [
        _buildPositionedWidget(
          top: top + (0.4 - (lyw/100) * 0.8) * top,
          left: left - ((100.0 - lxw) / 100.0) * (_eyeSize.width * weight)/3.0,
          widget: _buildImage(
            size: _eyeSize,
            image: ImagePath.spiderEyeBlack,
          ),
        ),
        _buildPositionedWidget(
          // 0.4(bottom) -> -0.4(top) : 0 -> 100
          top: top + (0.4 - (ryw/100) * 0.8) * top,
          // 5.0(left) -> 3.0(right) : 0 -> 100
          left: left + (_bodySize.width * weight)/5.0 + (rxw) * ((_bodySize.width * weight)/3.0 - (_bodySize.width * weight)/5.0)/100,
          widget: _buildImage(
            size: _eyeSize,
            image: ImagePath.spiderEyeBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildLegs() {
    double top = (_bodySize.height * weight)/10;
    double left = (_legSize.width * weight)/20;

    double right = 1.2 * (_legSize.width * weight) + (_bodySize.width * weight)/2;

    return Stack(
      children: [
        // Left
        _buildPositionedWidget(
          top: top,
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegLeft,
          ),
        ),
        _buildPositionedWidget(
          top: 3 * top,
          left: left,
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegLeft,
          ),
        ),
        _buildPositionedWidget(
          top: 5 * top,
          left: 2 * left,
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegLeft,
          ),
        ),

        // Right
        _buildPositionedWidget(
          top: top,
          left: right - left,
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegRight,
          ),
        ),
        _buildPositionedWidget(
          top: 3 * top,
          left: right - (2 * left),
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegRight,
          ),
        ),
        _buildPositionedWidget(
          top: 5 * top,
          left: right - (3 * left),
          widget: _buildImage(
            size: _legSize,
            image: ImagePath.spiderLegRight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spider.size.width,
      height: spider.size.height,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Stack(
          children: [
            _buildLegs(),
            _buildBody(),
            _buildWhiteEyes(),
            _buildBlackEyes(
                lxw: widget.leftEyeXWeight ?? 100.0, lyw: widget.leftEyeYWeight ?? 50.0,
                rxw: widget.rightEyeXWeight ?? 100.0, ryw: widget.rightEyeYWeight ?? 50.0
            ),
          ],
        ),
      ),
    );
  }
}
