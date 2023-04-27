import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
   await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    ELSize.initialize();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      builder: (context, myWidget) {
        ScreenUtil.init(context);
        
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 13.sp)),
          ),
          child: myWidget!,
        );
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  _onRefresh() async {
    Future.delayed(Duration(seconds: 1)).then((value) {
      refreshController.refreshCompleted();
    });
  }

  _onLoading() async {
    Future.delayed(Duration(seconds: 1)).then((value) {
      refreshController.loadNoData();
    });
  }

  @override
  Widget build(BuildContext context) {

     ScreenUtil.init(context,
        designSize: Size(ELSize.setDprSize(375), ELSize.setDprSize(812)));
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          header: WaterDropHeader(),
          child: SingleChildScrollView(
            child: Column(
              children: [1, 2, 3, 4, 5, 6]
                  .map((e) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.red,
                        child: Center(child: Text(e.toString())),
                      ))
                  .toList(),
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}



class ELSize {
  // 像素宽高
  static late double physicalWidth;
  static late double physicalHeight;

  // 实际尺寸
  static late double screenWidth;
  static late double screenHeight;
  static late double statusHeight;
  static late double navHeight;
  static late double safeHeight;
  static late double tabBarHeight;

  // 是否是刘海屏
  static late bool isIPhoneX;

  // 像素比例
  static late double dpr;

  static void initialize() {
    // 手机的物理sc
    physicalWidth = window.physicalSize.width;

    physicalHeight = window.physicalSize.height;

    dpr = window.devicePixelRatio;

    screenWidth = physicalWidth / dpr;

    screenHeight = physicalHeight / dpr;

    statusHeight = window.padding.top / dpr;

    isIPhoneX = screenHeight >= 812;
    navHeight = statusHeight + 44;
    tabBarHeight = isIPhoneX ? 83 : 49;
    safeHeight = isIPhoneX ? 34 : 0;
  }

  // 设置对应比例的尺寸
  static double setDprSize(double size) {
    return (dpr - 3) * 45 + size;
  }
}
