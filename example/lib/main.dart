import 'package:example/simple_actions.dart';
import 'package:flutter/material.dart';
import 'package:quick_action_bar/quick_action_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Action Bar Demo',
      debugShowCheckedModeBanner: false,
      /* light theme settings */
      theme: ThemeData(brightness: Brightness.light, extensions: {
        QuickActionBarStyle(
          selectionBackgroundColor: Colors.grey[300]!,
          textColor: Colors.white,
          disabledTextColor: Colors.grey[200],
        ),
      }),
      /* dark theme settings */
      darkTheme: ThemeData(brightness: Brightness.dark, extensions: {
        QuickActionBarStyle(
          selectionBackgroundColor: Colors.grey[700]!,
          textColor: Colors.white,
          disabledTextColor: Colors.grey[500],
        ),
      }),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  presentQuickActionBar(
                    context: context,
                    dataSource: SimpleActionsDataSource(actions: [
                      SimpleAction('1', '1', true),
                      SimpleAction('2', '2', true),
                      SimpleAction('3', '3', true),
                      SimpleAction('4', '4', true),
                      SimpleAction('5', '5', true),
                    ]),
                    onActionSelected: (context, action) {
                      debugPrint('Action selected: ${action.identifier}');
                      dismissQuickActionBar(context);
                    },
                  );
                },
                child: const Text('Present Action Bar')),
          ],
        ),
      ),
    );
  }
}
