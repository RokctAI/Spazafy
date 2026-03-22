import os

fixes = [
    {
        'file': 'lib/domain/interface/driver_settings.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models_driver.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models_driver.dart' hide LanguagesResponse;"
    },
    {
        'file': 'lib/infrastructure/services/utils/manager/app_helpers.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide Extras;"
    },
    {
        'file': 'lib/application/order_details/manager/order_details_notifier.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide OrderData;"
    },
    {
        'file': 'lib/application/foods/manager/edit/stocks/edit_food_stocks_state.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide Group, Extras;"
    },
    {
        'file': 'lib/application/foods/manager/edit/stocks/edit_food_stocks_notifier.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide Group;"
    },
    {
        'file': 'lib/application/foods/manager/create/stocks/create_food_stocks_state.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide Group, Extras;"
    },
    {
        'file': 'lib/application/foods/manager/create/stocks/create_food_stocks_notifier.dart',
        'target': "import 'package:rokctapp/infrastructure/models/models.dart';",
        'replace': "import 'package:rokctapp/infrastructure/models/models.dart' hide Group;"
    },
    {
        'file': 'lib/presentation/pages/become/become_driver.dart',
        'target': "import 'package:rokctapp/infrastructure/services/utils/driver/app_helpers.dart';",
        'replace': "import 'package:rokctapp/infrastructure/services/utils/driver/app_helpers.dart' hide AppHelpers;"
    },
    {
        'file': 'lib/presentation/pages/become/become_driver.dart',
        'target': "disabledBorder: const UnderlineInputBorder(",
        'replace': "disabledBorder: UnderlineInputBorder("
    }
]

for fix in fixes:
    fp = fix['file']
    if os.path.exists(fp):
        with open(fp, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # for multiple replacements
        if fix['target'] in content:
            content = content.replace(fix['target'], fix['replace'])
            with open(fp, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed {fp}")
        elif fix['target'].replace("const ", "") in content:
            # just in case
            pass
        else:
            print(f"Target not found in {fp}")
    else:
        print(f"File not found: {fp}")

