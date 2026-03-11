// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_printer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BillingPrinterState {
  PrinterStatus get status => throw _privateConstructorUsedError;
  List<BluetoothInfo> get devices => throw _privateConstructorUsedError;
  String? get connectedMac => throw _privateConstructorUsedError;
  String? get connectedName => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BillingPrinterStateCopyWith<BillingPrinterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingPrinterStateCopyWith<$Res> {
  factory $BillingPrinterStateCopyWith(
          BillingPrinterState value, $Res Function(BillingPrinterState) then) =
      _$BillingPrinterStateCopyWithImpl<$Res, BillingPrinterState>;
  @useResult
  $Res call(
      {PrinterStatus status,
      List<BluetoothInfo> devices,
      String? connectedMac,
      String? connectedName,
      String? errorMessage});
}

/// @nodoc
class _$BillingPrinterStateCopyWithImpl<$Res, $Val extends BillingPrinterState>
    implements $BillingPrinterStateCopyWith<$Res> {
  _$BillingPrinterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? devices = null,
    Object? connectedMac = freezed,
    Object? connectedName = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrinterStatus,
      devices: null == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<BluetoothInfo>,
      connectedMac: freezed == connectedMac
          ? _value.connectedMac
          : connectedMac // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedName: freezed == connectedName
          ? _value.connectedName
          : connectedName // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillingPrinterStateImplCopyWith<$Res>
    implements $BillingPrinterStateCopyWith<$Res> {
  factory _$$BillingPrinterStateImplCopyWith(_$BillingPrinterStateImpl value,
          $Res Function(_$BillingPrinterStateImpl) then) =
      __$$BillingPrinterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PrinterStatus status,
      List<BluetoothInfo> devices,
      String? connectedMac,
      String? connectedName,
      String? errorMessage});
}

/// @nodoc
class __$$BillingPrinterStateImplCopyWithImpl<$Res>
    extends _$BillingPrinterStateCopyWithImpl<$Res, _$BillingPrinterStateImpl>
    implements _$$BillingPrinterStateImplCopyWith<$Res> {
  __$$BillingPrinterStateImplCopyWithImpl(_$BillingPrinterStateImpl _value,
      $Res Function(_$BillingPrinterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? devices = null,
    Object? connectedMac = freezed,
    Object? connectedName = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$BillingPrinterStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PrinterStatus,
      devices: null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<BluetoothInfo>,
      connectedMac: freezed == connectedMac
          ? _value.connectedMac
          : connectedMac // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedName: freezed == connectedName
          ? _value.connectedName
          : connectedName // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BillingPrinterStateImpl extends _BillingPrinterState {
  const _$BillingPrinterStateImpl(
      {this.status = PrinterStatus.initial,
      final List<BluetoothInfo> devices = const [],
      this.connectedMac,
      this.connectedName,
      this.errorMessage})
      : _devices = devices,
        super._();

  @override
  @JsonKey()
  final PrinterStatus status;
  final List<BluetoothInfo> _devices;
  @override
  @JsonKey()
  List<BluetoothInfo> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  final String? connectedMac;
  @override
  final String? connectedName;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BillingPrinterState(status: $status, devices: $devices, connectedMac: $connectedMac, connectedName: $connectedName, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingPrinterStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            (identical(other.connectedMac, connectedMac) ||
                other.connectedMac == connectedMac) &&
            (identical(other.connectedName, connectedName) ||
                other.connectedName == connectedName) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_devices),
      connectedMac,
      connectedName,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingPrinterStateImplCopyWith<_$BillingPrinterStateImpl> get copyWith =>
      __$$BillingPrinterStateImplCopyWithImpl<_$BillingPrinterStateImpl>(
          this, _$identity);
}

abstract class _BillingPrinterState extends BillingPrinterState {
  const factory _BillingPrinterState(
      {final PrinterStatus status,
      final List<BluetoothInfo> devices,
      final String? connectedMac,
      final String? connectedName,
      final String? errorMessage}) = _$BillingPrinterStateImpl;
  const _BillingPrinterState._() : super._();

  @override
  PrinterStatus get status;
  @override
  List<BluetoothInfo> get devices;
  @override
  String? get connectedMac;
  @override
  String? get connectedName;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$BillingPrinterStateImplCopyWith<_$BillingPrinterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
