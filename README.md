# **SIMPLE DATA (Easy Database)**

A simple database derived from Get_Storage, creating CRUD for small applications.

## Example for Add or Update value

```dart
  void _addOrUpdateData() {
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
```

```dart
void _findAllData() {
  final data = SimpleDataTransactions.findAll(tableName: tableName);
}
```

```dart
void _deleteAllData() {
  SimpleDataTransactions.deleteAll(tableName: tableName);
}
```

