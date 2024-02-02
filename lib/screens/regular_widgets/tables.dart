import 'package:flutter/material.dart';
import 'package:sample_latest/extensions/widget_extension.dart';

class StudentModel {
  final String name;
  final int id;
  final int age;
  final String location;
  final String schoolName;
  bool isSelected = false;
  StudentModel(this.name, this.id, this.age, this.location, this.schoolName);
}

class Tables extends StatefulWidget {
  Tables({Key? key}) : super(key: key);

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {

  late final List<StudentModel> paginatedDataTableRows;

  late final List<StudentModel> dataTableRows;

  int rowsPerPage = 5;

  @override
  void initState() {
    paginatedDataTableRows = List.generate(40, (index) =>
      StudentModel('John', index+1, 14, "New york", "Cambridge High school"));

    dataTableRows = List.generate(10, (index) =>
        StudentModel('Joseph', index+1, 18, "New york", "Cambridge High school"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Data Table', style: Theme.of(context).textTheme.titleMedium),
          DataTable(
            columns: buildColumns,
            rows: buildRows,
          ),
          _buildPaginatedTable()
        ],
      ).screenPadding(),
    );
  }

  Widget _buildPaginatedTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text('Paginated Table',
              style: Theme.of(context).textTheme.titleMedium),
          PaginatedDataTable(
            columns: buildColumns,
            header: const Text('Sample Header'),
            showFirstLastButtons: true,
            availableRowsPerPage: const [5, 15,25, 35, 40, 50],
            rowsPerPage: rowsPerPage,
            onRowsPerPageChanged: (val){
              setState(() {
                if(val != null) rowsPerPage = val;
              });
            },
            showCheckboxColumn: true,
            // onSelectAll: (bool){
            //
            // },

            // initialFirstRowIndex: ,
            onPageChanged: (val){
             print('$val');
            },
            source: TableData(paginatedDataTableRows, onPaginatedRowSelection),
          ),
        ],
      ),
    );
  }

  List<DataColumn> get buildColumns {
    List<({String label, String toolTipDes, bool isNumeric})> columns = [
      (label: 'Id No', toolTipDes: 'Student ID number', isNumeric: true),
      (label: 'Name', toolTipDes: 'Name of the student', isNumeric: false),
      (label: 'Age', toolTipDes: 'Age of the student', isNumeric: true),
      (
        label: 'School Name',
        toolTipDes: 'Student School name',
        isNumeric: false
      ),
      (
          label: 'Location',
      toolTipDes: 'Student location',
          isNumeric: false
      ),
      (label: 'Edit', toolTipDes: 'Edit the student details', isNumeric: false)
    ];

    return columns
        .map(
          (e) => DataColumn(
              label: Text(e.label),
              numeric: e.isNumeric,
              tooltip: e.toolTipDes,
              onSort: (val, status) {}),
        )
        .toList();
  }

  List<DataRow> get buildRows {
    return List.generate(dataTableRows.length, (index) {
      var student = dataTableRows.elementAt(index);
      return DataRow(
          selected: student.isSelected,
          onSelectChanged: (bool? status) {
            setState(() {
              student.isSelected = status ?? false;
            });
          },
          cells: [
            DataCell(Text(student.id.toString())),
            DataCell(Text(student.name)),
            DataCell(Text('${student.age}')),
            DataCell(Text(student.schoolName)),
            DataCell(Text(student.location)),
            const DataCell(Text('Edit '), showEditIcon: true)
          ]);
    }).toList();
  }

  void onPaginatedRowSelection((int index, bool? status) rowDetails) {
    setState(() {
      paginatedDataTableRows.elementAt(rowDetails.$1).isSelected = rowDetails.$2 ?? false;
    });
  }
}

class TableData extends DataTableSource {

  final List<StudentModel> paginatedDataTableRows;

  final ValueChanged<(int index, bool? status)> onRowSelection;

  TableData(this.paginatedDataTableRows, this.onRowSelection);

  @override
  int get rowCount => paginatedDataTableRows.length;

  @override
  DataRow? getRow(int index) {
    if(index < paginatedDataTableRows.length){
      var student = paginatedDataTableRows.elementAt(index);
          return DataRow(
            onSelectChanged: (status) => onRowSelection((index, status)),
            selected: student.isSelected,
            cells: <DataCell>[
              DataCell(Text(student.id.toString())),
              DataCell(Text(student.name)),
              DataCell(Text('${student.age}')),
              DataCell(Text(student.schoolName)),
              DataCell(Text(student.location)),
              const DataCell(Text('Edit '), showEditIcon: true)
            ],
          );
    }
    return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
