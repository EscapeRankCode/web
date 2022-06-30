import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/pages/home/web_home_page.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  // Multi language
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
      translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'es',
        basePath: 'assets/locales',
      ));
  await flutterI18nDelegate.load(const Locale('es'));

  // Save actual Location into Shared Preferences
  _setCurrentPosition(_geolocatorPlatform);

  // Run the APP
  runApp(MyApp(flutterI18nDelegate: flutterI18nDelegate));
}

// ----------------------- LOCATION FUNCTIONS ---------------------------------
Future<void> _setCurrentPosition(GeolocatorPlatform _geolocatorPlatform) async {
  final hasPermission = await _handlePermission(_geolocatorPlatform);

  if (!hasPermission) {
    setLocationPreferences(null, null);
    return;
  }

  final position = await _geolocatorPlatform.getCurrentPosition();
  setLocationPreferences(position.latitude, position.longitude);
}

Future<bool> _handlePermission(GeolocatorPlatform _geolocatorPlatform) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return false;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return true;
}

Future<void> setLocationPreferences(double? latitude, double? longitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(latitude == null){
    prefs.remove("location.latitude");
    prefs.remove("location.longitude");
  }else{
    prefs.setDouble("location.latitude", latitude);
    prefs.setDouble("location.longitude", longitude!);
  }
}

// ------------------------ DEBUG FUNCTIONS -----------------------------------
initDevelopmentParams() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", "xosel0l0");
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  const MyApp({Key? key, required this.flutterI18nDelegate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initDevelopmentParams();
    return MaterialApp(
      title: 'EscapeRank',
      theme: ThemeData(
        backgroundColor: AppColors.blackBackGround,
        primaryColor: AppColors.primaryYellow,
        iconTheme: const IconThemeData(color: AppColors.white),
        cardColor: AppColors.greyDark,
      ),
      debugShowCheckedModeBanner: false,
      home: WebHomePage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _startApp() async {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.title)
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button to start the App:',
            ),
            Text(
              "HomePage",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startApp,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
