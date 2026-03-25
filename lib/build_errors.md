# Build Errors Tracking

## Mock Auth Repository
- [ ] `MockAuthRepository.sigUpWithData`: Change `UserModel` to `dynamic` to match interface.
- [ ] `MockAuthRepository.sigUpWithPhone`: Change `UserModel` to `dynamic` to match interface.
- [ ] `MockAuthRepository.verifyEmail`: Add named parameter `email`.

## Type Mismatches (String vs Int)
- [ ] `edit_food_stocks_body.dart:130`: `String?` to `int?` assignment.
- [ ] `edit_food_details_body.dart:115`: `state.product?.id` (String?) to `modelId` (int?).
- [ ] `delete_extras_item_modal.dart:66`: `extras.id` (String?) to `extrasId` (int?).

## Presentation Component Issues
- [ ] `edit_food_details_body.dart`: Duplicate import of `Loading`.
- [ ] `edit_food_details_body.dart`: Duplicate import of `SnackBarType`.
- [ ] `edit_food_details_body.dart`: `AppValidators.maxQtyCheck` missing.
- [ ] `edit_food_details_body.dart:296`: `showCheckTopSnackBar` argument count mismatch (needs context and text).

## Model Missing Members
- [ ] `group_detail_extras_item.dart:45`: `extras.group?.shopId` undefined.
