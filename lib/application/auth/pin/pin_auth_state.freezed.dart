// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PinAuthState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  String get confirmPin => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  bool get isPinSet => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PinAuthStateCopyWith<PinAuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinAuthStateCopyWith<$Res> {
  factory $PinAuthStateCopyWith(
          PinAuthState value, $Res Function(PinAuthState) then) =
      _$PinAuthStateCopyWithImpl<$Res, PinAuthState>;
  @useResult
  $Res call(
      {bool isLoading,
      String pin,
      String confirmPin,
      bool isError,
      bool isSuccess,
      bool isPinSet,
      String errorMessage});
}

/// @nodoc
class _$PinAuthStateCopyWithImpl<$Res, $Val extends PinAuthState>
    implements $PinAuthStateCopyWith<$Res> {
  _$PinAuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? pin = null,
    Object? confirmPin = null,
    Object? isError = null,
    Object? isSuccess = null,
    Object? isPinSet = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPin: null == confirmPin
          ? _value.confirmPin
          : confirmPin // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinSet: null == isPinSet
          ? _value.isPinSet
          : isPinSet // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PinAuthStateImplCopyWith<$Res>
    implements $PinAuthStateCopyWith<$Res> {
  factory _$$PinAuthStateImplCopyWith(
          _$PinAuthStateImpl value, $Res Function(_$PinAuthStateImpl) then) =
      __$$PinAuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String pin,
      String confirmPin,
      bool isError,
      bool isSuccess,
      bool isPinSet,
      String errorMessage});
}

/// @nodoc
class __$$PinAuthStateImplCopyWithImpl<$Res>
    extends _$PinAuthStateCopyWithImpl<$Res, _$PinAuthStateImpl>
    implements _$$PinAuthStateImplCopyWith<$Res> {
  __$$PinAuthStateImplCopyWithImpl(
      _$PinAuthStateImpl _value, $Res Function(_$PinAuthStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? pin = null,
    Object? confirmPin = null,
    Object? isError = null,
    Object? isSuccess = null,
    Object? isPinSet = null,
    Object? errorMessage = null,
  }) {
    return _then(_$PinAuthStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPin: null == confirmPin
          ? _value.confirmPin
          : confirmPin // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinSet: null == isPinSet
          ? _value.isPinSet
          : isPinSet // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PinAuthStateImpl implements _PinAuthState {
  const _$PinAuthStateImpl(
      {this.isLoading = false,
      this.pin = '',
      this.confirmPin = '',
      this.isError = false,
      this.isSuccess = false,
      this.isPinSet = false,
      this.errorMessage = ''});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String pin;
  @override
  @JsonKey()
  final String confirmPin;
  @override
  @JsonKey()
  final bool isError;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final bool isPinSet;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'PinAuthState(isLoading: $isLoading, pin: $pin, confirmPin: $confirmPin, isError: $isError, isSuccess: $isSuccess, isPinSet: $isPinSet, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinAuthStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.confirmPin, confirmPin) ||
                other.confirmPin == confirmPin) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.isPinSet, isPinSet) ||
                other.isPinSet == isPinSet) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, pin, confirmPin,
      isError, isSuccess, isPinSet, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PinAuthStateImplCopyWith<_$PinAuthStateImpl> get copyWith =>
      __$$PinAuthStateImplCopyWithImpl<_$PinAuthStateImpl>(this, _$identity);
}

abstract class _PinAuthState implements PinAuthState {
  const factory _PinAuthState(
      {final bool isLoading,
      final String pin,
      final String confirmPin,
      final bool isError,
      final bool isSuccess,
      final bool isPinSet,
      final String errorMessage}) = _$PinAuthStateImpl;

  @override
  bool get isLoading;
  @override
  String get pin;
  @override
  String get confirmPin;
  @override
  bool get isError;
  @override
  bool get isSuccess;
  @override
  bool get isPinSet;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$PinAuthStateImplCopyWith<_$PinAuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
