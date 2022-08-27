import 'package:example/entity_example.dart';
import 'package:flutter/material.dart';
import 'package:simple_data/simple_data.dart';

void main() async {
  ///First step, we must initialize the bank instance.
  await SimpleDataTransactions.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _valueController = TextEditingController();

  final String tableName = 'table_test';
  List<EntityExample> itens = [];

  @override
  void initState() {
    _findAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Data'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _idController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the id';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    label: const Text('ID'),
                    hintText: 'Please enter the ID',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _valueController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the value';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    label: const Text('Value'),
                    hintText: 'Insert Value here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _addOrUpdateData,
                      child: const Text('Add/Update Data'),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteAllData,
                      child: const Text('Delete All Data'),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
                child: ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, index) {

                      final item = itens[index];

                      return ListTile(
                        title: Text(item.value!),
                        subtitle: Text(item.id!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: (){
                                _idController.text = item.id!;
                                _valueController.text = item.value!;
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red,),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _addOrUpdateData() {
    if (_formKey.currentState!.validate()) {

      final entityExample = EntityExample(
        id: _idController.text,
        value: _valueController.text,
      );

      SimpleDataTransactions.saveOrUpdateData(
          tableName: tableName,
          id: entityExample.id,
          value: entityExample.toJson());

      _idController.clear();
      _valueController.clear();
      setState(() {
        _findAllData();
      });
    }
  }

  void _findAllData() {
    itens.clear();
    final data = SimpleDataTransactions.findAll(tableName: tableName);
    if(data == null){
      return;
    }
    List dataList = data.keys.toList();
    for (var element in dataList) {
      itens.add(EntityExample.fromJson(data[element]));
    }
    setState(() {});
  }

  void _deleteItem(int index) {
    SimpleDataTransactions.deleteById(tableName: tableName, id: itens[index].id);
    setState(() {
      _findAllData();
    });
  }

  void _deleteAllData() {
    SimpleDataTransactions.deleteAll(tableName: tableName);
    setState(() {
      _findAllData();
    });
  }
}
