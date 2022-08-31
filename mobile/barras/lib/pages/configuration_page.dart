import 'package:barras/pages/form_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final selectedStore = ValueNotifier('');
  final stores = ['Loja 1', 'Loja 2', 'Loja 3', 'Loja 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: selectedStore,
              builder: (BuildContext context, String value, _) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Loja'),
                    decoration: const InputDecoration(
                      label: Text('Loja'),
                    ),
                    value: (value.isEmpty) ? null : value,
                    onChanged: (escolha) =>
                        selectedStore.value = escolha.toString(),
                    items: stores
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool confirmacao = await save();
                  if (confirmacao) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FormPage()));
                  }
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }

  Future<bool> save() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getString('shop') == null) {
      await sharedPreference.setString('shop', selectedStore.value.toString());
      return true;
    }
    return true;
  }
}
