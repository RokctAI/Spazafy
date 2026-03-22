import 'package:rokctapp/infrastructure/models/response/wallet_histories_response.dart';
import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart';
import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:rokctapp/infrastructure/models/data/referral_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models.dart' hide UserData;
part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(true) bool isLoading,
    @Default(true) bool isReferralLoading,
    @Default(false) bool isSaveLoading,
    @Default(true) bool isLoadingHistory,
    @Default(0) int typeIndex,
    @Default("") String bgImage,
    @Default("") String logoImage,
    @Default(null) AddressData? addressModel,
    @Default(null) UserData? userData,
    @Default(null) ReferralModel? referralData,
    @Default([]) List<WalletData>? walletHistory,
    @Default([]) List<String> filepath,
  }) = _ProfileState;

  const ProfileState._();
}
