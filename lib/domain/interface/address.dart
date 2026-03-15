import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class AddressFacade {
  Future<ApiResult<AddressesResponse>> getUserAddresses();

  Future<ApiResult<void>> deleteAddress(int addressId);

  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  );
}




