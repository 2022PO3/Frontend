flutter build appbundle --obfuscate --split-debug-info --build-name=$1 --build-number=1
flutter build apk --obfuscate --split-debug-info --build-name=$1 --build-number=1 --split-per-abi
