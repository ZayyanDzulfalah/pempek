import 'package:flutter/material.dart';
import 'package:restoku/helpers/datasource/order_datasource.dart';
import 'package:restoku/helpers/models/order_model.dart';

import '../../helpers/models/account_model.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key? key, required this.activedAccount}) : super(key: key);
  AccountModel activedAccount;
  @override
  State<HistoryView> createState() =>
      _HistoryViewState(activedAccount: activedAccount);
}

class _HistoryViewState extends State<HistoryView> {
  _HistoryViewState({required this.activedAccount});
  OrderDatabase orderDatabase = OrderDatabase();
  AccountModel activedAccount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder(
        future: orderDatabase.database(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                        tileColor: snapshot.data![index].status == 'done'
                            ? Colors.lightGreen
                            : Colors.yellow,
                        leading: Text(snapshot.data![index].id.toString()),
                        title: Text(snapshot.data![index].itemName!),
                        trailing: Text(snapshot.data![index].amount!),
                        subtitle: Text('${snapshot.data![index].quantity}X')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        activedAccount.role == 'admin'
                            ? ElevatedButton(
                                onPressed: () async {
                                  await orderDatabase.updateOrder(OrderModel(
                                    id: snapshot.data![index].id,
                                    menuId: snapshot.data![index].menuId,
                                    amount: snapshot.data![index].amount,
                                    itemName: snapshot.data![index].itemName,
                                    quantity: snapshot.data![index].quantity,
                                    status: 'done',
                                  ));
                                  setState(() {});
                                },
                                child: Text('Update'))
                            : SizedBox(),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await orderDatabase
                                  .deleteOrder(snapshot.data![index].id);
                              setState(() {});
                            },
                            child: Text('Delete')),
                      ],
                    )
                  ],
                );
              },
            );
          }
          return SizedBox();
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
          if (value == 1) {}
          if (value == 2) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileView(activedAccount: activedAccount),
                ));
          }
        },
        currentIndex: 1,
      ),
    );
  }
}
