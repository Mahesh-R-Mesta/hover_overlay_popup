import 'package:flutter/material.dart';
import 'package:hover_overlay_popup/hover_overlay_popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hover overlay popup',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
          appBarTheme: const AppBarTheme(color: Colors.amber, foregroundColor: Colors.white)),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final text =
      "Lorem ipsum dolor sit amet, eu detraxit scriptorem disputando eam, eu quot mediocrem quo. Ex etiam essent ceteros pri. Nam ponderum deseruisse te. Inani democritum est no. Blandit sadipscing pro te.";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hover overlay popup", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        ),
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              HoverOverlayPopup(
                windowSize: const Size(200, 300),
                triggerMode: TriggerMode.onHover,
                direction: Direction.bottom,
                color: Colors.amber[50],
                child: const Text("Hover on me", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                builder: (close) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          ElevatedButton(onPressed: () => close.call(), child: const Text("Accepted"))
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
