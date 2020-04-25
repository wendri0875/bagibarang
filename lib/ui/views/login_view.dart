import 'package:bagi_barang/ui/shared/ui_helpers.dart';
import 'package:bagi_barang/ui/widgets/busy_button.dart';
import 'package:bagi_barang/ui/widgets/input_field.dart';
import 'package:bagi_barang/ui/widgets/text_link.dart';
import 'package:bagi_barang/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
        viewModel: LoginViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BusyButton(
                          title: 'Login',
                          busy: model.busy,
                          onPressed: () {
                            model.login();
                            // TODO: Perform firebase login here
                          },
                        ),
                      ],
                    ),
                  ]),
              // backgroundColor: Colors.white,
              // body: Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50),
              // child: Column(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     SizedBox(
              //       height: 150,
              //       child: Image.asset('assets/images/title.png'),
              //     ),
              //     InputField(
              //       placeholder: 'Email',
              //       controller: emailController,
              //     ),
              //     verticalSpaceSmall,
              //     InputField(
              //       placeholder: 'Password',
              //       password: true,
              //       controller: passwordController,
              //     ),
              //     verticalSpaceMedium,
              //     Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         BusyButton(
              //           title: 'Login',
              //           onPressed: () {
              //             // TODO: Perform firebase login here
              //           },
              //         )
              //       ],
              //     ),
              //     verticalSpaceMedium,
              //     TextLink(
              //       'Create an Account if you\'re new.',
              //       onPressed: () {
              //         // TODO: Handle navigation
              //       },
              //     )
              //   ],
              // ),
              //   )),
            ));
  }
}
