import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as Img;

class ParticlesContainer extends StatefulWidget {
  final Widget child;

  final int layerNumbers;

  final Duration duration;
  final Animation animation;

  const ParticlesContainer({
    Key key,
    @required this.child,
    this.layerNumbers,
    this.duration,
    this.animation,
  })  : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParticlesContainerState();
  }
}

class _ParticlesContainerState extends State<ParticlesContainer> with TickerProviderStateMixin {
  GlobalKey _key = GlobalKey(debugLabel: 'container');

  List<Widget> layers = [];

  AnimationController _mainController;

  bool isShow;

  Animation _animation;

  @override
  void initState() {
    super.initState();
    isShow = true;
    _mainController = AnimationController(vsync: this, duration: widget.duration ?? Duration(seconds: 2));
    _animation =
        widget.animation ?? CurvedAnimation(parent: _mainController, curve: Interval(0, 1, curve: Curves.easeOut));
    _mainController.addStatusListener(_statusListener);
  }

  @override
  void dispose() {
    super.dispose();

    _mainController.removeStatusListener(_statusListener);
    _mainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = GestureDetector(
      onTap: () {
        blow();
      },
      child: RepaintBoundary(
        key: _key,
        child: Visibility(
          visible: isShow,
          child: widget.child,
        ),
      ),
    );
    return Stack(
      children: [
        ...layers,
        child,
      ],
    );
  }

  Future<Img.Image> _parseImage() async {
    RenderRepaintBoundary render = _key.currentContext.findRenderObject();
    var img = await render.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    return Img.decodeImage(pngBytes);
  }

  Future<void> blow() async {
    // 获取到完整的图像
    Img.Image fullImage = await _parseImage();

    // 获取原图的宽高
    int width = fullImage.width;
    int height = fullImage.height;

    // 初始化与原图相同大小的空白的图层
    List<Img.Image> blankLayers = List.generate(10, (i) => Img.Image(width, height));

    // 将原图的像素点，分布到layer中
    separatePixels(blankLayers, fullImage, width, height);

    // 将图层转换为Widget
    layers = blankLayers.map((layer) => imageToWidget(layer)).toList();

    // 刷新页面
    setState(() {
      isShow = false;
    });

    // 开始动画
    await _mainController.forward();
    if (_mainController.isCompleted) {
      _mainController.reset();
      isShow = true;
      layers = [];
      setState(() {});
    }
  }

  void separatePixels(List<Img.Image> blankLayers, Img.Image fullImage, int width, int height) {
    // 遍历所有的像素点
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        // 获取当前的像素点
        int pixel = fullImage.getPixel(x, y);
        // 如果当前像素点是透明的  则直接continue 减少不必要的浪费
        if (0 == pixel) continue;

        // 随机生成放入的图层index
        int index = Random().nextInt(10);
        // 将像素点放入图层
        blankLayers[index].setPixel(x, y, pixel);
      }
    }
  }

  Widget imageToWidget(Img.Image png) {
    // 先将Image 转换为 Uint8List 格式
    Uint8List data = Uint8List.fromList(Img.encodePng(png));

    // 定义位移变化的插值（始末偏移量）
    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      // 基础偏移量+随机偏移量
      end: Offset(50, -20) + Offset(30, 30).scale((Random().nextDouble() - 0.5) * 2, (Random().nextDouble() - 0.5) * 2),
    ).animate(_animation);

    return AnimatedBuilder(
      animation: _mainController,
      child: Image.memory(data),
      builder: (context, child) {
        // 位移动画
        return Transform.translate(
          offset: offsetAnimation.value,
          // 渐隐动画
          child: Opacity(
            opacity: cos(_animation.value * pi / 2), // 1 => 0
            child: child,
          ),
        );
      },
    );
  }

  void _statusListener(AnimationStatus status) {}
}
