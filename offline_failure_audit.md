# Offline Failure Audit Report

## Technical Context
The app features a Drift-based offline-first architecture with a Background Sync Queue. However, certain core functions are explicitly intended to be network-dependent due to their security, validation, or real-time requirements. This audit identifies areas where offline behavior might lead to silent failures, bypassing of necessary constraints, or unexpected user experiences due to missing or improperly handled connectivity checks.

### 1. Social Auth (Google/Facebook/Apple/Firebase)
**Expected Behavior**: Native redirects and live token generation require an active connection.
**Audit Findings**:
- In `lib/application/auth/login/login_notifier.dart` (e.g., `loginWithGoogle` around line 294) and `lib/application/auth/register/register_notifier.dart`, the code initiates connectivity checks: `final connected = await AppConnectivity.connectivity();`.
- **Failure Point**: The logic handles the `connected == true` case, attempting to interact with `GoogleSignIn().signIn()`. However, the offline fallback (an `else` block or early return for `!connected`) is either missing or gracefully failing without updating the UI state correctly (e.g., setting `isLoading: false` or showing an error snackbar), resulting in an infinite loading state or a silent failure when the user attempts social login offline.

### 2. Online Payments (Stripe/PayFast/Razorpay)
**Expected Behavior**: Payment gateway processing must occur live for security and payment validation.
**Audit Findings**:
- In `lib/application/order/order_notifier.dart` (`createOrder` method around line 526), there is a check preventing online payments when disconnected:
  ```dart
  if (!connected && payment.tag != 'cash' && payment.tag != 'wallet') {
      // Shows snackbar: "Online payments are not available offline..."
  }
  ```
- **Failure Point**: The `process` method (around line 607) in `order_notifier.dart` which acts on the specific tags (like "stripe", "pay-fast") lacks an explicit `AppConnectivity.connectivity()` check *before* calling the external repository or gateway. While `createOrder` guards the initial creation, subsequent or independent calls to process live payments might slip through if triggered directly, resulting in the app attempting to load a WebView (`onWebview?.call(...)`) without an internet connection, causing an ugly timeout or crash.

### 3. Driver Tracking (GPS)
**Expected Behavior**: Real-time relative distance, ETA, and map updates require an active connection.
**Audit Findings**:
- In `lib/application/order/order_notifier.dart` and `lib/application/map/view_map_notifier.dart`, map markers and location states are frequently updated.
- **Failure Point**: The app relies heavily on `GoogleMap` rendering and background location fetching. When offline, polling for the driver's current position will fail silently. There is no explicit fallback or UI indicator alerting the user that the "Live Tracking" is currently paused or inaccurate due to the offline state. The user might stare at a stale driver marker, assuming the driver is not moving, rather than knowing the app is offline.

### 4. Account Deletion
**Expected Behavior**: Server-side user purging is a mandatory security step and must not be queued.
**Audit Findings**:
- In `lib/application/profile/profile_notifier.dart` (line 244), `deleteAccount` checks for connectivity:
  ```dart
  Future<void> deleteAccount(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _userRepository.deleteAccount();
      // ... handles success
    }
  }
  ```
- **Failure Point**: There is no `else` block handling the offline scenario. If a user clicks "Delete Account" while offline, the method silently returns. The UI might either remain stuck in a loading state or simply ignore the tap, confusing the user who believes their account data has been purged.

### 5. Real-time Chat
**Expected Behavior**: While messages might be queued, typing indicators and instant socket-based delivery require a live connection.
**Audit Findings**:
- In `lib/application/chat/chat_notifier.dart`, the `sendMessage` function writes directly to Firestore: `_fireStore.collection('chats').doc(state.chatId).collection('messages').add(...)`.
- **Failure Point**: Firestore has built-in offline caching, meaning the message will be "sent" locally. However, without a connectivity check, the UI doesn't inform the user that the message is only queued locally. More importantly, real-time typing indicators or read receipts will fail to propagate, breaking the expected synchronous chat experience without notifying the participants of the network state.

### 6. Email Uniqueness Validation
**Expected Behavior**: Verification of duplicate emails requires a live server check.
**Audit Findings**:
- In `lib/application/auth/register/register_notifier.dart` (around line 88), `sendCode` behaves conditionally based on connectivity:
  ```dart
  final connected = await AppConnectivity.connectivity();
  if (connected) {
    // API call to _authRepository.sigUp to validate and send OTP
  } else {
    // Offline: Skip OTP and go to next screen (handled by UI calling onSuccess)
    onSuccess();
  }
  ```
- **Failure Point**: By intentionally bypassing the `sigUp` API call when offline, the app skips the `emailAlreadyExists` (HTTP 400) validation. The user is allowed to complete the local registration flow using an email that may already belong to another account. When the app eventually reconnects and the Sync Queue attempts to push the offline user data, the server will reject it, leading to a silent background failure and a corrupted local state where the user believes they are registered but are actually a "ghost" guest.

### 7. Final Checkout (createOrder)
**Expected Behavior**: Fulfillment requires a live connection to guarantee stock and process the transaction.
**Audit Findings**:
- In `lib/application/order/order_notifier.dart`, the `createOrder` method processes the order creation regardless of the `connected` status if the payment is cash or wallet.
- **Failure Point**: Bypassing the live connection for `createOrder` means the app relies purely on local Drift cache for stock verification. If the local stock is outdated (e.g., another user bought the last item), the app will successfully "create" the order offline and add it to the background Sync Queue. Upon reconnection, the server will reject the order due to insufficient stock, but the user has already been shown a "Success" screen, resulting in a severe fulfillment discrepancy and poor customer experience.