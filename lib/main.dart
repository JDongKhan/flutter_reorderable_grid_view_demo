import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
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
  final _gridViewKey = GlobalKey();
  final PageController _pageController = PageController();
  late List<String> dataList;

  @override
  void initState() {
    dataList = List.generate(200, (index) => '$index');
    super.initState();
  }

  Widget _buildPageView() {
    return LayoutBuilder(builder: (context, cs) {
      double cellSize = 100;
      int column = cs.maxWidth ~/ cellSize;
      int row = cs.maxHeight ~/ cellSize;
      int itemsPerPage = column * row;
      int page = (dataList.length / itemsPerPage).ceil();
      return ReorderableBuilder(
        key: Key(_gridViewKey.toString()),
        scrollController: _pageController,
        onReorder: _handleReorder,
        builder: (children) {
          return PageView(
            key: _gridViewKey,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: List.generate(
              page,
              (index) {
                int start = index * itemsPerPage;
                int end = start + itemsPerPage;
                if (end >= children.length) end = children.length;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: column,
                      childAspectRatio: 1,
                    ),
                    children: children.sublist(start, end),
                  ),
                );
              },
            ),
            // overlapIndicator: false,
          );
        },
        children: _getGeneratedChildren(),
      );
    });
  }

  void _handleReorder(ReorderedListFunction reorderedListFunction) {
    setState(() {
      dataList = reorderedListFunction(dataList) as List<String>;
    });
  }

  List<Widget> _getGeneratedChildren() {
    return dataList.map((e) => _buildItem(e)).toList();
  }

  Widget _buildItem(String e) {
    return Container(
      key: Key(e),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        e,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _buildPageView(),
    );
  }
}
