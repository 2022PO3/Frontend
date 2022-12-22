# Depreciation notice
As of the 22nd of December 2022, this project is no longer actively maintained.

## Frontend

This is our P&O3 client-side application written in Dart, with the Flutter framework.

To start developing this application, you have to install [Android Studio](https://developer.android.com/studio), [Dart](https://dart.dev/get-dart) and the [Flutter SDK](https://docs.flutter.dev/get-started/install).

The preferred IDE is Android Studio for all major platforms, download it first before you install Dart and Flutter.

- **Windows**

  To install Dart, you need to use a terminal with administrator rights (right click on the terminal icon and click `Run as administrator`). Once the terminal is open, execute the following commands:

  ```bash
  choco install dart-sdk
  ```

  Then go to [this page](https://docs.flutter.dev/get-started/install/windows) and install the ZIP-package.

- **macOS**

  To install dart, open a command terminal and type the following commands:

  ```bash
  brew tap dart-lang/dart
  brew install dart
  ```

  Then you have to install the Flutter SDK. Go to [this page](https://docs.flutter.dev/get-started/install/macos) and download the correct ZIP-file, depending on your CPU architecture. Make a new folder where you want to store the SDK (e.g. `/flutter`) and extract the ZIP-package there. Finally, update your PATH:

  ```bash
  export PATH="$PATH:`pwd`/flutter/bin"
  ```

  Run `flutter doctor` in the command line to check if everything is set up correctly and follow the advice given there.

- **Linux (Ubuntu)**

  Run the following commands:

  ```bash
  sudo apt-get update
  sudo apt-get install apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
   echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  ```

  Then install the Dart SDK;

  ```bash
  sudo apt-get update
  sudo apt-get install dart
  ```

  Finally add the SDK to you path:

  ```bash
  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
  ```

  Install the Flutter SDK with the following command:

  ```bash
  sudo snap install flutter --classic
  ```

You can either run the application via the command line with

```bash
flutter run
```

from the root of this directory or by clicking `Run` in Android Studio.

## Resources:

- https://dart.dev/get-dart
- https://docs.flutter.dev/get-started/install
- https://developer.android.com/studio
