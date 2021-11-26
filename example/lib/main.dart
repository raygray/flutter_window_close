import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _alertShowing = false;
  var _index = 0;

  @override
  void initState() {
    super.initState();

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (_index == 0) {
        if (_alertShowing) return false;
        _alertShowing = true;

        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          _alertShowing = false;
                        },
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          _alertShowing = false;
                        },
                        child: const Text('No'))
                  ]);
            });
      } else if (_index == 1) {
        final result = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: "Really?",
          text: "Do you really want to quit?",
          positiveButtonTitle: "Quit",
          negativeButtonTitle: "Cancel",
        );
        return result == CustomButton.positiveButton;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_window_close')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: Radio<int>(
              groupValue: _index,
              value: 0,
              onChanged: (int? value) => setState(() => _index = value ?? 0),
            ),
            title: const Text('Confirm Closing Using Flutter'),
          ),
          ListTile(
            leading: Radio<int>(
              groupValue: _index,
              value: 1,
              onChanged: (int? value) => setState(() => _index = value ?? 1),
            ),
            title: const Text('Confirm Closing Using Native Alert Dialog'),
          ),
          ListTile(
            leading: Radio<int>(
              groupValue: _index,
              value: 2,
              onChanged: (int? value) => setState(() => _index = value ?? 2),
            ),
            title: const Text('No Confirm'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () => FlutterWindowClose.closeWindow(),
              child: const Text('Close Window')),
        ],
      )),
    );
  }
}
