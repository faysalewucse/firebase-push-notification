
import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Implement your logic based on the app lifecycle state.
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground.
      print('=======>> App is in the foreground <<========');
    } else if (state == AppLifecycleState.inactive) {
      // App is in an inactive state.
      print('=======>> App is in the inactive <<========');
    } else if (state == AppLifecycleState.paused) {
      // App is in the background.
      print('=======>> App is in the background <<========');
    } else if (state == AppLifecycleState.detached) {
      // App is detached (e.g., terminated).
      print('=======>> App is in the terminated <<========');
    }
  }
}