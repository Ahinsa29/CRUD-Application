import 'package:crud_application/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>>_alldata = [];

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
    _refreshData(); // Load data when the widget initializes
  }

  // Adds new data to the database.
  Future<void> _addData() async {
    
    if (_titleController.text.isNotEmpty || _descController.text.isNotEmpty) {
      await DBHelper.createData(_titleController.text, _descController.text);
      _refreshData(); // Refresh UI after adding
      _titleController.clear();
      _descController.clear();
    } else {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Title or Description cannot be empty!'),
        ),
      );
    }
  }

  Future<void> _updateData(int id) async {
  
    if (_titleController.text.isNotEmpty || _descController.text.isNotEmpty) {
      await DBHelper.updateData(id, _titleController.text, _descController.text);
      _refreshData(); 
      _titleController.clear();
      _descController.clear();
    } else {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Title or Description cannot be empty!'),
        ),
      );
    }
  }

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

  
  void showBottomSheet(int? id) async {
    
    _titleController.clear();
    _descController.clear();

    if (id != null) {
      
      final existingData = _alldata.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
          
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                
                onPressed: () async {
                  if (id == null) {
                    await _addData(); 
                  } else {
                    await _updateData(id); 
                  }
                  
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                  print("Operation completed successfully"); 
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    id == null ? 'Add Data' : 'Update Data',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CRUD Application'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 61, 118),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), 
            )
          : _alldata.isEmpty
              ? const Center(
                  child: Text('No data available. Add some!'), 
                )
              : ListView.builder(
                  itemCount: _alldata.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          _alldata[index]['title'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(_alldata[index]['desc']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => showBottomSheet(_alldata[index]['id']),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => _deleteData(_alldata[index]['id']),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}