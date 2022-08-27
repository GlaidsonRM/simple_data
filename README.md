A simple database derived from Get_Storage, creating CRUD for small applications.

void _deleteAllData() {
    SimpleDataTransactions.deleteAll(tableName: tableName);
}