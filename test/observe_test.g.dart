part of observe.test.observe_test;

/// Generated from @observable int _i = 0;
ObservableProperty<int> _i_property =
  new ObservableProperty<int>('i', () => _i, (v) => _i = v);
int get i => _i_property.value;
set i(int v) => _i_property.value = v;


abstract class _AObservableHelpers {
  /// Generated from @observable int _j = 0;
  int get _j;
  set _j(int v);
  ObservableProperty<int> _j_cache;
  ObservableProperty<int> get _j_property {
    if (_j_cache == null) {
      _j_cache = new ObservableProperty<int>('j', () => _j, (v) => _j = v);
    }
    return _j_cache;
  }
  int get j => _j_property.value;
  set j(int v) => _j_property.value = v;

  /// Generated from @observable int _k => j + 1;
  int get _k;
  ObservableProperty<int> _k_cache;
  ObservableProperty<int> get _k_property {
    if (_k_cache == null) {
      _k_cache = new ObservableProperty<int>('k', () => _k, null);
    }
    return _k_cache;
  }
  int get k => _k_property.value;
}
