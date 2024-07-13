import 'package:fast_equatable/fast_equatable.dart';

class FormRepo with FastEquatable {
  final Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;

  void update({required String key, required dynamic value}) {
    _data.update(key, (v) => value, ifAbsent: () => value);
  }

  void clear() {
    _data.clear();
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => _data.entries.toList();
}
