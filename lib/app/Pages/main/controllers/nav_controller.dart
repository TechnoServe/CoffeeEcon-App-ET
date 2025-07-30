import 'package:get/get.dart';

/// Controller for managing bottom navigation state and tab switching.
///
/// This controller handles the navigation state for the main app interface,
/// tracking which tab is currently selected and providing methods to switch
/// between different sections of the application.
///
/// The controller uses reactive state management to ensure the UI updates
/// automatically when the selected tab changes.
class NavController extends GetxController {
  /// Currently selected tab index (0-based)
  final currentIndex = 0.obs;

  /// Setter for changing the selected tab index
  set tab(int index) => currentIndex.value = index;
}
