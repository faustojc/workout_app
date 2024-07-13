import 'package:intl/intl.dart';
import 'package:powersync/sqlite3.dart' as sqlite;
import 'package:uuid/uuid.dart';
import 'package:workout_routine/data/sources/database.dart';
import 'package:workout_routine/domain/exceptions/query_builder_exception.dart';

class QueryBuilder {
  final Set<String> _selectColumns = {'*'};

  final List<Map<String, dynamic>> _whereClauses = [];
  final List<Map<String, dynamic>> _joinClauses = [];
  final List<String> _groupByFields = [];
  final List<Map<String, dynamic>> _havingClauses = [];

  String _table = '';
  String _updateQuery = '';
  String _insertQuery = '';
  String _deleteQuery = '';
  bool _selectCalled = false;
  bool _fromCalled = false;
  int? _limit;

  String? _likeField;
  String _likePattern = '%';
  String _likeWildcard = '%';

  String? _orderByField;
  bool _orderByDirection = false;

  QueryBuilder update(Map<String, dynamic> data) {
    if (_whereClauses.isEmpty) {
      throw QueryBuilderException('Cannot update without a where clause');
    }

    if (data.isEmpty) {
      throw QueryBuilderException('Cannot update empty data');
    }

    data['updated_at'] = DateTime.now().toIso8601String();

    final setClause = data.entries.map((entry) => "${entry.key} = '${entry.value}'").join(', ');
    final whereClause = _buildWhereClause();

    _updateQuery = "UPDATE $_table SET $setClause $whereClause";

    return this;
  }

  QueryBuilder insert(Map<String, dynamic> data) {
    if (data.isEmpty) {
      throw QueryBuilderException('Cannot insert empty data');
    }

    final now = DateTime.now().toIso8601String();

    data['id'] = const Uuid().v7();
    data['created_at'] = now;
    data['updated_at'] = now;

    final columns = data.keys.join(', ');
    final values = data.values.map((value) => "'$value'").join(', ');

    _insertQuery = "INSERT INTO $_table ($columns) VALUES ($values)";

    return this;
  }

  QueryBuilder delete() {
    if (_whereClauses.isEmpty) {
      throw QueryBuilderException('Cannot delete without a where clause');
    }

    final whereClause = _buildWhereClause();

    _deleteQuery = "DELETE FROM $_table $whereClause";

    return this;
  }

  QueryBuilder select({Set<String> columns = const {}}) {
    if (_selectCalled) {
      throw QueryBuilderException("The 'select' method can only be called once.");
    }

    if (columns.isEmpty) {
      return this;
    } else {
      _selectCalled = true;

      _selectColumns.clear();
      _selectColumns.addAll(columns);
    }

    return this;
  }

  QueryBuilder from(String table) {
    if (_fromCalled) {
      throw QueryBuilderException("The 'from' method can only be called once.");
    }

    if (table.isEmpty) {
      throw QueryBuilderException("You must specify the table name");
    }

    _table = table;
    _fromCalled = true;

    return this;
  }

  QueryBuilder where(String field, String operator, Object value) {
    if (!['=', '!=', '>', '<', '>=', '<='].contains(operator)) {
      throw QueryBuilderException('Invalid operator: $operator');
    }

    _whereClauses.add({'field': field, 'operator': operator, 'value': value});

    return this;
  }

  QueryBuilder whereIn(String field, List<dynamic> values) {
    _whereClauses.add({'field': field, 'operator': 'IN', 'value': values});
    return this;
  }

  QueryBuilder orWhere(String field, String operator, Object value) {
    if (_whereClauses.isEmpty) {
      throw QueryBuilderException("The 'where' method must be called before using 'orWhere'.");
    }

    _whereClauses.add({
      'field': field,
      'operator': operator,
      'value': value,
      'or': true, // Mark as an OR condition
    });
    return this;
  }

  /// Builds an ORDER BY clause with optional field and direction.
  QueryBuilder orderBy(String field, {bool ascend = false}) {
    _orderByField = field;
    _orderByDirection = ascend;
    return this;
  }

  /// Builds a LIKE clause with optional wildcard characters.
  QueryBuilder like(String field, String pattern, {String wildcard = '%'}) {
    _likeField = field;
    _likePattern = pattern;
    _likeWildcard = wildcard;
    return this;
  }

  /// Builds a LIMIT clause with the number of records to return.
  QueryBuilder limit(int limit) {
    _limit = limit;
    return this;
  }

  QueryBuilder between(String field, Object start, Object end) {
    if (!(start is num || start is String || start is DateTime) || !(end is num || end is String || end is DateTime)) {
      throw QueryBuilderException('Start and end values must be a number, string, or date.');
    }

    if (start.runtimeType != end.runtimeType) {
      throw QueryBuilderException('Start and end values must be of the same type.');
    }

    if (start is DateTime && end is DateTime) {
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

      _whereClauses.add({
        'field': field,
        'operator': 'BETWEEN',
        'value': [formatter.format(start), formatter.format(end)],
      });
    } else {
      _whereClauses.add({
        'field': field,
        'operator': 'BETWEEN',
        'value': [start, end],
      });
    }

    return this;
  }

  QueryBuilder join(String otherTable, String onCondition, {String type = 'INNER'}) {
    // Validate join type
    if (!{'INNER', 'LEFT', 'RIGHT', 'FULL'}.contains(type.toUpperCase())) {
      throw QueryBuilderException('Invalid join type: $type');
    }

    _joinClauses.add({'table': otherTable, 'onCondition': onCondition, 'type': type.toUpperCase()});
    return this;
  }

  QueryBuilder groupBy(List<String> fields) {
    _groupByFields.addAll(fields);
    return this;
  }

  QueryBuilder having(String field, String operator, Object value) {
    _havingClauses.add({'field': field, 'operator': operator, 'value': value});
    return this;
  }

  Future<sqlite.Row> get() async {
    if (_updateQuery.isNotEmpty || _insertQuery.isNotEmpty || _deleteQuery.isNotEmpty) {
      throw QueryBuilderException('The get() method cannot be called after calling the update, insert, or delete methods. Use the execute method instead.');
    }

    String sqlQuery = _buildQueryString();

    final result = await Database.instance.powersyncDb.get(sqlQuery);

    _reset();

    return result;
  }

  Future<sqlite.ResultSet> getAll() async {
    if (_updateQuery.isNotEmpty || _insertQuery.isNotEmpty || _deleteQuery.isNotEmpty) {
      throw QueryBuilderException('The getAll() method cannot be called after calling the update, insert, or delete methods. Use the execute method instead.');
    }

    String sqlQuery = _buildQueryString();

    final results = await Database.instance.powersyncDb.getAll(sqlQuery);

    _reset();

    return results;
  }

  Future<sqlite.ResultSet> execute() async {
    if (_updateQuery.isEmpty) {
      throw QueryBuilderException('The update query is empty.');
    } else if (_insertQuery.isEmpty) {
      throw QueryBuilderException('The insert query is empty.');
    } else if (_deleteQuery.isEmpty) {
      throw QueryBuilderException('The delete query is empty.');
    }

    sqlite.ResultSet result;

    if (_updateQuery.isNotEmpty) {
      result = await Database.instance.powersyncDb.execute(_updateQuery);
    } else if (_insertQuery.isNotEmpty) {
      result = await Database.instance.powersyncDb.execute(_insertQuery);
    } else {
      result = await Database.instance.powersyncDb.execute(_deleteQuery);
    }

    _reset();

    return result;
  }

  String _buildQueryString() {
    if (_table.isEmpty) {
      throw QueryBuilderException("The 'from' method must be called before building a query string.");
    }
    if (_selectColumns.isEmpty) {
      throw QueryBuilderException("The 'select' method must be called before building a query string.");
    }

    final selectClause = 'SELECT ${_selectColumns.join(', ')} FROM $_table';
    final whereClause = _buildWhereClause();
    final likeClause = _buildLikeClause();
    final orderByClause = _buildOrderByClause();
    final joinClause = _buildJoinClause();
    final groupByClause = _buildGroupByClause();
    final havingClause = _buildHavingClause();

    return '$selectClause $joinClause $whereClause $likeClause $groupByClause $havingClause $orderByClause ${_buildLimitClause()}'.trim();
  }

  String _buildWhereClause() {
    if (_whereClauses.isEmpty) return '';

    bool isFirst = true;
    final conditions = _whereClauses.map((clause) {
      final field = clause['field'];
      final operator = clause['operator'];
      final value = clause['value'];
      final isOr = clause['or'] ?? false;

      final prefix = isFirst ? (isOr ? 'OR ' : '') : (isOr ? ' OR ' : ' AND ');
      isFirst = false;

      if (value is List) {
        final formattedValues = value.map((v) => "'$v'").join(',');
        return "$prefix $field $operator ($formattedValues)";
      } else {
        return "$prefix $field $operator '$value'";
      }
    }).join();

    return 'WHERE $conditions';
  }

  String _buildOrderByClause() {
    if (_orderByField == null) return '';

    final direction = _orderByDirection ? 'ASC' : 'DESC';

    return 'ORDER BY $_orderByField $direction';
  }

  String _buildLikeClause() {
    if (_likeField == null) return '';

    return "WHERE $_likeField LIKE '$_likeWildcard$_likePattern$_likeWildcard'";
  }

  String _buildLimitClause() {
    return _limit != null ? 'LIMIT $_limit' : '';
  }

  String _buildJoinClause() {
    if (_joinClauses.isEmpty) return '';

    return _joinClauses.map((clause) {
      return "${clause['type']} JOIN ${clause['table']} ON ${clause['onCondition']}";
    }).join(' ');
  }

  String _buildGroupByClause() {
    if (_groupByFields.isEmpty) return '';

    return 'GROUP BY ${_groupByFields.join(', ')}';
  }

  String _buildHavingClause() {
    if (_havingClauses.isEmpty) return '';

    final conditions = _havingClauses.map((clause) {
      return "${clause['field']} ${clause['operator']} '${clause['value']}'";
    }).join(' AND ');

    return 'HAVING $conditions';
  }

  void _reset() {
    _selectColumns.clear();
    _whereClauses.clear();
    _joinClauses.clear();
    _groupByFields.clear();
    _havingClauses.clear();
    _table = '';
    _selectCalled = false;
    _fromCalled = false;
    _limit = null;
    _likeField = null;
    _likePattern = '%';
    _likeWildcard = '%';
    _orderByField = null;
    _orderByDirection = false;
  }

  String toSql() {
    return _buildQueryString();
  }
}
