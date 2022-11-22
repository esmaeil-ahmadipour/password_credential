import 'package:flutter/material.dart';
import 'package:password_credential/entity/mediation.dart';
import 'package:provider/provider.dart';

import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider<Model>(create: (_) => Model())],
        child: Consumer<Model>(builder: (context, model, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Builder(builder: (context) {
                void snackbar(String message) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                }

                return SafeArea(
                    child: Column(children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(children: [
                            Row(
                              children: [
                                const SizedBox(width: 80, child: Text("ID")),
                                Expanded(child: TextField(controller: model.idEdit))
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 80, child: Text("Password")),
                                Expanded(
                                    child:
                                    TextField(controller: model.passwordEdit))
                              ],
                            ),
                          ])),
                      Expanded(
                          child: ListView(children: <Widget>[
                            ListTile(
                              title: const Text("Input Dummy ID/Password"),
                              onTap: () async {
                                model.idEdit.text = "my_id";
                                model.passwordEdit.text = "my_password";
                              },
                            ),
                            ListTile(
                              title: const Text("Clear Inputs"),
                              onTap: () async {
                                model.idEdit.text = "";
                                model.passwordEdit.text = "";
                              },
                            ),
                            ListTile(
                              title: const Text("Store(Silent)"),
                              subtitle: const Text(
                                  "Android: Success only when user already permitted to store the ID. Web: Silent Parameter is ignored, so operation will complete with silent for updating password or with asking user to save for new entry. Android/Web: If user denied once or disabling password saving, this operation is always failed with no asking dialogs."),
                              onTap: () async {
                                try {
                                  var result = await model.store(Mediation.Silent);
                                  snackbar(result.toString());
                                } catch (e) {
                                  snackbar(e.toString());
                                }
                              },
                            ),
                            ListTile(
                              title: const Text("Store(Optional)"),
                              subtitle: const Text(
                                  "Android/Web: Operation will complete with silent for updating password or with asking user to save for new entry. If user denied once or disabling password saving, this operation is always failed with no asking dialogs."),
                              onTap: () async {
                                try {
                                  var result = await model.store(Mediation.Optional);
                                  snackbar(result.toString());
                                } catch (e) {
                                  snackbar(e.toString());
                                }
                              },
                            ),
                            ListTile(
                              title: const Text("Store(Required)"),
                              subtitle: const Text(
                                  "Android: Deleting existing entry then Always asking user to permit. Web: Required Parameter is ignored, so operation will complete with silent for updating password or with asking user to save for new entry. Android/Web: If user denied once or disabling password saving, this operation is always failed with no asking dialogs."),
                              onTap: () async {
                                try {
                                  var result = await model.store(Mediation.Required);
                                  snackbar(result.toString());
                                } catch (e) {
                                  snackbar(e.toString());
                                }
                              },
                            ),
                            ListTile(
                              title: const Text("Get(Silent)"),
                              subtitle: const Text(
                                  "Android/Web: Success only when user has already permitted to store or to read the entry. If Auto Login is disabled, this operation is always failed."),
                              onTap: () async {
                                var result = await model.get(Mediation.Silent);
                                snackbar(result.toString());
                              },
                            ),
                            ListTile(
                              title: const Text("Get(Optional)"),
                              subtitle: const Text(
                                  "Android/Web: Success when user has already permitted to store or to read the entry, otherwise Account Selection is displayed. If Auto Login is disabled, Account Selection is always displayed."),
                              onTap: () async {
                                var result = await model.get(Mediation.Optional);
                                snackbar(result.toString());
                              },
                            ),
                            ListTile(
                              title: const Text("Get(Required)"),
                              subtitle: const Text(
                                  "Android/Web: Always Account Selection is displayed."),
                              onTap: () async {
                                var result = await model.get(Mediation.Required);
                                snackbar(result.toString());
                              },
                            ),
                            ListTile(
                              title: const Text("Delete"),
                              subtitle: const Text(
                                  "Android: Always Success with no interaction. Web: Success when user has already permitted to store or to read that entry."),
                              onTap: () async {
                                try {
                                  await model.delete();
                                  snackbar("Done");
                                } catch (e) {
                                  snackbar(e.toString());
                                }
                              },
                            ),
                            ListTile(
                              title: const Text("hasCredentialFeature"),
                              subtitle: Text(model.hasCredentialFeature.toString()),
                            ),
                            ListTile(
                              title: const Text("preventSilentAccess"),
                              subtitle: const Text(
                                  "Android/Web: Force to Forget user's past selection."),
                              onTap: () async {
                                await model.preventSilentAccess();
                                snackbar("Done");
                              },
                            ),
                            ListTile(
                              title: const Text("openPlatformCredentialSettings"),
                              subtitle: const Text(
                                  "Android: Open Google Account Settings. Web: Not implemented for Chrome security reason."),
                              onTap: () async {
                                try {
                                  await model.openPlatformCredentialSettings();
                                  snackbar("Done");
                                } catch (e) {
                                  snackbar(e.toString());
                                }
                              },
                            ),
                          ]))
                    ]));
              })));
        }));
  }
}
