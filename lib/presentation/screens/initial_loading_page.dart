import 'package:auto_route/annotations.dart';
import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/presentation/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enum/local_storage_key_enum.dart';
import '../../utils/local_storage/local_storage_service.dart';
import '../../utils/render/ui_render.dart';
import 'index_page.dart';

@RoutePage()
class InitialLoadingPage extends StatefulWidget {
  const InitialLoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitialLoadingState();
}

class _InitialLoadingState extends State<InitialLoadingPage> {
  String _savedUserName = '';
  String _savedPassword = '';

  Future<void> _loginEvent() async {
    _savedUserName = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_USER_NAME.name,
    ) as String;
    _savedPassword = await LocalStorageService.getLocalStorageData(
      LocalStorageKeyEnum.SAVED_PASSWORD.name,
    ) as String;

    BlocProvider.of<AuthenticationBloc>(context).add(
      OnLoginAuthenticationEvent(
        _savedUserName,
        _savedPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loginEvent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, authenState) {
                  if (authenState is AuthenticationLoggedInState) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IndexPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else if (authenState is AuthenticationErrorState) {
                    Navigator.pop(context);
                    UiRender.showDialog(context, '', authenState.message);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: const Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 6,
                      ),
                    ),
                    Positioned(
                      top: 42,
                      left: 24,
                      child: Text(
                        'Foolish',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.5,
                            color: Color(0xffff8401)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
