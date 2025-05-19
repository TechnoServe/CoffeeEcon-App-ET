import 'package:get/get.dart';

class StockController extends GetxController {
  final selectedTimeRange = 'Weekly'.tr.obs;
  final currentPrice = 350.0.obs;
  final priceChange = 0.05.obs;
  final isPositiveChange = true.obs;

  // Mock data for the chart
  final chartData = [
    {'day': 'Mon', 'price': 100.0},
    {'day': 'Tue', 'price': 500.0},
    {'day': 'Wed', 'price': 1200.0},
    {'day': 'Thu', 'price': 800.0},
    {'day': 'Fri', 'price': 350.0},
    {'day': 'Sat', 'price': 400.0},
    {'day': 'Sun', 'price': 350.0},
  ].obs;

  // Mock data for different time ranges
  final timeRangeData = {
    'Daily': [
      {'time': '9:00', 'price': 300.0},
      {'time': '10:00', 'price': 320.0},
      {'time': '11:00', 'price': 350.0},
      {'time': '12:00', 'price': 340.0},
      {'time': '13:00', 'price': 360.0},
      {'time': '14:00', 'price': 355.0},
      {'time': '15:00', 'price': 350.0},
    ],
    'Weekly': [
      {'day': 'Mon', 'price': 100.0},
      {'day': 'Tue', 'price': 500.0},
      {'day': 'Wed', 'price': 1200.0},
      {'day': 'Thu', 'price': 800.0},
      {'day': 'Fri', 'price': 350.0},
      {'day': 'Sat', 'price': 400.0},
      {'day': 'Sun', 'price': 350.0},
    ],
    'Monthly': [
      {'week': 'W1', 'price': 320.0},
      {'week': 'W2', 'price': 340.0},
      {'week': 'W3', 'price': 360.0},
      {'week': 'W4', 'price': 350.0},
    ],
    'Yearly': [
      {'month': 'Jan', 'price': 300.0},
      {'month': 'Feb', 'price': 310.0},
      {'month': 'Mar', 'price': 330.0},
      {'month': 'Apr', 'price': 340.0},
      {'month': 'May', 'price': 360.0},
      {'month': 'Jun', 'price': 350.0},
      {'month': 'Jul', 'price': 370.0},
      {'month': 'Aug', 'price': 380.0},
      {'month': 'Sep', 'price': 350.0},
      {'month': 'Oct', 'price': 340.0},
      {'month': 'Nov', 'price': 360.0},
      {'month': 'Dec', 'price': 350.0},
    ],
  }.obs;

  final coffeeStocks = [
    {
      'name': 'Yirgachefe Coffee',
      'type': 'Parchment Coffee',
      'price': 350.0,
      'change': 0.07,
      'isPositive': true,
    },
    {
      'name': 'Sidamo Coffee',
      'type': 'Green Coffee',
      'price': 300.0,
      'change': 0.07,
      'isPositive': false,
    },
    {
      'name': 'Harrar Coffee',
      'type': 'Washed Coffee',
      'price': 300.0,
      'change': 0.07,
      'isPositive': false,
    },
    {
      'name': 'Limu Coffee',
      'type': 'Natural Coffee',
      'price': 350.0,
      'change': 0.07,
      'isPositive': true,
    },
    {
      'name': 'Jimma Coffee',
      'type': 'Forest Coffee',
      'price': 280.0,
      'change': 0.05,
      'isPositive': true,
    },
    {
      'name': 'Kona Coffee',
      'type': 'Premium Coffee',
      'price': 400.0,
      'change': 0.06,
      'isPositive': true,
    },
  ].obs;

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
    // Update chart data based on selected time range
    final newData = timeRangeData[range];
    if (newData != null) {
      chartData.assignAll(newData);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with weekly data
    updateTimeRange('Weekly');
  }
}
