import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

abstract class SearchHistoryRepository {
  Future<List<String>> getSearchHistory();
  Future<void> addSearchQuery(String query);
  Future<void> clearSearchHistory();
  Future<void> removeSearchQuery(String query);
}

@LazySingleton(as: SearchHistoryRepository)
class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  static const String _key = 'search_history';

  @override
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    
    // Remove if already exists to put it at the top
    history.remove(trimmed);
    history.insert(0, trimmed);
    
    // Keep only last 10
    if (history.length > 10) {
      history.removeLast();
    }
    await prefs.setStringList(_key, history);
  }

  @override
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  @override
  Future<void> removeSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    history.remove(query);
    await prefs.setStringList(_key, history);
  }
}
