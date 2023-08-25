import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/render/ui_render.dart';
import 'home_page.dart';

class InitialLoadingPage extends StatefulWidget {
  const InitialLoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitialLoadingState();
}

class _InitialLoadingState extends State<InitialLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, authenState) {
          if (authenState is AuthenticationLoggedInState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          }

          if (authenState is AuthenticationErrorState) {
            Navigator.pop(context);
            UiRender.showDialog(context, '', authenState.message);
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
      )),
    );
  }
}
