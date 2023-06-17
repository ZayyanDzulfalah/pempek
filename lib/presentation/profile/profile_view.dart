import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:restoku/helpers/datasource/account_datasource.dart';
import 'package:restoku/presentation/authentication/register_view.dart';

import '../../helpers/models/account_model.dart';
import '../history/history_view.dart';
import '../home/home_view.dart';

// ignore: must_be_immutable
class ProfileView extends StatefulWidget {
  ProfileView({Key? key, required this.activedAccount}) : super(key: key);
  AccountModel activedAccount;
  @override
  State<ProfileView> createState() =>
      _ProfileViewState(activedAccount: activedAccount);
}

class _ProfileViewState extends State<ProfileView> {
  _ProfileViewState({required this.activedAccount});
  AccountDatabase accountDatabase = AccountDatabase();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AccountModel activedAccount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: accountDatabase.database(),
        builder: (context, snapshot) {
          emailController.text = activedAccount.email!;
          nameController.text = activedAccount.name!;
          passwordController.text = activedAccount.password!;
          return Column(
            children: [
              Text('Name'),
              TextField(
                controller: nameController,
              ),
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
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await accountDatabase.deleteAccount(activedAccount.id);
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterView(),
                            ));
                      },
                      child: Text('Delete Account')),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (EmailValidator.validate(emailController.text)) {
                          activedAccount = AccountModel(
                              id: activedAccount.id,
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              role: 'user');
                          await accountDatabase.updateAccount(activedAccount);
                        }
                        setState(() {});
                      },
                      child: Text('Edit Account')),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterView(),
                        ));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView(),));
                  },
                  child: Text('Logout')),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeView(activedAccount: activedAccount),
                ));
          }
          if (value == 1) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HistoryView(activedAccount: activedAccount),
                ));
          }
          if (value == 2) {}
        },
        currentIndex: 2,
      ),
    );
  }
}
