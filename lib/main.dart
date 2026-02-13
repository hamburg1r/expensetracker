import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

// Import the single aggregated provider list
import 'package:expensetracker/di/app_providers.dart';

// ... other necessary imports for widgets within MyApp and HomeScreen
import 'package:expensetracker/bloc/index_cubit.dart';
import 'package:expensetracker/screens/overview.dart';
import 'package:expensetracker/screens/people.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const App(),
  );
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
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          );
        }
        return MultiProvider(
          providers: appProviders, // <<< Use the aggregated list
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "NoteQuest",
            theme: ThemeData(
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(colorScheme: darkColorScheme),
            themeMode: ThemeMode.system,
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

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

    final Widget child;

    switch (index) {
      case 0:
        child = OverviewScreen(appBar);
        break;
      case 1:
        child = PeopleScreen(
          appBar,
        );
        break;
      default:
        child = Scaffold(
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

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).focusColor,
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
