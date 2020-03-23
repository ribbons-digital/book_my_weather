import 'package:flutter/cupertino.dart';

class NetworkingState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _message = '';
  String get message => _message;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _message = '';
    notifyListeners();
  }
}
