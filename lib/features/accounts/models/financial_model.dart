class FinancialData {
  final Revenue revenue;
  final Expenses expenses;

  FinancialData({required this.revenue, required this.expenses});
}

class Revenue {
  final double revenueFromOperations;
  final double otherRevenue;

  double get totalRevenue => revenueFromOperations + otherRevenue;

  Revenue({required this.revenueFromOperations, required this.otherRevenue});
}

class Expenses {
  final double totalOperatingExpenses;
  final double costOfGoodsSold;
  final double salaries;
  final double marketing;
  // Add other expense categories as needed

  double get totalExpenses => totalOperatingExpenses + costOfGoodsSold + salaries + marketing;

  Expenses({
    required this.totalOperatingExpenses,
    required this.costOfGoodsSold,
    required this.salaries,
    required this.marketing,
  });
}