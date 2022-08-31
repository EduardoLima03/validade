import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  var eanControl = TextEditingController();
  var descControl = TextEditingController();
  final _dateContrl = TextEditingController();
  final _qualyControl = TextEditingController();

  /// barcode*/
  String _scanBarcode = 'Unknown';
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    await mostraDesc();
  }

  /*
    atributos para dropdown
   */
  late final selectedStore = ValueNotifier('');
  final stores = ['Loja 1', 'Loja 2', 'Loja 3', 'Loja 4'];
  final selectedZone = ValueNotifier('');
  final zones = [
    'Amarela',
    'Azul',
    'Branca',
    'Cinza',
    'Laranja',
    'Roxa',
    'Verde',
    'Vermelha'
  ];
  final selectedCorridor = ValueNotifier('');
  final corridor = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14'
  ];

  Future<String> getDesc() async {
    var url = Uri.parse(
        'https://cosmos.bluesoft.com.br/produtos/${eanControl.text.toString()}');
    var response = await http.get(url);
    // cria a lista com a respostas separada por "<"
    var list = response.body.split('<');
    //retorn com a descricao
    var desc;
    for (var t in list) {
      if (t.contains('product_description')) {
        var separacao = t.split('>');
        desc = separacao[1];
        break;
      }
    }
    return desc.toString();
  }

  mostraDesc() async {
    if (_scanBarcode.isNotEmpty) {
      eanControl.text = _scanBarcode;
      //selectedStore.value = 'Loja 4';
      carregarLoja();
      var text = await getDesc();
      setState(() {
        descControl.text = text.toString();
      });
    }
  }

  Future<void> enviarDados() async {
    var url =
        Uri.parse('https://apirest-validade-medeiros.herokuapp.com/register');
    var response = await http.post(url,
        body: jsonEncode({
          "ean": eanControl.text,
          "description": descControl.text,
          "validity": DateFormat("dd/MM/yyyy hh:mm")
              .format(DateTime.parse(_dateContrl.text.toString())),
          "quantity": _qualyControl.text.toString(),
          "shop": selectedStore.value,
          "zone": selectedZone.value,
          "corridor": selectedCorridor.value
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 201) {
      var snackBar = const SnackBar(
        content: Text(
          "Criação com Sucesso",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      clearForm();
    } else {
      var snackBar = SnackBar(
        content: Text(
          'Não foi possivel Salvar. \nError: ${response.statusCode}',
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.redAccent,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /*
  * informar qua esta enviado os dados
  * */
  bool isSave = false;

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 7,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "EAN",
                        ),
                        controller: eanControl,
                        validator: (value) {
                          if (value!.isEmpty) return 'Campo obrigatorio';
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () => scanBarcodeNormal(),
                        )),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Descrição"),
                  controller: descControl,
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _qualyControl,
                  decoration: const InputDecoration(
                      hintText: "Quantidade", labelText: "Quantidade"),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateContrl,
                  decoration: const InputDecoration(labelText: "Validade"),
                  onTap: () async {
                    var date1 = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030));
                    _dateContrl.text = date1.toString();
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    return null;
                  },
                ),
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
                ValueListenableBuilder(
                  valueListenable: selectedZone,
                  builder: (BuildContext context, String value, _) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Zona'),
                        decoration: const InputDecoration(
                          label: Text('Zona'),
                        ),
                        value: (value.isEmpty) ? null : value,
                        onChanged: (escolha) =>
                            selectedZone.value = escolha.toString(),
                        items: zones
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: selectedCorridor,
                  builder: (BuildContext context, String value, _) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Corredor'),
                        decoration: const InputDecoration(
                          label: Text('Corredor'),
                        ),
                        value: (value.isEmpty) ? null : value,
                        onChanged: (escolha) =>
                            selectedCorridor.value = escolha.toString(),
                        items: corridor
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
                  height: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isSave = true);
                        await enviarDados();
                        setState(() {
                          isSave = false;
                        });
                      }
                    },
                    child: Visibility(
                      visible: isSave,
                      replacement: const Text("Enviar"),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearForm() {
    setState(() {
      eanControl.text = "";
      descControl.text = "";
      _dateContrl.text = "";
      selectedZone.value = '';
      selectedCorridor.value = '';
      _qualyControl.text = '';
    });
  }

  Future<void> carregarLoja() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? shop = sharedPreferences.getString('shop');
    if (shop != null) {
      selectedStore.value = shop;
    }
  }
}
