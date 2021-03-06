import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class BannerWidget extends StatefulWidget {
  final List<String> imagesList;
  final double height;
  final String type;
  BannerWidget({@required this.height, this.type='', this.imagesList});
  @override
  _WidgetState createState() => new _WidgetState(
    height: height,
    type: type,
    imagesList: imagesList,
  );
}

class _WidgetState extends State<BannerWidget> {
  List<String> imagesList = [];
  final double height;
  final String type;

  _WidgetState({this.height, this.type, this.imagesList});

  @override
  void initState () {
    super.initState();
    if (imagesList == null || imagesList.length == 0) {
      // 初始化 apifm 插件
      Apifm.init(apifmConfigSubDomain);
      // 读取启动图片数据
      banners();
    }
  }

  banners () async {
    var res = await Apifm.banners({
      'type': type
    });
    if (res['code'] == 0) {
      List<String> _imagesList = [];
      res['data'].forEach((pic) {
        _imagesList.add(pic['picUrl']);
      });
      setState(() {
        imagesList = _imagesList;
      });
    }
  }

  bannerClick(index){
    print(index); 
  }
  
  @override
  Widget build(BuildContext context) {
    if (imagesList.length == 0) {
      return new Container(
        color: Colors.grey,
        child: Center(
          child: Loading(indicator: BallPulseIndicator(), size: 100.0),
        ),
      );
    } else {
      return new Container(
        height: height,
        color: Colors.grey,
        child: new Swiper(
          itemBuilder: (BuildContext context,int index){
            return new Image.network(imagesList[index],fit: BoxFit.cover,);
          },
          itemCount: imagesList.length,
          loop: true,
          autoplay: true,
          pagination: new SwiperPagination(),
          onTap: bannerClick,
        ),
      );
    }
    
  }
}