import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorStorage {
  static const _key = 'favorite_colors';
  static const _max = 30;

  static Future<List<Color>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((s) => Color(int.parse(s, radix: 16)).withOpacity(1)).toList();
  }

  static Future<void> add(Color c) async {
    final prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(_key) ?? [];
    final hex = c.value.toRadixString(16).padStart(8, '0');
    if (!list.contains(hex)) { list.insert(0, hex); if (list.length > _max) list = list.take(_max).toList(); await prefs.setStringList(_key, list); }
  }

  static Future<void> remove(Color c) async {
    final prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(_key) ?? [];
    list.remove(c.value.toRadixString(16).padStart(8, '0'));
    await prefs.setStringList(_key, list);
  }
}
