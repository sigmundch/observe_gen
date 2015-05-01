// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library observe.test.observe_test;

import 'package:observe/observe.dart';
import 'package:unittest/unittest.dart';

part 'observe_test.g.dart';

@observable int _i = 0;

class A extends _AObservable {
  @observable int _j = 0;
  @observable int get _k => j + 1;
}

int k;

var a = new A();
copyI2J() { a.j = i; }
copyK2K() { k = a.k; }

main() {
  var cancel1 = observe(() => i).listen(copyI2J);
  var cancel2 = observe(() => a.k).listen(copyK2K);

  test('initial values are not notified', () {
    expect(i, 0);
    expect(a.j, 0);
    expect(a.k, 1);
    expect(k, isNull); // if it were notified, this would be 1.
  });

  test('change is observed synchornously', () {
    i = 1;
    expect(i, 1);
    expect(a.j, 1);
    expect(a.k, 2);
    expect(k, 2);
  });

  test('change is not observed after cancel', () {
    expect(a.k, 2);
    i = 2;
    expect(a.k, 3);
    cancel1();
    i = 5;
    expect(a.k, 3);
  });
}
