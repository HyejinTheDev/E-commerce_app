import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/features/customer/search/domain/repositories/search_history_repository.dart';

void main() {
  late SearchHistoryRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = SearchHistoryRepositoryImpl();
  });

  group('SearchHistoryRepositoryImpl', () {
    test('getSearchHistory should return empty list initially', () async {
      final history = await repository.getSearchHistory();
      expect(history, isEmpty);
    });

    test('addSearchQuery should add a query and getSearchHistory should return it', () async {
      await repository.addSearchQuery('shoes');
      final history = await repository.getSearchHistory();
      expect(history, ['shoes']);
    });

    test('addSearchQuery should not add empty or whitespace queries', () async {
      await repository.addSearchQuery('   ');
      final history = await repository.getSearchHistory();
      expect(history, isEmpty);
    });

    test('addSearchQuery should move existing query to the top', () async {
      await repository.addSearchQuery('shoes');
      await repository.addSearchQuery('shirts');
      await repository.addSearchQuery('shoes');
      
      final history = await repository.getSearchHistory();
      expect(history, ['shoes', 'shirts']);
    });

    test('addSearchQuery should keep only the last 10 queries', () async {
      for (int i = 0; i < 15; i++) {
        await repository.addSearchQuery('query_$i');
      }
      
      final history = await repository.getSearchHistory();
      expect(history.length, 10);
      expect(history.first, 'query_14');
      expect(history.last, 'query_5');
    });

    test('removeSearchQuery should remove specific query', () async {
      await repository.addSearchQuery('shoes');
      await repository.addSearchQuery('shirts');
      
      await repository.removeSearchQuery('shoes');
      final history = await repository.getSearchHistory();
      expect(history, ['shirts']);
    });

    test('clearSearchHistory should remove all queries', () async {
      await repository.addSearchQuery('shoes');
      await repository.addSearchQuery('shirts');
      
      await repository.clearSearchHistory();
      final history = await repository.getSearchHistory();
      expect(history, isEmpty);
    });
  });
}
