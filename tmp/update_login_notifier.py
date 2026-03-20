import os

file_path = r"c:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib\application\auth\login\login_notifier.dart"

old_block = """          if (AppConstants.isDemo) {
            context.replaceRoute(UiTypeRoute());
          } else {
            AppHelpers.goHome(context);
          }"""

new_block = """          if (data.data?.user?.role == 'seller') {
            AppHelpers.showCheckTopSnackBar(
              context,
              text: AppHelpers.getTranslation(TrKeys.youAreASeller),
              type: SnackBarType.success,
            );
          } else if (data.data?.user?.role == 'deliveryman') {
            AppHelpers.showCheckTopSnackBar(
              context,
              text: AppHelpers.getTranslation(TrKeys.youAreNotADeliveryman),
              type: SnackBarType.success,
            );
          }
          if (AppConstants.isDemo) {
            context.replaceRoute(UiTypeRoute());
          } else {
            AppHelpers.goHome(context);
          }"""

# We need to handle the multiple methods (login, loginWithGoogle, etc.)
# I will use a regex-like approach or just a simple replace for all occurrences.

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace all occurrences
updated_content = content.replace(old_block, new_block)

if updated_content != content:
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(updated_content)
    print("Successfully updated LoginNotifier with role-based toasts.")
else:
    print("Could not find the target code block in LoginNotifier.")
