// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of observe;

/// Node for an observable property in an object or library. This contains logic
/// to read and write values on properties, and internally compute dependencies,
/// issue notifications, and track updates on dependencies when the underlying
/// value is changed.
/// 
/// This is meant to be used as follows:
///
///     Binding<Type> _name_property =
///         new ObservableProperty<Type>('name', () => name, (v) => name = v);
///     Type get name => _name_property.value;
///     set name(v) => _name_property.value = v;
///
/// Or if used within a class:
///     class Foo {
///       Binding<Type> _name_cache;
///       Binding<Type> get _name_property {
///         if (_name_cache == null) {
///           _name_cache = new ObservableProperty<Type>(
///               'name', () => name, (v) => name = v);
///         }
///         return _name_cache;
///       }
///       Type get name => _name_property.value;
///       set name(v) => _name_property.value = v;
///     }
class ObservableProperty<T> extends _Binding<T> {
  final String _name;
  final Getter<T> _getter;
  final Setter<T> _setter;
  T lastValue;

  ObservableProperty(this._name, this._getter, this._setter);

  get _simpleString => '#$name';

  /// Returns the current value of the property, but also construct the
  /// observable dependencies if we are reading the value in an observable
  /// scope.
  T get value {
    var last = null;
    var _shouldRecord = _current != null;
    if (_shouldRecord) {
      last = _current;
      _current = this;
      if (last != null) last._dependsOn(_current);
    }
    var res = _getter();
    if (_shouldRecord) _current = last;
    return res;
  }

  @override
  _readValue() => _getter();

  /// Update the value of the property and notify users of this property as a
  /// result.
  set value(T v) {
    _setter(v);
    if (lastValue != v) {
      lastValue = v;
      _notify();
    }
  }
}

typedef T Getter<T>();
typedef void Setter<T>(T value);
