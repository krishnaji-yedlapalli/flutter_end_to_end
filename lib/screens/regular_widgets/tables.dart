import 'package:flutter/material.dart';
import 'package:sample_latest/extensions/widget_extension.dart';

class Tables extends StatefulWidget {
  Tables({Key? key}) : super(key: key);

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  final List<
      (
        String,
        int,
        String,
        String,
      )> dataTableRows = [('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School'), ('Ramesh', 29, '420', 'ZPH High School')];

  late List<bool> rowsStatuss;

  @override
  void initState() {
    rowsStatuss = List.generate(dataTableRows.length, (index) => false);
    super.initState();
  }

  void isSel(int index, bool? status) {
    // setState(() {
    rowsStatuss[index] = status ?? false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Data Table', style: Theme.of(context).textTheme.titleMedium),
        DataTable(
          columns: buildColumns,
          rows: buildRows,
        ),
        // Text('Data Table', style: Theme.of(context).textTheme.titleMedium),
        // Pag(columns: buildColumns, rows: buildRows),
      ],
    ).screenPadding();
  }

  List<DataColumn> get buildColumns {
    List<({String label, String toolTipDes, bool isNumeric})> columns = [(label: 'Name', toolTipDes: 'Name of the student', isNumeric: false), (label: 'Age', toolTipDes: 'Age of the student', isNumeric: true), (label: 'Id No', toolTipDes: 'Student ID number', isNumeric: true), (label: 'School Name', toolTipDes: 'Student School name', isNumeric: false), (label: 'Edit', toolTipDes: 'Edit the student details', isNumeric: false)];

    return columns
        .map(
          (e) => DataColumn(label: Text(e.label), numeric: e.isNumeric, tooltip: e.toolTipDes, onSort: (val, status) {}),
        )
        .toList();
  }

  List<DataRow> get buildRows {
    return List.generate(dataTableRows.length, (index) {
      var e = dataTableRows.elementAt(index);
      var status = rowsStatuss.elementAt(index);
      return DataRow(
          selected: status,
          onSelectChanged: (bool? val) {
            // setState(() {
            //   if (val != null) status = val;
            // });
          },
          cells: [DataCell(Text(e.$1)), DataCell(Text('${e.$2}')), DataCell(Text(e.$3)), DataCell(Text(e.$4)), DataCell(Text('Edit '), showEditIcon: true)]);
    }).toList();
  }
}
