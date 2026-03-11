// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BillingState {
  List<CartItem> get cartItems => throw _privateConstructorUsedError;
  bool get isScanning => throw _privateConstructorUsedError;
  String? get lastScannedBarcode => throw _privateConstructorUsedError;
  ScanPromptType get promptType => throw _privateConstructorUsedError;
  ProductData? get selectedProduct => throw _privateConstructorUsedError;
  int get scanCount => throw _privateConstructorUsedError;
  bool get isPrinting => throw _privateConstructorUsedError;
  bool get printSuccess => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BillingStateCopyWith<BillingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingStateCopyWith<$Res> {
  factory $BillingStateCopyWith(
    BillingState value,
    $Res Function(BillingState) then,
  ) = _$BillingStateCopyWithImpl<$Res, BillingState>;
  @useResult
  $Res call({
    List<CartItem> cartItems,
    bool isScanning,
    String? lastScannedBarcode,
    ScanPromptType promptType,
    ProductData? selectedProduct,
    int scanCount,
    bool isPrinting,
    bool printSuccess,
    double totalAmount,
  });
}

/// @nodoc
class _$BillingStateCopyWithImpl<$Res, $Val extends BillingState>
    implements $BillingStateCopyWith<$Res> {
  _$BillingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartItems = null,
    Object? isScanning = null,
    Object? lastScannedBarcode = freezed,
    Object? promptType = null,
    Object? selectedProduct = freezed,
    Object? scanCount = null,
    Object? isPrinting = null,
    Object? printSuccess = null,
    Object? totalAmount = null,
  }) {
    return _then(
      _value.copyWith(
            cartItems: null == cartItems
                ? _value.cartItems
                : cartItems // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            isScanning: null == isScanning
                ? _value.isScanning
                : isScanning // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastScannedBarcode: freezed == lastScannedBarcode
                ? _value.lastScannedBarcode
                : lastScannedBarcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            promptType: null == promptType
                ? _value.promptType
                : promptType // ignore: cast_nullable_to_non_nullable
                      as ScanPromptType,
            selectedProduct: freezed == selectedProduct
                ? _value.selectedProduct
                : selectedProduct // ignore: cast_nullable_to_non_nullable
                      as ProductData?,
            scanCount: null == scanCount
                ? _value.scanCount
                : scanCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isPrinting: null == isPrinting
                ? _value.isPrinting
                : isPrinting // ignore: cast_nullable_to_non_nullable
                      as bool,
            printSuccess: null == printSuccess
                ? _value.printSuccess
                : printSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingStateImplCopyWith<$Res>
    implements $BillingStateCopyWith<$Res> {
  factory _$$BillingStateImplCopyWith(
    _$BillingStateImpl value,
    $Res Function(_$BillingStateImpl) then,
  ) = __$$BillingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartItem> cartItems,
    bool isScanning,
    String? lastScannedBarcode,
    ScanPromptType promptType,
    ProductData? selectedProduct,
    int scanCount,
    bool isPrinting,
    bool printSuccess,
    double totalAmount,
  });
}

/// @nodoc
class __$$BillingStateImplCopyWithImpl<$Res>
    extends _$BillingStateCopyWithImpl<$Res, _$BillingStateImpl>
    implements _$$BillingStateImplCopyWith<$Res> {
  __$$BillingStateImplCopyWithImpl(
    _$BillingStateImpl _value,
    $Res Function(_$BillingStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartItems = null,
    Object? isScanning = null,
    Object? lastScannedBarcode = freezed,
    Object? promptType = null,
    Object? selectedProduct = freezed,
    Object? scanCount = null,
    Object? isPrinting = null,
    Object? printSuccess = null,
    Object? totalAmount = null,
  }) {
    return _then(
      _$BillingStateImpl(
        cartItems: null == cartItems
            ? _value._cartItems
            : cartItems // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        isScanning: null == isScanning
            ? _value.isScanning
            : isScanning // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastScannedBarcode: freezed == lastScannedBarcode
            ? _value.lastScannedBarcode
            : lastScannedBarcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        promptType: null == promptType
            ? _value.promptType
            : promptType // ignore: cast_nullable_to_non_nullable
                  as ScanPromptType,
        selectedProduct: freezed == selectedProduct
            ? _value.selectedProduct
            : selectedProduct // ignore: cast_nullable_to_non_nullable
                  as ProductData?,
        scanCount: null == scanCount
            ? _value.scanCount
            : scanCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isPrinting: null == isPrinting
            ? _value.isPrinting
            : isPrinting // ignore: cast_nullable_to_non_nullable
                  as bool,
        printSuccess: null == printSuccess
            ? _value.printSuccess
            : printSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$BillingStateImpl extends _BillingState {
  const _$BillingStateImpl({
    final List<CartItem> cartItems = const [],
    this.isScanning = false,
    this.lastScannedBarcode,
    this.promptType = ScanPromptType.none,
    this.selectedProduct,
    this.scanCount = 1,
    this.isPrinting = false,
    this.printSuccess = false,
    this.totalAmount = 0.0,
  }) : _cartItems = cartItems,
       super._();

  final List<CartItem> _cartItems;
  @override
  @JsonKey()
  List<CartItem> get cartItems {
    if (_cartItems is EqualUnmodifiableListView) return _cartItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartItems);
  }

  @override
  @JsonKey()
  final bool isScanning;
  @override
  final String? lastScannedBarcode;
  @override
  @JsonKey()
  final ScanPromptType promptType;
  @override
  final ProductData? selectedProduct;
  @override
  @JsonKey()
  final int scanCount;
  @override
  @JsonKey()
  final bool isPrinting;
  @override
  @JsonKey()
  final bool printSuccess;
  @override
  @JsonKey()
  final double totalAmount;

  @override
  String toString() {
    return 'BillingState(cartItems: $cartItems, isScanning: $isScanning, lastScannedBarcode: $lastScannedBarcode, promptType: $promptType, selectedProduct: $selectedProduct, scanCount: $scanCount, isPrinting: $isPrinting, printSuccess: $printSuccess, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingStateImpl &&
            const DeepCollectionEquality().equals(
              other._cartItems,
              _cartItems,
            ) &&
            (identical(other.isScanning, isScanning) ||
                other.isScanning == isScanning) &&
            (identical(other.lastScannedBarcode, lastScannedBarcode) ||
                other.lastScannedBarcode == lastScannedBarcode) &&
            (identical(other.promptType, promptType) ||
                other.promptType == promptType) &&
            (identical(other.selectedProduct, selectedProduct) ||
                other.selectedProduct == selectedProduct) &&
            (identical(other.scanCount, scanCount) ||
                other.scanCount == scanCount) &&
            (identical(other.isPrinting, isPrinting) ||
                other.isPrinting == isPrinting) &&
            (identical(other.printSuccess, printSuccess) ||
                other.printSuccess == printSuccess) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_cartItems),
    isScanning,
    lastScannedBarcode,
    promptType,
    selectedProduct,
    scanCount,
    isPrinting,
    printSuccess,
    totalAmount,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingStateImplCopyWith<_$BillingStateImpl> get copyWith =>
      __$$BillingStateImplCopyWithImpl<_$BillingStateImpl>(this, _$identity);
}

abstract class _BillingState extends BillingState {
  const factory _BillingState({
    final List<CartItem> cartItems,
    final bool isScanning,
    final String? lastScannedBarcode,
    final ScanPromptType promptType,
    final ProductData? selectedProduct,
    final int scanCount,
    final bool isPrinting,
    final bool printSuccess,
    final double totalAmount,
  }) = _$BillingStateImpl;
  const _BillingState._() : super._();

  @override
  List<CartItem> get cartItems;
  @override
  bool get isScanning;
  @override
  String? get lastScannedBarcode;
  @override
  ScanPromptType get promptType;
  @override
  ProductData? get selectedProduct;
  @override
  int get scanCount;
  @override
  bool get isPrinting;
  @override
  bool get printSuccess;
  @override
  double get totalAmount;
  @override
  @JsonKey(ignore: true)
  _$$BillingStateImplCopyWith<_$BillingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
