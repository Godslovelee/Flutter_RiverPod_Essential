import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demff',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage2() //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

final valueProvider = Provider<int>((ref) {
  return 2;
});

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //final value = watch(valueProvider);
    final counter = watch(counterStateProvider);

    return ProviderListener<StateController<int>>(
        provider: counterStateProvider,
        onChange: (context, counterState) => {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Value is ${counterState.state}')))
            },
        child: Scaffold(
            body: Center(
              child: Consumer(builder: (context, ScopedReader watch, child) {
                return Text('Okay here is: ${counter.state}');
              }),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () => context.read(counterStateProvider).state++,
                child: Icon(Icons.add))));
  }
}

//storing the state outside the class widget tree
class ClockClass extends StateNotifier<DateTime> {
  ClockClass() : super(DateTime.now()) {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
  }

  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final clockProvider = StateNotifierProvider<ClockClass>((ref) {
  return new ClockClass();
});

class MyHomePage2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final currentTime = watch(clockProvider.state);
    final timeFormat = DateFormat.Hms().format(currentTime);
    return Scaffold(
      body: Center(
        child: Text("This is : $timeFormat"),
      ),
    );
  }
}

final futureProvider = FutureProvider.autoDispose<int>((ref) async {
  return Future.value(89);
});

final streamProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream.fromIterable([1, 2, 3, 4]);
});

//creating homepage3 for future-provider user

class MyHomePage3 extends ConsumerWidget {
  //const MyHomePage3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final streamValue = watch(streamProvider);
    return Scaffold(
      body: Center(
          child: streamValue.when(
              data: (data) => Text("data shown is: $data"),
              loading: () => CircularProgressIndicator(),
              error: (e, str) => Text('Error: $e'))),
    );
  }
}
