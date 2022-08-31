import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:site_validade_medeiros/provider/home_page_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cabecario = <String>[
    'registration Date',
    "Description",
    'EAN',
    "Quantity",
    "Validity",
    "Zone",
    "Corridor",
    "Shop"
  ];

  Duration? executionTime;
  void exportToExcel(List<dynamic> objs) {
    final stopWatch = Stopwatch()..start();
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    if (objs.isEmpty) {
      print("lista vazia");
      return;
    }
    //Cabecario do planilha
    var isheader = false;
    do {
      for (var i = 0; i < cabecario.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i + 0, rowIndex: 0))
            .value = cabecario[i];
      }
      isheader = true;
    } while (isheader == false);

    //corpo
    int linha = 1;
    for (var element in objs) {
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: linha))
              .value =
          DateFormat("dd/MM/yyyy HH:mm")
              .format(DateTime.parse(element.registrationDate.toString()));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: linha))
          .value = element.description;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: linha))
          .value = element.ean;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: linha))
          .value = element.quantity;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: linha))
              .value =
          DateFormat("dd/MM/yyyy")
              .format(DateTime.parse(element.validity.toString()));
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: linha))
          .value = element.zone;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: linha))
          .value = element.corridor;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: linha))
          .value = element.shop;
      linha += 1;
    }

    excel.save(fileName: 'BrigadaDeValidade.xlsx');
    setState(() => executionTime = stopWatch.elapsed);
  }

  @override
  Widget build(BuildContext context) {
    var _list = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brigada de validade"),
      ),
      body: ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(),
        child: Consumer<HomePageProvider>(builder: (context, provider, child) {
          if (provider.register.isEmpty) {
            provider.getData(context);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _list = provider.register;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                //sortColumnIndex: 2,
                //sortAscending: true,
                columnSpacing: 10,
                columns: [
                  DataColumn(label: Text(cabecario[0])),
                  DataColumn(label: Text(cabecario[1])),
                  DataColumn(label: Text(cabecario[2])),
                  DataColumn(label: Text(cabecario[3]), numeric: true),
                  DataColumn(label: Text(cabecario[4])),
                  DataColumn(label: Text(cabecario[5])),
                  DataColumn(label: Text(cabecario[6])),
                  DataColumn(label: Text(cabecario[7])),
                ],
                rows: provider.register
                    .map((data) => DataRow(cells: [
                          DataCell(Text(DateFormat("dd/MM/yyyy HH:mm").format(
                              DateTime.parse(
                                  data.registrationDate.toString())))),
                          DataCell(Text(data.description.toString())),
                          DataCell(Text(data.ean.toString())),
                          DataCell(Text(data.quantity.toString())),
                          DataCell(Text(DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(data.validity.toString())))),
                          DataCell(Text(data.zone.toString())),
                          DataCell(Text(data.corridor.toString())),
                          DataCell(Text(data.shop.toString())),
                        ]))
                    .toList(),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => exportToExcel(_list),
        tooltip: 'Gerá Excel',
        child: const Icon(Icons.sim_card_download),
      ),
    );
  }
}
