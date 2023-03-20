# konigle_mobile_app

A flutter mobile app to keep track of your progress in various chapters of the Konigle Program.
Visit the:
- [Konigle Website for More Info](https://konigle.com/about)

## Getting Started

To reproduce or start working on this project you first need a working IDE with the latest 
flutter SDK and Dart SDK installed.

Fork the main branch, and pull into your local repo.
 
Run the following commands to check for compatibility
    1. flutter doctor
    2. flutter pub get

This should check for any possible updates or requirements not met by the system and also
get all the dependencies of the current project into you local branch.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Working Screenshots
![Splash Page](https://github.com/Shivlock221b/konigle_mobile_app/blob/master/screenshots/splash.png = 250x)

## API and dependency documentation

The app doesn't make use of any serverside or third party api since this is just a frontend App. 
The server integration for this app is not yet implemented.

# Dependencies
- Flutter sdk - Needed for every flutter project
- Dart sdk - language sdk used for programming
- shared_preferences - native device storage protocol dependency
- photo_view - flexible photo viewing experience dependency
- provider - state manager for local storage classes

## Control Flow & basic implementaion details
The control of the app is pretty basic
- Starts at the splash page. 
- From where it either goes into the login page, if the user is not logged in.
- At the login page the user also has the option to signup. 
- Signup requires three inputs Username, password and email(necessary for future forgot password implementation).
- Or it moves to the Home page, if the user is logged in.
- At the homepage the Progress bar indicates the progress of the users across all chapters
- Individual sections in the chapters are marked green and completed on completion.
- The progress of the user is stored in the form of the number of chapters and sections completed within the user model class.
- The user is kept logged in using shared_preferences.
- Also the last page checked out is also stored in shared_preferences to navigate directly to that page on reboot.
- There is a logout button which logs the user out of the app

# Alternative implementation
Many instances in the implementation could be done differently
- Instead of maintaining the provider class, the User object could be passed around too.
- Use of sqflite to store user data on native device to reduce overhead
- Progress bar for each chapter could also be implemented

## Backend Database classes

There are two database classes used in the project
- User class - Model class that defines the user/member of the app with its possible attributes
- Database class - Storage class that defines the local apis and protocols to perform CRUD operations for User info


## Trouble shooting

While booting up you may encounter some common errors
For reference
- Invalid SDK - Check if you are using the latest version of Dart and Flutter SDKs
- Plugin Missing - Download the dart and flutter plugin available for your ide
- Android version error - Check if you android version matches your android SDK
- IOS device error - setup xcode command line tools before booting


## Acknowledgements & Copyrights

Some code in this can be attributed to stack overflow answers to certain errors.
But apart from that not code has been used from other sources

Copyright: The icon used in the app belongs to Konigle Online Ecommerce facilitator company.

## Want to contribute

- Create a pull request and start working ASAP.

