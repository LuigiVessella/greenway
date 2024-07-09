# GreenWay

GreenWay is a multi-platform app (iOS and Android) that includes a routing and navigation system with maps based on OSMR and designed to make the journey of an electric vehicle as efficient as possible. 

App distribution is now limited as a Docker image.

## Installation
> :warning: This set up is only for development/prototyping <u>DO NOT</u> use it in production :warning:
Clone the repository and open project with Visual Studio Code.

First please be sure of installing:

1)[Visual Studio Code](https://code.visualstudio.com/download) editor

2)[Flutter](https://docs.flutter.dev/get-started/install) framework

3)Android Studio Tools and XCode(if you develop on MacOS)


## Usage
After cloning repository, you are one step away from start and test the project. By default, the project is ready-to-start, but if some errors occurs, try:

```dart
flutter doctor
flutter clean
flutter pub get
```
After that, you're 90% ready to start the app. The last step you need to do is creating a 
```.env ``` file and put inside it your endpoint (keycloak and rest service) configuration. 
Here is an example: 
```
web_address={backend_address}
```
Rename the file ```auth_client.env``` and put it inside ```lib\config\auth\auth_client.env```

Good! Now you're ready to debug the application, just connect your mobile device and enjoy it! 

> :warning: This app is fully tested only on an Android (A13+) device! I can't say for now if it's 100% working on iOS :warning:

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.
