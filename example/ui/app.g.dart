part of observe.example.ui.app;

abstract class _ModelObservable {
  /// Generated from @observable int _i = 1;
  int get _i;
  set _i(int v);
  ObservableProperty<int> _i_cache;
  ObservableProperty<int> get _i_property {
    if (_i_cache == null) {
      _i_cache = new ObservableProperty<int>('i', () => _i, (v) => _i = v);
    }
    return _i_cache;
  }
  int get i => _i_property.value;
  set i(int v) => _i_property.value = v;

  /// Generated from @observable int _a = 1;
  int get _a;
  set _a(int v);
  ObservableProperty<int> _a_cache;
  ObservableProperty<int> get _a_property {
    if (_a_cache == null) {
      _a_cache = new ObservableProperty<int>('a', () => _a, (v) => _a = v);
    }
    return _a_cache;
  }
  int get a => _a_property.value;
  set a(int v) => _a_property.value = v;

  /// Generated from @observable int _b = 20;
  int get _b;
  set _b(int v);
  ObservableProperty<int> _b_cache;
  ObservableProperty<int> get _b_property {
    if (_b_cache == null) {
      _b_cache = new ObservableProperty<int>('b', () => _b, (v) => _b = v);
    }
    return _b_cache;
  }
  int get b => _b_property.value;
  set b(int v) => _b_property.value = v;

  /// Generated from @observable int _which = 20;
  int get _which;
  set _which(int v);
  ObservableProperty<int> _which_cache;
  ObservableProperty<int> get _which_property {
    if (_which_cache == null) {
      _which_cache = new ObservableProperty<int>('which', () => _which, (v) => _which = v);
    }
    return _which_cache;
  }
  int get which => _which_property.value;
  set which(int v) => _which_property.value = v;

  /// Generated from @observable int _val => j + 1;
  int get _val;
  ObservableProperty<int> _val_cache;
  ObservableProperty<int> get _val_property {
    if (_val_cache == null) {
      _val_cache = new ObservableProperty<int>('val', () => _val, null);
    }
    return _val_cache;
  }
  int get val => _val_property.value;
}
