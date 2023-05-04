import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/data/enum/LocalStorageKeyEnum.dart';
import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:fashionstore/presentation/screens/HomePage.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _fullNameTextEditingController = TextEditingController();
  TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  TextEditingController _phoneNumberTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();

  bool isPasswordHiddened = true;
  bool isConfirmPasswordHiddened = true;
  bool isLogin = true;
  bool isRememberPassword = false;

  Future<void> _initLocalStorageValues() async {
    _userNameTextEditingController.text = await ValueRender.getLocalStorageVariable(LocalStorageKeyEnum.SAVED_USER_NAME.name) as String;
    _passwordTextEditingController.text = await ValueRender.getLocalStorageVariable(LocalStorageKeyEnum.SAVED_PASSWORD.name) as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if(_userNameTextEditingController.text != '' &&
            _passwordTextEditingController.text != '' ) {
          isRememberPassword = true;
        }
      });
    });
  }

  @override
  void initState() {
    _initLocalStorageValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 35, 20, 25),
        child: Container(
          height: MediaQuery.of(context).size.height - 60,
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: isLogin
            ? BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, authenState) {
                    if(authenState is AuthenticationLoadingState) {
                      UiRender.showLoaderDialog(context);
                    }

                    if(authenState is AuthenticationLoggedInState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    }

                    if(authenState is AuthenticationErrorState) {
                      Navigator.pop(context);
                      UiRender.showDialog(context, '', authenState.message);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/login_image.png',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'Welcome to',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w400,
                            fontSize: 21,
                            height: 4,
                            color: Colors.black
                        ),
                      ),
                      const Text(
                        'Foolish',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.5,
                            color: Colors.orange
                        ),
                      ),
                      _textField('User Name', false, _userNameTextEditingController),
                      _textField('Password', true, _passwordTextEditingController, isShowed: isPasswordHiddened),
                      const SizedBox(height: 10,),
                      _radioTextButton('Remember password'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientElevatedButton(
                              borderRadiusIndex: 25,
                              borderColor: isLogin ? Colors.transparent : Colors.black,
                              text: 'Login',
                              textWeight: FontWeight.w400,
                              buttonWidth: 125,
                              buttonHeight: 45,
                              topColor: isLogin ? Colors.black : Colors.white,
                              bottomColor: isLogin ? const Color(0xff727272) : Colors.white,
                              textColor: isLogin ? Colors.white : Colors.black,
                              onPress: () {
                                setState(() {
                                  if(isLogin == false) {
                                    isLogin = true;
                                  }
                                  else {
                                    if(_userNameTextEditingController.text != '' &&
                                       _passwordTextEditingController.text != '') {
                                      BlocProvider.of<AuthenticationBloc>(context).add(
                                          OnLoginAuthenticationEvent(
                                              _userNameTextEditingController.text,
                                              _passwordTextEditingController.text
                                          )
                                      );
                                    }
                                    else {
                                      UiRender.showDialog(context, '', 'User Name or Password is empty, please fill in all the boxes !!');
                                    }
                                  }
                                });
                              }
                          ),
                          GradientElevatedButton(
                              borderRadiusIndex: 25,
                              borderColor: !isLogin ? Colors.transparent : Colors.black,
                              text: 'Register',
                              textWeight: FontWeight.w400,
                              buttonWidth: 125,
                              buttonHeight: 45,
                              topColor: !isLogin ? Colors.black : Colors.white,
                              bottomColor: !isLogin ? const Color(0xff727272) : Colors.white,
                              textColor: !isLogin ? Colors.white : Colors.black,
                              onPress: () {
                                setState(() {
                                  if(isLogin == true) {
                                    _userNameTextEditingController.clear();
                                    _passwordTextEditingController.clear();
                                    isPasswordHiddened = true;
                                    isLogin = false;
                                  }
                                });
                              }
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {

                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontFamily: 'Trebuchet MS',
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          )
                      )
                    ],
                  )
              )
            : BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, authenState) {
                    if(authenState is AuthenticationLoadingState) {
                      UiRender.showLoaderDialog(context);
                    }

                    if(authenState is AuthenticationRegisteredState) {
                      Navigator.pop(context);
                      UiRender.showDialog(context, '', authenState.message).then((value) {
                        UiRender.showDialog(context, '', 'Please sign in to enjoy our application!');
                        setState(() {
                          isLogin = true;
                        });
                      });
                    }

                    if(authenState is AuthenticationErrorState) {
                      Navigator.pop(context);
                      UiRender.showDialog(context, '', authenState.message);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome new customer of',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w400,
                            fontSize: 21,
                            height: 4,
                            color: Colors.black
                        ),
                      ),
                      const Text(
                        'Foolish',
                        style: TextStyle(
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.5,
                            color: Colors.orange
                        ),
                      ),
                      _textField('Full Name', false, _fullNameTextEditingController),
                      _textField('Email', false, _emailTextEditingController),
                      _textField('Phone Number', false, _phoneNumberTextEditingController),
                      _textField('User Name', false, _userNameTextEditingController),
                      _textField('Password', true, _passwordTextEditingController, isShowed: isPasswordHiddened),
                      _textField('Confirm Password', true, _confirmPasswordTextEditingController, isShowed: isConfirmPasswordHiddened),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientElevatedButton(
                              borderRadiusIndex: 25,
                              borderColor: isLogin ? Colors.transparent : Colors.black,
                              text: 'Login',
                              textWeight: FontWeight.w400,
                              buttonWidth: 125,
                              buttonHeight: 45,
                              topColor: isLogin ? Colors.black : Colors.white,
                              bottomColor: isLogin ? const Color(0xff727272) : Colors.white,
                              textColor: isLogin ? Colors.white : Colors.black,
                              onPress: () {
                                setState(() {
                                  if(isLogin == false) {
                                    _userNameTextEditingController.clear();
                                    _passwordTextEditingController.clear();
                                    isPasswordHiddened = true;
                                    isLogin = true;
                                  }
                                });
                              }
                          ),
                          GradientElevatedButton(
                              borderRadiusIndex: 25,
                              borderColor: !isLogin ? Colors.transparent : Colors.black,
                              text: 'Register',
                              textWeight: FontWeight.w400,
                              buttonWidth: 125,
                              buttonHeight: 45,
                              topColor: !isLogin ? Colors.black : Colors.white,
                              bottomColor: !isLogin ? const Color(0xff727272) : Colors.white,
                              textColor: !isLogin ? Colors.white : Colors.black,
                              onPress: () {
                                setState(() {
                                  if(isLogin == true) {
                                    isLogin = false;
                                  }
                                  else {
                                    if((_userNameTextEditingController.text != '' &&
                                        _passwordTextEditingController.text != '' &&
                                        _fullNameTextEditingController.text != '' &&
                                        _emailTextEditingController.text != '' &&
                                        _phoneNumberTextEditingController.text != '' &&
                                        _confirmPasswordTextEditingController.text != '') &&
                                       (_confirmPasswordTextEditingController.text == _passwordTextEditingController.text)) {
                                      BlocProvider.of<AuthenticationBloc>(context).add(
                                        OnRegisterAuthenticationEvent(
                                            _userNameTextEditingController.text,
                                            _passwordTextEditingController.text,
                                            _fullNameTextEditingController.text,
                                            _emailTextEditingController.text,
                                            _phoneNumberTextEditingController.text
                                        )
                                      );
                                    }
                                    else if(_confirmPasswordTextEditingController.text != _passwordTextEditingController.text) {
                                      UiRender.showDialog(context, '', 'Confirm Password is incorrect, please confirm your password again!');
                                    }
                                    else {
                                      UiRender.showDialog(context, '', 'Must fill in all boxes!');
                                    }
                                  }
                                });
                              }
                          )
                        ],
                      ),
                    ],
                  ),
              )
        ),
      ),
    );
  }



  Widget _radioTextButton(String content) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.orange,
            value: isRememberPassword,
            onChanged: (value) {
              print('@@@');
              print(value);

              setState(() {
                if(value == true &&
                   (_userNameTextEditingController.text != '' &&
                    _passwordTextEditingController.text != '')) {
                  ValueRender.setLocalStorageVariable(
                      LocalStorageKeyEnum.SAVED_USER_NAME.name,
                      _userNameTextEditingController.text
                  );

                  ValueRender.setLocalStorageVariable(
                      LocalStorageKeyEnum.SAVED_PASSWORD.name,
                      _passwordTextEditingController.text
                  );

                  isRememberPassword = true;
                }
                else if(_userNameTextEditingController.text == '' ||
                        _passwordTextEditingController.text == '') {
                  UiRender.showDialog(context, '', 'Please input User Name and Password!');
                  isRememberPassword = false;
                }
                else {
                  isRememberPassword = false;

                  ValueRender.setLocalStorageVariable(LocalStorageKeyEnum.SAVED_USER_NAME.name, '');

                  ValueRender.setLocalStorageVariable(LocalStorageKeyEnum.SAVED_PASSWORD.name, '');
                }
              });
            }
          ),
        ),
        Text(
          ' $content',
          style: const TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color(0xffc4c4c4)
          ),
        )
      ]
    );
  }

  Widget _textField(String hintText, bool isPassword, TextEditingController textEditingController, {bool isShowed = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: textEditingController,
        obscureText: isShowed,
        decoration: InputDecoration(
            suffixIcon: isPassword == true
            ? IconButton(
                onPressed: () {
                  if(isShowed == true) {
                    setState(() {
                      if(hintText == 'Password') {
                        isPasswordHiddened = false;
                      }
                      else if(hintText == 'Confirm Password') {
                        isConfirmPasswordHiddened = false;
                      }
                    });
                  }
                  else {
                    setState(() {
                      if(hintText == 'Password') {
                        isPasswordHiddened = true;
                      }
                      else if(hintText == 'Confirm Password') {
                        isConfirmPasswordHiddened = true;
                      }
                    });
                  }
                },
                icon: Icon(
                  isShowed ? Icons.visibility : Icons.visibility_off_outlined,
                  color: const Color(0xffc4c4c4),
                ),
              )
            : const SizedBox(height: 0, width: 0,),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: 'Trebuchet MS',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xffc4c4c4)
            ),
        ),
      ),
    );
  }
}