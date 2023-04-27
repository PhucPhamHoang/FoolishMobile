import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/presentation/screens/HomePage.dart';
import 'package:fashionstore/repository/CategoryRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository()
        ),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              RepositoryProvider.of<CategoryRepository>(context)
            )
          ),

        ],
        child: const MyApp(),
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


