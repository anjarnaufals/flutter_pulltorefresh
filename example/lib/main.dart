import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController = RefreshController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        title: const Text('SmartRefresher Example'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) => _tabController.animateTo(value),
          tabs: const [
            Tab(
              text: 'Tab 1',
            ),
            Tab(
              text: 'Tab 2',
            ),
            Tab(
              text: 'Tab 3',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              _refreshController.requestRefresh();
              await Future.delayed(Durations.extralong1);
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              _refreshController.requestLoading();
              await Future.delayed(Durations.extralong1);
              _refreshController.loadComplete();
            },
            controller: _refreshController,
            header: const ClassicHeader(),
            footer: const ClassicFooter(
              idleText: '',
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final height = MediaQuery.of(context).size.width;

                    return Card(
                      child: SizedBox(
                        height: height * .4,
                        child: Text('index - $index'),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          const Center(
            child: Text('TabView 2'),
          ),
          const Center(
            child: Text('TabView 3'),
          ),
        ],
      ),
    );
  }
}
