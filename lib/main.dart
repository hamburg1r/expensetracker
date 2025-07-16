import 'package:dynamic_color/dynamic_color.dart';
import 'package:expensetracker/cubit/index_cubit.dart';
import 'package:expensetracker/objectbox.g.dart';
import 'package:expensetracker/screens/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p show join;

import 'screens/overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await getApplicationDocumentsDirectory();
  Store store = await openStore(directory: p.join(path.path, 'db'));
  runApp(App(store: store));
}

class App extends StatelessWidget {
  final Store store;
  const App({required this.store, super.key});

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
          lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
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
          darkTheme: ThemeData(colorScheme: darkColorScheme),
          themeMode: ThemeMode.system,
          home: BlocProvider(
            create: (BuildContext context) => IndexCubit(),
            child: HomeScreen(store: store),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Store store;
  const HomeScreen({required this.store, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  Widget _getScreen(int index) {
    appBar(
      Widget title, [
      List<Widget> actions = const [],
    ]) => AppBar(
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

    switch (index) {
      case 0:
        return OverviewScreen(appBar, widget.store);
      case 1:
        return PeopleScreen(appBar, widget.store);
      default:
        return Scaffold(
          body: Center(
            child: FittedBox(
              child: const Text(
                '?',
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Spacer(),
              ListTile(
                onTap: () {
                  if (context.read<IndexCubit>().state != 0) {
                    context.read<IndexCubit>().setIndex(0);
                  }
                  _advancedDrawerController.hideDrawer();
                },
                leading: Icon(Icons.notes),
                title: const Text('Overview'),
              ),
              ListTile(
                onTap: () {
                  if (context.read<IndexCubit>().state != 1) {
                    context.read<IndexCubit>().setIndex(1);
                  }
                  _advancedDrawerController.hideDrawer();
                },
                leading: Icon(Icons.contacts),
                title: const Text('People'),
              ),
              ListTile(
                onTap: () {
                  if (context.read<IndexCubit>().state != 2) {
                    context.read<IndexCubit>().setIndex(2);
                  }
                  _advancedDrawerController.hideDrawer();
                },
                // leading: Icon(Icons.calendar_month),
                title: const Text('Calendar'),
              ),
              ListTile(
                onTap: () {
                  if (context.read<IndexCubit>().state != 3) {
                    context.read<IndexCubit>().setIndex(3);
                  }
                  _advancedDrawerController.hideDrawer();
                },
                // leading: Icon(Icons.settings),
                title: const Text('Settings'),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
      child: BlocBuilder<IndexCubit, int>(
        builder: (BuildContext context, int index) {
          return _getScreen(index);
        },
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

class IndexStorage {
  int index = 0;

  void update(int value) {
    index = value;
  }

  void increment() {
    index++;
  }

  void decrement() {
    index--;
  }
}
