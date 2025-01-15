# pankaj_weather_app

## Flutter Installation Guide

This guide offers a comprehensive, step-by-step tutorial on how to install Flutter on Apple Mac.

### Installation Steps

Follow these steps to install Flutter on your system:

* If you have Mac silicon(M1 or M2) then install Rosetta by using this command:

> sudo softwareupdate --install-rosetta --agree-to-license

* To begin, please visit the official Flutter website at https://flutter.dev. Once you are there, navigate to the SDK archive section. From there, locate and download the Flutter SDK version 3.3.2. After the download is complete, extract the contents of the zip file. Next, create a "Developer" folder on your system. Once the folder is created, move the extracted Flutter folder into the newly created "Developer" folder.

* To proceed, navigate to the Flutter folder that you extracted earlier. Once inside the Flutter folder, locate the "bin" folder. Copy the path of the "bin" folder. Next, open either the .zprofile or .zshrc file (depending on your preference) using a text editor. Then, add the following line to the file, pasting the previously copied path:

> export PATH="$PATH:/Users/username/Developer/flutter/bin"

* After completing the previous steps, you can proceed with installing Google Chrome and Visual Studio Code.

* Afterwards, you will need to install Xcode. To install Xcode, follow the official Apple documentation. Once Xcode is installed, you can run the following two commands in your terminal:

> sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

> sudo xcodebuild -runFirstLaunch

* To install CocoaPods, you can use the following command:

> sudo gem install cocoapods

* Install android studio and then install JDK. To install JDK 8, you can use the following command:

> brew install openjdk@8

and setup the java path.

* Open a new terminal window and run the following command to verify that Flutter is installed correctly and to check for any additional dependencies that may be required:

> flutter doctor

Congratulations! You have successfully installed Flutter on your system.

* Now you need to clone the project from using this url: https://github.com/pankaj104/pankaj_weather_app.git. To clone this project, follow these steps:

1. Open your terminal or command prompt.

2. Navigate to the directory where you want to clone the project using the cd command.

> git clone <repository_url>

* Then you need to open the project in any IDE (VS code or Android Studio).

* To run Flutter code, use the following command:

> flutter run

This command is used to execute and launch the Flutter application. Make sure you are in the root directory of your Flutter project in the terminal or command prompt before running this command.



https://github.com/user-attachments/assets/65a7897f-ef00-4827-b3f5-b70531512be7



w
