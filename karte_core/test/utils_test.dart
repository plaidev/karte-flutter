import 'package:flutter_test/flutter_test.dart';
import 'package:karte_core/utils.dart';

void main() {
  test("normalize", () {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);
    var ret = normalize({
      "a": "foo",
      "b": 1,
      "c": true,
      "d": dateTime,
      "e": [ dateTime ],
      "f": {
        "g": dateTime,
      },
    });
    expect(ret, {
      "a": "foo",
      "b": 1,
      "c": true,
      "d": 1,
      "e": [ 1 ],
      "f": {
        "g": 1,
      },
    });
  });
}