import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybank/models/category.dart';
import 'package:piggybank/models/record.dart';

import 'database-service.dart';


class InMemoryDatabase implements DatabaseService {

    /// InMemoryDatabase is an implementation of DatabaseService that runs in memory.
    /// All this methods are implemented using operations on Lists.
    /// InMemoryDatabase is intended for debug/testing purposes.

    static List<Category> _categories = [
        Category("Rent", iconCodePoint: FontAwesomeIcons.home.codePoint, categoryType: 0, id: 1),
        Category("Food", iconCodePoint: FontAwesomeIcons.hamburger.codePoint, categoryType: 0, id: 2),
        Category("Salary", iconCodePoint: FontAwesomeIcons.wallet.codePoint, categoryType: 1, id: 3)
    ];

    static List<Record> _movements = [
        Record(-300, "Rent", _categories[0], DateTime.parse("2020-05-01 10:30:00"), id: 1),
        Record(-30, "Pizza", _categories[1], DateTime.parse("2020-05-01 09:30:00"), id: 2),
        Record(1700, "Salary", _categories[2], DateTime.parse("2020-05-02 09:30:00"), id: 3),
        Record(-30, "Restaurant", _categories[1], DateTime.parse("2020-05-02 10:30:00"), id: 4),
        Record(-60.5, "Groceries", _categories[1], DateTime.parse("2020-05-03 10:30:00"), id: 5),
    ];

    static List<Record> get movements => _movements;
    static List<Category> get categories => _categories;

    Future<Category> getCategoryById(int id) {
        var matching = _categories.where((x) => x.id == id).toList();
        return (matching.isEmpty) ? Future<Category>.value(null): Future<Category>.value(matching[0]);
    }

    Future<List<Category>> getAllCategories() async {
        return Future<List<Category>>.value(_categories);
    }

    Future<List<Category>> getCategoriesByType(int categoryType) async {
        return Future<List<Category>>.value(_categories.where((x) => x.categoryType == categoryType).toList());
    }

    Future<Category> getCategoryByName(String name) {
        var matching = _categories.where((x) => x.name == name).toList();
        return (matching.isEmpty) ? Future<Category>.value(null): Future<Category>.value(matching[0]);
    }

    Future<int> upsertCategory(Category category) async {
        var categoryWithTheSameId = await getCategoryById(category.id);
        if (categoryWithTheSameId != null) {
            // I'm updating an existing category
            _categories[_categories.indexOf(categoryWithTheSameId)] = category;
        } else {
            // no category with the same id exists, adding new category
            // new category can have the same name of another one
            // if so, update the category with the same name, keeping the id
            // otherwise, add new category assigning the id
            var categoryWithTheSameName = await getCategoryByName(category.name);
            if (categoryWithTheSameName != null) {
                var indexOfExistingCategory = _categories.indexOf(categoryWithTheSameName);
                category.id = categoryWithTheSameName.id;
                _categories[indexOfExistingCategory] = category;
            } else {
                category.id = _categories.length + 1;
                _categories.add(category);
            }
        }
        return Future<int>.value(category.id);
    }

    Future<void> deleteCategoryById(int categoryId) async {
        _categories.removeWhere((x) => x.id == categoryId);
    }

    Future<int> addRecord(Record movement) async {
        movement.id = _movements.length + 1;
        _movements.add(movement);
        return Future<int>.value(movement.id);
    }

    Future<int> addCategory(Category category) async {
      category.id = _categories.length + 1;
      _categories.add(category);
      return Future<int>.value(category.id);
    }

    Future<List<Record>> getAllRecords() async {
        return Future<List<Record>>.value(_movements);
    }

    Future<List<Record>> getAllRecordsInInterval(DateTime from, DateTime to) async {
        List<Record> targetMovements = _movements.where((movement) =>
            movement.dateTime.isAfter(from) && movement.dateTime.isBefore(to)).toList();
        return Future<List<Record>>.value(targetMovements);
    }

    @override
    Future<int> addCategoryIfNotExists(Category category) async {
      Category foundCategory = await this.getCategoryById(category.id);
      if (foundCategory == null) {
        return await addCategory(category);
      }
    }

    @override
    Future<Record> getRecordById(int id) {
      var matching = _movements.where((x) => x.id == id).toList();
      return (matching.isEmpty) ? Future<Record>.value(null): Future<Record>.value(matching[0]);
    }

    @override
    Future<int> updateRecordById(int movementId, Record newMovement) async {
      var movementWithTheSameId = await getRecordById(movementId);
      if (movementWithTheSameId == null) {
          throw Exception("Movement ID `$movementId` does not exists.");
      }
      _movements[_movements.indexOf(movementWithTheSameId)] = newMovement;
      return movementId;
    }

    @override
    Future<void> deleteRecordById(int id) {
      _movements.removeWhere((x) => x.id == id);
    }

}