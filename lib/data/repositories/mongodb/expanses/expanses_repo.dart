import 'package:fincom/utils/constants/db_constants.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../features/accounts/models/expense_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoExpenseRepo extends GetxController {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = DbCollections.expenses;
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch expenses by search query & pagination
  Future<List<ExpenseModel>> fetchExpensesBySearchQuery({required String query, int page = 1}) async {
    try {
      final List<Map<String, dynamic>> expensesData =
      await _mongoDatabase.fetchDocumentsBySearchQuery(
          collectionName: collectionName,
          query: query,
          itemsPerPage: itemsPerPage,
          page: page
      );
      return expensesData.map((data) => ExpenseModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Failed to fetch Expenses: $e';
    }
  }

  // Fetch all expenses from MongoDB
  Future<List<ExpenseModel>> fetchAllExpenses({int page = 1}) async {
    try {
      final List<Map<String, dynamic>> expensesData =
      await _mongoDatabase.fetchDocuments(collectionName: collectionName, page: page);
      return expensesData.map((data) => ExpenseModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Failed to fetch expenses: $e';
    }
  }

  // Upload a new expense
  Future<void> pushExpense({required ExpenseModel expense}) async {
    try {
      Map<String, dynamic> expenseMap = expense.toMap();
      await _mongoDatabase.insertDocument(collectionName, expenseMap);
    } catch (e) {
      throw 'Failed to upload expense: $e';
    }
  }

  // Fetch expense by ID
  Future<ExpenseModel> fetchExpenseById({required String id}) async {
    try {
      final Map<String, dynamic>? expenseData =
      await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);
      if (expenseData == null) {
        throw Exception('Expense not found with ID: $id');
      }
      return ExpenseModel.fromJson(expenseData);
    } catch (e) {
      throw 'Failed to fetch expense: $e';
    }
  }

  // Update an expense
  Future<void> updateExpense({required String id, required ExpenseModel expense}) async {
    try {
      Map<String, dynamic> expenseMap = expense.toJson();
      await _mongoDatabase.updateDocumentById(id: id, collectionName: collectionName, updatedData: expenseMap);
    } catch (e) {
      throw 'Failed to update expense: $e';
    }
  }

  // Delete an expense
  Future<void> deleteExpense({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to delete expense: $e';
    }
  }

  // Get the next expense ID
  Future<int> fetchExpenseNextId() async {
    try {
      return await _mongoDatabase.getNextId(collectionName: collectionName, fieldName: ExpenseFieldName.expenseId);
    } catch (e) {
      throw 'Failed to fetch expense ID: $e';
    }
  }

  Future<List<ExpenseModel>> fetchExpensesByDate({required DateTime startDate, required DateTime endDate,}) async {
    try {
      final List<Map<String, dynamic>> expensesData = await _mongoDatabase.fetchDocumentsDate(
          collectionName: collectionName,
          startDate: startDate,
          endDate: endDate
      );
      return expensesData.map((data) => ExpenseModel.fromJson(data)).toList();
    } catch (e) {
      throw 'Failed to fetch orders: $e';
    }
  }
}
