// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoriesState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isComboLoading => throw _privateConstructorUsedError;
  List<CategoryData> get categories => throw _privateConstructorUsedError;
  List<CategoryData> get comboCategories => throw _privateConstructorUsedError;
  int get activeIndex => throw _privateConstructorUsedError;
  int get activeComboIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoriesStateCopyWith<CategoriesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriesStateCopyWith<$Res> {
  factory $CategoriesStateCopyWith(
          CategoriesState value, $Res Function(CategoriesState) then) =
      _$CategoriesStateCopyWithImpl<$Res, CategoriesState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isComboLoading,
      List<CategoryData> categories,
      List<CategoryData> comboCategories,
      int activeIndex,
      int activeComboIndex});
}

/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res, $Val extends CategoriesState>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isComboLoading = null,
    Object? categories = null,
    Object? comboCategories = null,
    Object? activeIndex = null,
    Object? activeComboIndex = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isComboLoading: null == isComboLoading
          ? _value.isComboLoading
          : isComboLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      comboCategories: null == comboCategories
          ? _value.comboCategories
          : comboCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      activeIndex: null == activeIndex
          ? _value.activeIndex
          : activeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      activeComboIndex: null == activeComboIndex
          ? _value.activeComboIndex
          : activeComboIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoriesStateImplCopyWith<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  factory _$$CategoriesStateImplCopyWith(_$CategoriesStateImpl value,
          $Res Function(_$CategoriesStateImpl) then) =
      __$$CategoriesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isComboLoading,
      List<CategoryData> categories,
      List<CategoryData> comboCategories,
      int activeIndex,
      int activeComboIndex});
}

/// @nodoc
class __$$CategoriesStateImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesStateImpl>
    implements _$$CategoriesStateImplCopyWith<$Res> {
  __$$CategoriesStateImplCopyWithImpl(
      _$CategoriesStateImpl _value, $Res Function(_$CategoriesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isComboLoading = null,
    Object? categories = null,
    Object? comboCategories = null,
    Object? activeIndex = null,
    Object? activeComboIndex = null,
  }) {
    return _then(_$CategoriesStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isComboLoading: null == isComboLoading
          ? _value.isComboLoading
          : isComboLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      comboCategories: null == comboCategories
          ? _value._comboCategories
          : comboCategories // ignore: cast_nullable_to_non_nullable
              as List<CategoryData>,
      activeIndex: null == activeIndex
          ? _value.activeIndex
          : activeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      activeComboIndex: null == activeComboIndex
          ? _value.activeComboIndex
          : activeComboIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CategoriesStateImpl extends _CategoriesState {
  const _$CategoriesStateImpl(
      {this.isLoading = false,
      this.isComboLoading = false,
      final List<CategoryData> categories = const [],
      final List<CategoryData> comboCategories = const [],
      this.activeIndex = 1,
      this.activeComboIndex = 1})
      : _categories = categories,
        _comboCategories = comboCategories,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isComboLoading;
  final List<CategoryData> _categories;
  @override
  @JsonKey()
  List<CategoryData> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<CategoryData> _comboCategories;
  @override
  @JsonKey()
  List<CategoryData> get comboCategories {
    if (_comboCategories is EqualUnmodifiableListView) return _comboCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comboCategories);
  }

  @override
  @JsonKey()
  final int activeIndex;
  @override
  @JsonKey()
  final int activeComboIndex;

  @override
  String toString() {
    return 'CategoriesState(isLoading: $isLoading, isComboLoading: $isComboLoading, categories: $categories, comboCategories: $comboCategories, activeIndex: $activeIndex, activeComboIndex: $activeComboIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isComboLoading, isComboLoading) ||
                other.isComboLoading == isComboLoading) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._comboCategories, _comboCategories) &&
            (identical(other.activeIndex, activeIndex) ||
                other.activeIndex == activeIndex) &&
            (identical(other.activeComboIndex, activeComboIndex) ||
                other.activeComboIndex == activeComboIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isComboLoading,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_comboCategories),
      activeIndex,
      activeComboIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesStateImplCopyWith<_$CategoriesStateImpl> get copyWith =>
      __$$CategoriesStateImplCopyWithImpl<_$CategoriesStateImpl>(
          this, _$identity);
}

abstract class _CategoriesState extends CategoriesState {
  const factory _CategoriesState(
      {final bool isLoading,
      final bool isComboLoading,
      final List<CategoryData> categories,
      final List<CategoryData> comboCategories,
      final int activeIndex,
      final int activeComboIndex}) = _$CategoriesStateImpl;
  const _CategoriesState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isComboLoading;
  @override
  List<CategoryData> get categories;
  @override
  List<CategoryData> get comboCategories;
  @override
  int get activeIndex;
  @override
  int get activeComboIndex;
  @override
  @JsonKey(ignore: true)
  _$$CategoriesStateImplCopyWith<_$CategoriesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
