import 'package:dynamic_color/dynamic_color.dart';
import 'package:expensetracker/screens/overview/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'model/main.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.initFlutter(path.path);
  await Hive.openBox<List<TransactionModel>>('transactions');
  runApp(ProviderScope(
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
          // (Optional) If applicable, harmonize custom colors.
          // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          // darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
          // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

          // _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "NoteQuest",
          theme: ThemeData(
            // primaryColor: MaterialAccentColor(accentColor),
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    int currentScreen = ref.watch(indexStorageProvider);
    var currentScreenNotifier = ref.read(indexStorageProvider.notifier);
    appBar(
      Widget title, [
      List<Widget> actions = const [],
    ]) =>
        AppBar(
          title: title,
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
          actions: actions,
        );
    var screens = <Widget>[
      Overview(
        appBar: appBar,
      ),
      Scaffold(
        appBar: appBar(Text('1')),
        body: Text('placeholder'),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () => print("Hello"),
          child: Icon(Icons.add),
        ),
      ),
    ];

    return AdvancedDrawer(
      backdrop: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).focusColor,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
        //   ),
        // ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: true,
      rtlOpening: false,
      openScale: 0.83,
      openRatio: 0.6,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 1.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              ListTile(
                onTap: () {
                  if (currentScreen != 0) {
                    setState(() {
                      currentScreenNotifier.update(0);
                    });
                  }
                },
                // leading: Icon(Icons.notes),
                title: Text('Overview'),
              ),
              ListTile(
                onTap: () {
                  if (currentScreen != 1) {
                    setState(() {
                      currentScreenNotifier.update(1);
                    });
                  }
                },
                // leading: Icon(Icons.folder),
                title: Text('Documents'),
              ),
              ListTile(
                onTap: () {
                  if (currentScreen != 2) {
                    setState(() {
                      currentScreenNotifier.update(2);
                    });
                  }
                },
                // leading: Icon(Icons.calendar_month),
                title: Text('Calendar'),
              ),
              ListTile(
                onTap: () {
                  if (currentScreen != 3) {
                    setState(() {
                      currentScreenNotifier.update(3);
                    });
                  }
                },
                // leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
      child: screens[currentScreen],
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

@riverpod
class IndexStorage extends _$IndexStorage {
  @override
  int build() {
    // Initial value
    return 0;
  }

  void update(int value) {
    state = value;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
