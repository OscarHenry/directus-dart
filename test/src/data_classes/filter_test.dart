import 'package:directus/src/data_classes/filter.dart';
import 'package:directus/src/data_classes/query.dart';
import 'package:test/test.dart';

void main() {
  test('Filter constructors set correct values', () async {
    final query = Query(filter: {
      'zero': Filter('value'),
      'one': Filter.eq('value'),
      'two': Filter.notEq('value'),
      'three': Filter.gt('value'),
      'four': Filter.gte('value'),
      'five': Filter.lt('value'),
      'six': Filter.lte('value'),
      'seven': Filter.contains('value'),
      'eight': Filter.notContains('value'),
      'nine': Filter.empty(),
      'ten': Filter.notEmpty(),
      'eleven': Filter.isNull(),
      'twelve': Filter.notNull(),
      'thirteen': Filter.between(1, 5),
      'fourteen': Filter.notBetween(2, 6),
      'fiveteen': Filter.isIn(['value']),
      'sixteen': Filter.notIn(['value']),
    }).toMap();

    expect(query['filter']['zero'], {'_eq': 'value'});
    expect(query['filter']['one'], {'_eq': 'value'});
    expect(query['filter']['two'], {'_neq': 'value'});
    expect(query['filter']['three'], {'_gt': 'value'});
    expect(query['filter']['four'], {'_gte': 'value'});
    expect(query['filter']['five'], {'_lt': 'value'});
    expect(query['filter']['six'], {'_lte': 'value'});
    expect(query['filter']['seven'], {'_contains': 'value'});
    expect(query['filter']['eight'], {'_ncontains': 'value'});
    expect(query['filter']['nine'], {'_empty': true});
    expect(query['filter']['ten'], {'_nempty': true});
    expect(query['filter']['eleven'], {'_null': true});
    expect(query['filter']['twelve'], {'_nnull': true});
    expect(query['filter']['thirteen'], {
      '_between': [1, 5]
    });
    expect(query['filter']['fourteen'], {
      '_nbetween': [2, 6]
    });
    expect(query['filter']['fiveteen'], {
      '_in': ['value']
    });
    expect(query['filter']['sixteen'], {
      '_nin': ['value']
    });
  });

  test('Filter converts to MapEntry', () {
    final filter = Filter.eq('value').toMapEntry('field');

    expect(filter.key, 'field');
    expect(filter.value, {'_eq': 'value'});
  });

  test('Filter converts `and` comparisson', () {
    final filter = Filter.and([
      {'one': Filter.eq(2)},
      {'three': Filter.eq(4)},
      {'five': Filter.eq(6)},
    ]);
    final filterList = filter.filterListToMapList(filter.value);

    expect(filterList.length, 3);

    expect(filterList[0], {
      'one': {'_eq': 2}
    });

    expect(filterList[1], {
      'three': {'_eq': 4}
    });

    expect(filterList[2], {
      'five': {'_eq': 6}
    });
  });

  test('Filter converts  `or` comparisson', () {
    final filter = Filter.or([
      {'one': Filter.eq(2)},
      {'three': Filter.eq(4)},
      {'five': Filter.eq(6)},
    ]);
    final filterList = filter.filterListToMapList(filter.value);

    expect(filterList.length, 3);

    expect(filterList[0], {
      'one': {'_eq': 2}
    });

    expect(filterList[1], {
      'three': {'_eq': 4}
    });

    expect(filterList[2], {
      'five': {'_eq': 6}
    });
  });

  test('Filter `and` and `or` ignore provided key', () {
    final filterAnd = Filter.and([
      {'one': Filter.eq(2)},
    ]);
    final filterOr = Filter.or([
      {'one': Filter.eq(2)},
    ]);

    final andEntry = filterAnd.toMapEntry('any-random-value');
    expect(andEntry.key, '_and');
    expect(andEntry.value, isList);

    final orEntry = filterOr.toMapEntry('any-random-value');
    expect(orEntry.key, '_or');
    expect(orEntry.value, isList);
  });
}