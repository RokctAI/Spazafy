import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/models/data/user.dart';
import 'package:rokctapp/infrastructure/models/data/wallet_data.dart';

abstract class WalletRepositoryFacade {
  Future<ApiResult<List<UserModel>>> searchSending(Map<String, dynamic> params);
  Future<ApiResult<WalletHistoryData>> sendWalletBalance(
    String userUuid,
    double amount,
  );
  Future<ApiResult<dynamic>> walletTopUp({
    required double amount,
    String? token,
  });
  Future<ApiResult<List<WalletHistoryData>>> getWalletHistory();
}
