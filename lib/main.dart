import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/presentation/screens/LoginPage.dart';
import 'package:fashionstore/repository/AuthenticationRepository.dart';
import 'package:fashionstore/repository/CartRepository.dart';
import 'package:fashionstore/repository/CategoryRepository.dart';
import 'package:fashionstore/repository/GoogleDriveRepository.dart';
import 'package:fashionstore/repository/ShopRepository.dart';
import 'package:fashionstore/repository/TranslatorRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/productDetails/product_details_bloc.dart';
import 'bloc/productSearching/product_searching_bloc.dart';
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
        RepositoryProvider<CartRepository>(
            create: (context) => CartRepository()
        ),
        RepositoryProvider<TranslatorRepository>(
            create: (context) => TranslatorRepository()
        ),
        RepositoryProvider<GoogleDriveRepository>(
            create: (context) => GoogleDriveRepository()
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
          BlocProvider<ProductSearchingBloc>(
              create: (context) => ProductSearchingBloc(
                  RepositoryProvider.of<ShopRepository>(context)
              )
          ),
          BlocProvider<ProductDetailsBloc>(
              create: (context) => ProductDetailsBloc(
                  RepositoryProvider.of<ShopRepository>(context)
              )
          ),
          BlocProvider<ProductAddToCartBloc>(
              create: (context) => ProductAddToCartBloc()
          ),
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  RepositoryProvider.of<AuthenticationRepository>(context)
              )
          ),
          BlocProvider<CartBloc>(
              create: (context) => CartBloc(
                  RepositoryProvider.of<CartRepository>(context)
              )
          ),
          BlocProvider<TranslatorBloc>(
              create: (context) => TranslatorBloc(
                  RepositoryProvider.of<TranslatorRepository>(context)
              )
          ),
          BlocProvider<UploadFileBloc>(
              create: (context) => UploadFileBloc(
                  RepositoryProvider.of<GoogleDriveRepository>(context)
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


