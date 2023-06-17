import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restoku/helpers/models/account_model.dart';
import 'package:restoku/presentation/home/home_view.dart';

import '../../helpers/datasource/account_datasource.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AccountDatabase accountDatabase = AccountDatabase();
  AccountModel? activedAccount;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isValid = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> loginValidation() async {
    isValid = false;
    List<AccountModel> registeredAccount = await accountDatabase.database();
    for (var account in registeredAccount) {
      if (account.email == emailController.text &&
          account.password == passwordController.text) {
        activedAccount = account;
        isValid = true;
        break;
      }
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          Text('Email'),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: emailController,
              validator: (value) => EmailValidator.validate(value!)
                  ? null
                  : "Please enter a valid email",
            ),
          ),
          Text('Password'),
          TextField(
            controller: passwordController,
          ),
          ElevatedButton(
              onPressed: () async {
                await loginValidation();
                if (isValid) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(
                          activedAccount: activedAccount!,
                        ),
                      ));
                }
              },
              child: Text('Login')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('New user? '),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
