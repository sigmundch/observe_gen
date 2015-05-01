// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An implementation of observability using interceptors. This implementation
/// can provide synchronous notifications of observable changes.
library observe;

part 'src/binding.dart';
part 'src/observable_property.dart';

/// Annotation used by our source-generator to convert properties annotated with
/// `@observable` into real observable properties.
///
/// The covnertion will expose the property as a getter/setter pair.  When
/// attaching listeners, the getters record what other observable fields are
/// used when evaluating an expression to keep track of dependencies between
/// observables.
const observable = const _ObservableEngine();

/// Create a binding that observes changes when invoking the 0-arg function [f].
///
/// A typical use of this function is to immediatelly attach a listener to the
/// returned binding: `observe(f).listen(listener);`.
Binding observe(f) => new ExpressionBinding(f);

/// Whether we are currently tracking dependencies between observable
/// expressions. Used internally by the intereptor and binding implementations.
Binding _current = null;

/// Wrap a one-arg function [f] into a function that ignores obververs
/// internally. This is useful if you want to track observability only in a
/// subset of the subexpressions.
ignoreObservers(f) => (e) {
  var c = _current;
  _current = null;
  var r = f(e);
  _current = c;
  return r;
};

/// A binding that shows the current value being tracked and provides
/// synchronous notifications whenever the value changes.
///
/// You may consider a [Binding] to be a scope where we track observable changes
/// and observable dependencies.
abstract class Binding<T> {
  /// The current value of the binding.
  T get value;

  /// Attach [listener] to this binding.
  Canceller listen(void listener());
}

/// A closure returned from `Binding.listen` to stop listening on a binding.
typedef void Canceller();

/// Node for an observable expression.
class ExpressionBinding<T> extends _Binding<T> implements Binding<T> {
  /// Closure that returns the current value of the expression.
  Function _read;
  ExpressionBinding(this._read);

  T get value => _read();

  @override
  T _readValue() => _read();
}
