import 'dart:math';

import 'package:crud_application/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _alldata = [];

  bool _isLoading = true;
  void _refreshData() async {
    final data = await DBHelper.getAllData();
    setState(() {
      _alldata = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  //add data
  Future<void> _addData() async {
    await DBHelper.createData(_titleController.text, _descController.text);
    _refreshData();
    _titleController.clear();
    _descController.clear();
  }

  //update data
  Future<void> _updateData(int id) async {
    await DBHelper.updateData(id, _titleController.text, _descController.text);
    _refreshData();
    _titleController.clear();
    _descController.clear();
  }

  //delete data
  void _deleteData(int id) async {
    await DBHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Data deleted successfully'),
      ),
    );
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CRUD Application'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 61, 118),
      ),
      body:_isLoading?Center(
        child: CircularProgressIndicator(),
      )
      :ListView.builder(
        itemBuilder:(context,index)=>Card(
          
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              _alldata[index]['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        )
        )
    );
  }
}
