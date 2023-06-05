import 'dart:io';

import 'package:fashionstore/bloc/authentication/authentication_bloc.dart';
import 'package:fashionstore/bloc/uploadFile/upload_file_bloc.dart';
import 'package:fashionstore/data/enum/NavigationNameEnum.dart';
import 'package:fashionstore/data/static/GlobalVariable.dart';
import 'package:fashionstore/presentation/components/GradientButton.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:fashionstore/util/render/ValueRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/entity/User.dart';
import '../../util/service/LoadingService.dart';
import '../layout/Layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isPasswordHiddened = true;


  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.PROFILE.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      forceCanNotBack: true,
      hintSearchBarText: 'What product are you looking for?',
      textEditingController: _textEditingController,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        color: Colors.orange,
        key: _refreshIndicatorKey,
        child: MultiBlocListener(
          listeners: [
            BlocListener<UploadFileBloc, UploadFileState>(
              listener: (context, uploadFileState) {
                if(uploadFileState is UploadFileUploadingState) {
                  UiRender.showLoaderDialog(context);
                }

                if(uploadFileState is UploadFileUploadedState) {
                  Navigator.pop(context);

                  UiRender.showDialog(context, '', 'Uploaded image successfully!').then((value) {
                    BlocProvider.of<AuthenticationBloc>(context).currentUser?.avatar = ValueRender.getFileIdFromGoogleDriveViewUrl(uploadFileState.url);
                  });
                }

                if(uploadFileState is UploadFileErrorState) {
                  UiRender.showDialog(context, '', uploadFileState.message);
                }
              }
            ),
          ],
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, authenState) {
              User? currentUser = BlocProvider.of<AuthenticationBloc>(context).currentUser;

              if(authenState is AuthenticationLoggedInState) {
                currentUser = authenState.currentUser;
              }

              if(currentUser != null) {
                setState(() {
                  _fullNameController.text = currentUser?.name ?? '';
                  _emailController.text = currentUser?.email ?? '';
                  _passwordController.text = currentUser?.password ?? '';
                  _userNameController.text = currentUser?.userName ?? '';
                  _phoneNumberController.text = currentUser?.phoneNumber ?? '';
                  _addressController.text = currentUser?.address ?? '';
                  _cityController.text = currentUser?.city ?? '';
                  _countryController.text = currentUser?.country ?? '';
                });
              }
            },
            builder: (context, authenState) {
              User? currentUser = BlocProvider.of<AuthenticationBloc>(context).currentUser;

              if(authenState is AuthenticationLoggedInState) {
                currentUser = authenState.currentUser;
              }

              if(currentUser != null) {
                _fullNameController.text = currentUser.name ?? '';
                _emailController.text = currentUser.email ?? '';
                _passwordController.text = currentUser.password ?? '';
                _userNameController.text = currentUser.userName ?? '';
                _phoneNumberController.text = currentUser.phoneNumber ?? '';
                _addressController.text = currentUser.address ?? '';
                _cityController.text = currentUser.city ?? '';
                _countryController.text = currentUser.country ?? '';

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _avatar(),
                          const SizedBox(height: 35),
                          Text(
                            currentUser.name ?? 'UNKNOWN',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: 'Work Sans',
                                color: Color(0xff464646)
                            ),
                          ),
                          Text(
                            currentUser.email ?? 'UNKNOWN',
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                fontFamily: 'Work Sans',
                                color: Color(0xff868686),
                                height: 2
                            ),
                          ),
                          _textField('User name', _userNameController),
                          _textField('Password', _passwordController),
                          _textField('Full name', _fullNameController),
                          _textField('Email', _emailController),
                          _textField('Phone number', _phoneNumberController),
                          _textField('Address', _addressController),
                          _textField('City', _cityController),
                          _textField('Country', _countryController),
                          Center(
                            child: GradientElevatedButton(
                                borderRadiusIndex: 20,
                                textSize: 18,
                                borderColor: Colors.black,
                                text: 'Update Profile',
                                textWeight: FontWeight.w600,
                                buttonWidth: 300,
                                buttonHeight: 45,
                                beginColor: Colors.black,
                                endColor: const Color(0xff727272),
                                textColor: Colors.white,
                                onPress: () {

                                }
                            ),
                          )
                        ],
                      )
                  ),
                );
              }

              return Container();
            },
          ),
        )
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenState) {
            String? fileId = BlocProvider.of<AuthenticationBloc>(context).currentUser?.avatar;

            if(authenState is AuthenticationAvatarUpdatedState) {
              fileId = authenState.fileId;
            }

            return CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(ValueRender.getGoogleDriveImageUrl(fileId ?? '')),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              ImagePicker().pickImage(
                source: ImageSource.gallery,
              ).then((XFile? image) {
                if (image != null) {
                  File file = File(image.path);

                  BlocProvider.of<UploadFileBloc>(context).add(OnUploadFileEvent(file, isCustomer: true));
                }
              });
            },
            child: Container(
              height: 23,
              width: 23,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xffbababa),
              ),
              child: Image.asset('assets/icon/edit_icon.png', fit: BoxFit.fill,)
            ),
          ),
        )
      ],
    );
  }

  Widget _textField(String hintText, TextEditingController? textEditingController, {bool editable = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xff777676),
          width: 0.5
        )
      ),
      child: TextField(
        controller: textEditingController,
        enabled: editable,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
              fontFamily: 'Trebuchet MS',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff868686)
          ),
          labelStyle:  const TextStyle(
              fontFamily: 'Trebuchet MS',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff868686)
          ),
        ),
      ),
    );
  }
}