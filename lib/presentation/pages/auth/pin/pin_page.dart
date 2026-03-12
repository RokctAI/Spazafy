import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/application/auth/pin/pin_auth_provider.dart';
import 'package:venderfoodyman/presentation/component/components.dart';
import 'package:venderfoodyman/presentation/styles/style.dart';
import 'package:venderfoodyman/presentation/routes/app_router.dart';
import 'widgets/pin_pad.dart';

enum PinPageType { login, lock }

@RoutePage()
class PinPage extends ConsumerStatefulWidget {
  final PinPageType type;
  const PinPage({super.key, this.type = PinPageType.login});

  @override
  ConsumerState<PinPage> createState() => _PinPageState();
}

class _PinPageState extends ConsumerState<PinPage> {
  String _enteredPin = '';
  bool _isConfirming = false;

  void _handlePinTap(String value) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += value;
      });

      if (_enteredPin.length == 4) {
        _processPin();
      }
    }
  }

  void _handleDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _processPin() {
    final state = ref.read(pinAuthProvider);
    final notifier = ref.read(pinAuthProvider.notifier);

    if (widget.type == PinPageType.lock) {
      if (notifier.verifyPin(_enteredPin)) {
        context.popRoute();
      } else {
        setState(() {
          _enteredPin = '';
        });
      }
      return;
    }

    // Login logic
    if (!state.isPinSet) {
      if (!_isConfirming) {
        notifier.updatePin(_enteredPin);
        setState(() {
          _enteredPin = '';
          _isConfirming = true;
        });
      } else {
        notifier.updateConfirmPin(_enteredPin);
        notifier.setPin().then((_) {
          final newState = ref.read(pinAuthProvider);
          if (newState.isSuccess) {
            context.replaceRoute(const MainRoute());
          } else {
            setState(() {
              _enteredPin = '';
            });
          }
        });
      }
    } else {
      if (notifier.verifyPin(_enteredPin)) {
        context.replaceRoute(const MainRoute());
      } else {
        setState(() {
          _enteredPin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pinAuthProvider);
    final isLock = widget.type == PinPageType.lock;

    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            40.verticalSpace,
            if (isLock) ...[
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 44.r,
                  color: AppStyle.primary,
                ),
              ),
              24.verticalSpace,
              Text(
                'POS Locked',
                style: AppStyle.interBold(size: 24),
              ),
              8.verticalSpace,
              Text(
                'Enter PIN to resume session',
                style: AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
              ),
            ] else ...[
              Text(
                !state.isPinSet
                    ? (_isConfirming ? 'Confirm PIN' : 'Set your PIN')
                    : 'Enter your PIN',
                style: AppStyle.interBold(size: 22),
              ),
              8.verticalSpace,
              Text(
                'To access the POS offline',
                style: AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
              ),
            ],
            40.verticalSpace,
            _buildPinDots(),
            if (!isLock && state.isError)
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  state.errorMessage,
                  style: AppStyle.interNormal(size: 14, color: AppStyle.red),
                ),
              ),
            const Spacer(),
            PinPad(onTap: _handlePinTap, onDelete: _handleDelete),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < _enteredPin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppStyle.primary : AppStyle.white,
            border: Border.all(
              color: isActive ? AppStyle.primary : AppStyle.borderColor,
              width: 2.r,
            ),
          ),
        );
      }),
    );
  }
}
