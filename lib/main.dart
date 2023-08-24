import 'dart:io';

import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/categories/category_bloc.dart';
import 'package:fashionstore/bloc/productAddToCartSelection/product_add_to_cart_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/presentation/screens/initial_loading_page.dart';
import 'package:fashionstore/presentation/screens/login_page.dart';
import 'package:fashionstore/repository/authentication_repository.dart';
import 'package:fashionstore/repository/cart_repository.dart';
import 'package:fashionstore/repository/category_repository.dart';
import 'package:fashionstore/repository/google_drive_repository.dart';
import 'package:fashionstore/repository/shop_repository.dart';
import 'package:fashionstore/repository/translator_repository.dart';
import 'package:fashionstore/utils/local_storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/productDetails/product_details_bloc.dart';
import 'bloc/productSearching/product_searching_bloc.dart';
import 'bloc/products/product_bloc.dart';
import 'config/http_client_config.dart';
import 'data/enum/local_storage_key_enum.dart';

void main() {
  HttpOverrides.global = HttpClientConfig();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository()),
      RepositoryProvider<ShopRepository>(create: (context) => ShopRepository()),
      RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository()),
      RepositoryProvider<CartRepository>(create: (context) => CartRepository()),
      RepositoryProvider<TranslatorRepository>(
          create: (context) => TranslatorRepository()),
      RepositoryProvider<GoogleDriveRepository>(
          create: (context) => GoogleDriveRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
                RepositoryProvider.of<CategoryRepository>(context))),
        BlocProvider<ProductBloc>(
            create: (context) =>
                ProductBloc(RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductSearchingBloc>(
            create: (context) => ProductSearchingBloc(
                RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductDetailsBloc>(
            create: (context) => ProductDetailsBloc(
                RepositoryProvider.of<ShopRepository>(context))),
        BlocProvider<ProductAddToCartBloc>(
            create: (context) => ProductAddToCartBloc()),
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                RepositoryProvider.of<AuthenticationRepository>(context))),
        BlocProvider<CartBloc>(
            create: (context) =>
                CartBloc(RepositoryProvider.of<CartRepository>(context))),
        BlocProvider<TranslatorBloc>(
            create: (context) => TranslatorBloc(
                RepositoryProvider.of<TranslatorRepository>(context))),
        BlocProvider<UploadFileBloc>(
            create: (context) => UploadFileBloc(
                RepositoryProvider.of<GoogleDriveRepository>(context))),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _savedUserName = '';
  String _savedPassword = '';
  late Future<void> _determineHomePageFuture;
  late Widget initPage;

  Future<void> _determineHomePage() async {
    _savedUserName = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_USER_NAME.name,
    ) as String;
    _savedPassword = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_PASSWORD.name,
    ) as String;

    if (_savedPassword != '' && _savedUserName != '') {
      BlocProvider.of<AuthenticationBloc>(context).add(
        OnLoginAuthenticationEvent(
          _savedUserName,
          _savedPassword,
        ),
      );

      initPage = const InitialLoadingPage();
    } else {
      initPage = const LoginPage();
    }
  }

  @override
  void initState() {
    _determineHomePageFuture = _determineHomePage();

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _determineHomePageFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: initPage,
            );
          }
        });
  }
}
