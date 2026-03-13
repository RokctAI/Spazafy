// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_translation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AiTranslationState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get translatedUsingAi => throw _privateConstructorUsedError;
  LanguageData? get selectedLanguage => throw _privateConstructorUsedError;

  /// Create a copy of AiTranslationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiTranslationStateCopyWith<AiTranslationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiTranslationStateCopyWith<$Res> {
  factory $AiTranslationStateCopyWith(
    AiTranslationState value,
    $Res Function(AiTranslationState) then,
  ) = _$AiTranslationStateCopyWithImpl<$Res, AiTranslationState>;
  @useResult
  $Res call({
    bool isLoading,
    bool translatedUsingAi,
    LanguageData? selectedLanguage,
  });
}

/// @nodoc
class _$AiTranslationStateCopyWithImpl<$Res, $Val extends AiTranslationState>
    implements $AiTranslationStateCopyWith<$Res> {
  _$AiTranslationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiTranslationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? translatedUsingAi = null,
    Object? selectedLanguage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            translatedUsingAi: null == translatedUsingAi
                ? _value.translatedUsingAi
                : translatedUsingAi // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedLanguage: freezed == selectedLanguage
                ? _value.selectedLanguage
                : selectedLanguage // ignore: cast_nullable_to_non_nullable
                      as LanguageData?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiTranslationStateImplCopyWith<$Res>
    implements $AiTranslationStateCopyWith<$Res> {
  factory _$$AiTranslationStateImplCopyWith(
    _$AiTranslationStateImpl value,
    $Res Function(_$AiTranslationStateImpl) then,
  ) = __$$AiTranslationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool translatedUsingAi,
    LanguageData? selectedLanguage,
  });
}

/// @nodoc
class __$$AiTranslationStateImplCopyWithImpl<$Res>
    extends _$AiTranslationStateCopyWithImpl<$Res, _$AiTranslationStateImpl>
    implements _$$AiTranslationStateImplCopyWith<$Res> {
  __$$AiTranslationStateImplCopyWithImpl(
    _$AiTranslationStateImpl _value,
    $Res Function(_$AiTranslationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiTranslationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? translatedUsingAi = null,
    Object? selectedLanguage = freezed,
  }) {
    return _then(
      _$AiTranslationStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        translatedUsingAi: null == translatedUsingAi
            ? _value.translatedUsingAi
            : translatedUsingAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedLanguage: freezed == selectedLanguage
            ? _value.selectedLanguage
            : selectedLanguage // ignore: cast_nullable_to_non_nullable
                  as LanguageData?,
      ),
    );
  }
}

/// @nodoc

class _$AiTranslationStateImpl extends _AiTranslationState {
  const _$AiTranslationStateImpl({
    this.isLoading = false,
    this.translatedUsingAi = false,
    this.selectedLanguage,
  }) : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool translatedUsingAi;
  @override
  final LanguageData? selectedLanguage;

  @override
  String toString() {
    return 'AiTranslationState(isLoading: $isLoading, translatedUsingAi: $translatedUsingAi, selectedLanguage: $selectedLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiTranslationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.translatedUsingAi, translatedUsingAi) ||
                other.translatedUsingAi == translatedUsingAi) &&
            (identical(other.selectedLanguage, selectedLanguage) ||
                other.selectedLanguage == selectedLanguage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, translatedUsingAi, selectedLanguage);

  /// Create a copy of AiTranslationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiTranslationStateImplCopyWith<_$AiTranslationStateImpl> get copyWith =>
      __$$AiTranslationStateImplCopyWithImpl<_$AiTranslationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AiTranslationState extends AiTranslationState {
  const factory _AiTranslationState({
    final bool isLoading,
    final bool translatedUsingAi,
    final LanguageData? selectedLanguage,
  }) = _$AiTranslationStateImpl;
  const _AiTranslationState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get translatedUsingAi;
  @override
  LanguageData? get selectedLanguage;

  /// Create a copy of AiTranslationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiTranslationStateImplCopyWith<_$AiTranslationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
