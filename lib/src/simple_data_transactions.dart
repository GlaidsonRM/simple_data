import 'package:get_storage/get_storage.dart';

class SimpleDataTransactions {
  static final box = GetStorage();

  static Future<void> initDB() async {
    await GetStorage.init();
  }

  static bool saveOrUpdateData({
    required String tableName,
    required dynamic id,
    required Map<String, dynamic> value,
  }) {
    try {
      var itens = box.read(tableName);

      id = id.toString();

      if (itens != null) {
        final itemExist = itens[tableName][id];

        if (itemExist != null) {
          itens[tableName][id] = value;
        } else {
          itens[tableName].addAll({
            id: value,
          });
        }
      } else {
        itens = {
          tableName: {id: value}
        };
      }
      box.write(tableName, itens);

      return true;
    } catch (e) {
      return false;
    }
  }

  static dynamic findAll({
    required String tableName,
  }) {
    var itens = box.read(tableName);
    if(itens != null) {
      return itens[tableName];
    }
    return null;
  }

  static dynamic findById({
    required String tableName,
    required String id,
  }) {
    var itens = box.read(tableName);
    if(itens != null) {
      return itens[tableName];
    }
    return itens[tableName][id];
  }

  static bool deleteAll({
    required String tableName,
  }) {
    box.remove(tableName);
    return true;
  }

  static bool deleteById({
    required String tableName,
    required dynamic id,
  }) {
    try {
      var itens = box.read(tableName);

      id = id.toString();

      if (itens != null) {
        final itemExist = itens[tableName][id];

        if (itemExist != null) {
          itens[tableName].removeWhere((key, value) => key == id);
        }
      }
      box.write(tableName, itens);

      return true;
    } catch (e) {
      return false;
    }
  }
}
