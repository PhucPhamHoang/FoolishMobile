import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/presentation/screens/LoginPage.dart';
import 'package:fashionstore/repository/AuthenticationRepository.dart';
import 'package:fashionstore/repository/CategoryRepository.dart';
import 'package:fashionstore/repository/ShopRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/products/product_bloc.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository()
        ),
        RepositoryProvider<ShopRepository>(
            create: (context) => ShopRepository()
        ),
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              RepositoryProvider.of<CategoryRepository>(context)
            )
          ),
          BlocProvider<ProductBloc>(
              create: (context) => ProductBloc(
                  RepositoryProvider.of<ShopRepository>(context)
              )
          ),
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  RepositoryProvider.of<AuthenticationRepository>(context)
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}


