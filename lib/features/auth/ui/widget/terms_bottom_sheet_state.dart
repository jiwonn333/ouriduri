import 'package:flutter/cupertino.dart';

class TermsBottomSheetState extends ChangeNotifier {
  bool allChecked = false;
  bool isAgeOver14 = false;
  bool termsChecked = false;
  bool privacyChecked = false;

  void updateAllChecked(bool? value) {
    allChecked = value ?? false;
    isAgeOver14 = allChecked;
    termsChecked = allChecked;
    privacyChecked = allChecked;
    notifyListeners();
  }

  void updateIndividualCheck(bool? value, String type) {
    if (type == 'age') {
      isAgeOver14 = value ?? false;
    } else if (type == 'terms') {
      termsChecked = value ?? false;
    } else if (type == 'privacy') {
      privacyChecked = value ?? false;
    }
    allChecked = isAgeOver14 && termsChecked && privacyChecked;
    notifyListeners();
  }
}
