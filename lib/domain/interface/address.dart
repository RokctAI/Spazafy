import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/single_address_response.dart';
import 'package:rokctapp/infrastructure/models/data/local_address_data.dart';
import 'package:rokctapp/infrastructure/models/response/addresses_response.dart';

import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class AddressRepositoryFacade {
  Future<ApiResult<AddressesResponse>> getUserAddresses();

  Future<ApiResult<void>> deleteAddress(int addressId);

  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  );
}
