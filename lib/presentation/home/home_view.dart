import 'package:flutter/material.dart';
import 'package:restoku/helpers/models/account_model.dart';
import 'package:restoku/helpers/models/menu_model.dart';
import 'package:restoku/presentation/history/history_view.dart';
import 'package:restoku/presentation/profile/profile_view.dart';

import '../../helpers/datasource/menu_datasource.dart';
import '../../helpers/datasource/order_datasource.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  HomeView({Key? key, required this.activedAccount}) : super(key: key);
  AccountModel activedAccount;

  @override
  State<HomeView> createState() =>
      _HomeViewState(activedAccount: activedAccount);
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState({required this.activedAccount});
  MenuDatabase menuDatabase = MenuDatabase();
  OrderDatabase orderDatabase = OrderDatabase();
  AccountModel activedAccount;
  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController categoryController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> inputMenu() async {
    List<MenuModel> registeredMenu = await menuDatabase.selectAllMenu();
    bool isValid = false;
    for (var menu in registeredMenu) {
      if (nameController.text == menu.name) {
        isValid = true;
        break;
      }
    }
    if (!isValid) {
      await menuDatabase.insertMenu({
        'id': id,
        'name': nameController.text,
        'description': descriptionController.text,
        'category': categoryController.text,
        'price': priceController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text('Home'),
        ),
        body: FutureBuilder(
          future: menuDatabase.database(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  id = snapshot.data![index].id! + 1;
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text(snapshot.data![index].name!)),
                        SizedBox(
                          height: 50,
                        ),
                        Text(snapshot.data![index].description!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data![index].category!),
                            Text(snapshot.data![index].price!),
                          ],
                        ),
                        activedAccount.role == 'admin'
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        await menuDatabase.deleteMenu(
                                            snapshot.data![index].id!);
                                        setState(() {});
                                      },
                                      child: Text('Delete')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          nameController.text =
                                              snapshot.data![index].name!;
                                          descriptionController.text = snapshot
                                              .data![index].description!;
                                          priceController.text =
                                              snapshot.data![index].price!;
                                          categoryController.text =
                                              snapshot.data![index].category!;
                                        });
                                        _inputMenuModalSheet(context, 'update',
                                            snapshot.data![index].id!);
                                      },
                                      child: Text('Update')),
                                ],
                              )
                            : SizedBox(),
                        activedAccount.role == 'user'
                            ? Center(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await orderDatabase.database();
                                      await orderDatabase.insertOtableOrder({
                                        'menuId': snapshot.data![index].id!,
                                        'quantity': 1,
                                        'amount': snapshot.data![index].price!,
                                        'itemName': snapshot.data![index].name!,
                                        'status': 'process'
                                      });
                                    },
                                    child: Text('Order')),
                              )
                            : SizedBox()
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Belum ada menu yang dapat ditampilkan'),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (value) {
            if (value == 0) {}
            if (value == 1) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryView(activedAccount: activedAccount),
                  ));
            }
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
          currentIndex: 0,
        ),
        floatingActionButton: activedAccount.role == 'admin'
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    nameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                    categoryController.clear();
                  });
                  _inputMenuModalSheet(context, 'input', null);
                },
                child: Icon(Icons.add),
              )
            : null);
  }

  _inputMenuModalSheet(BuildContext context, String type, int? id) {
    priceController.text = 'Rp.';
    showModalBottomSheet(
      context: context,
      builder: (innerContext) {
        return Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Name'),
              TextField(
                controller: nameController,
              ),
              Text('Description'),
              TextField(
                maxLines: 3,
                controller: descriptionController,
              ),
              Text('category'),
              TextField(
                controller: categoryController,
              ),
              Text('price'),
              TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (type == 'input') {
                      await inputMenu();
                    } else {
                      await menuDatabase.updateAccount(MenuModel(
                          id: id,
                          name: nameController.text,
                          description: descriptionController.text,
                          price: priceController.text,
                          category: categoryController.text));
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text('Submit'))
            ],
          ),
        );
      },
    );
  }
}
