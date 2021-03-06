## observe via `source_gen`

This repository explores a new approach to implementing observability. The main
difference with `package:observe` is that:
  * we intent to use `source_gen` instead of code transformers. So all code that
    is generated will be added on the side, and not on the original file written
    by the user.

  * we simplify the API of observables in a couple ways:

    * we do not support dirty-checking. Code generation takes care of generating
      the minimum set of notifications needed.

    * we do not use stream subscriptions by default, so simple notifications
      can be delivered with little overhead.

  * we also change the API in ways that improve expressiveness:

    * granularity: observability is done at the level of properties, not
      objects. This makes it possible to observe top-level variables.

    * getters support: we support observing getters and establish automatically
      how they depend on other observable properties. This should remove any
      need for `PathObservers`.

    * listening anywhere: there is no Observable object interface anymore, only
      observable expressions (see the `observe` function below).

_Note_: the current API doesn't explore what to do about observable lists
and maps. Currently listeners are called without any change records. We need to
explore what that would look like for these collections.

#### Status

We haven't yet implemented the code generation yet.  Both
`example/ui/app.g.dart` and `test/observable_test.g.dart` are currently
generated by hand, but they can be generated automatically using `source_gen` in
the future.

#### Example

The idea behind this package is that as a user you can write observable
properties as follows:

```dart
library my_lib;
part 'my_lib.g.dart'; // the contents of my_lib.g.dart will be auto-generated.

// An observable property must be declared private. Source-gen will generate
// the corresponding public name in `my_lib.g.dart`.
@observable int _i = 0;

// The base class _ExampleObservable is auto-generated and will contain the
// public names of each observable property in this class (j and derived in this
// example).
class Example extends _ExampleObservable {

  @observable int _j = 1;

  // getters can also be observed!
  // Note: the getter uses the public member in it's body (j instead of _j).
  @observable int get _derived => j + i;
}
```

An observable expression is created by calling `observe` on a closure that
evaluates to a value. For example:
```dart
var example = new Example();
var observableExpression = observe(() => 'value-${example.derived}');
```

To listen for changes, attach a listener to an observable expression:
```dart
  var listener = () => print('Derived changed: $example');
  var cancel = observableExpression.listen(listener);
  ...
```

The `listener` callback will be invoked any time an observable subexpression
changes (until the subscription is cancelled). For example, the following code:

```dart
example.j = 2;
i = 60;
cancel();
i = 2;
```

Will print:
```
  Derived changed: value-2
  Derived changed: value-62
```

But will not print `Derived changed: value-4` because we stopped listening
before the last change.

#### Unit test

To run the unittest, simply do:
```
dart test/observe_test.dart
```

The test shows a simple pattern of observability where notifications are
delivered synchronously. It also illustrates that you can observe complex
expressions in getters.

#### Sample UI framework

To show how this works in the context of a react-like UI framework, we built an
example under [example/ui/app.dart][]. This example shows a sequence of
modifications and how the UI is "re-rendered". This code runs on the
command-line, and the rendered UI is displayed as a single-line of text with
some color highlighting to indicate how the UI was rerendered on a fine-grain
level.

While the observe library issues notifications synchronously, the UI framework
batches changes to render the UI once every event loop.

Run this sample as follows:
```
dart example/ui/app.dart
```


[example/ui/app.dart]: example/ui/app.dart
