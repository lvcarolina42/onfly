# Onfly

## Project description

This is a corporate expense management app.

**Features:**

* Add new expenses to local storage and the API.
* Delete expenses from local storage and the API.
* List saved expenses from local storage and the API.
* Edit existing expenses in local storage and the API.
* Get the current location to save in expenses.

## Installation instructions

* Make sure you have Flutter 3.10.6 or higher installed.
* Make sure you have Dart 3.0.6 or higher installed.

## Run instructions

* To run the app on an emulator, use the command `flutter run`.
* To run the app on a physical device, connect the device to your computer and use the command `flutter run`.

## Running tests

* To run all tests, simply right-click on the `test` folder and select `Run tests in test`.

## Approaches, technologies, and packages used

### App flow

When entering the app, if there is an internet connection, a request is made to get the saved expenses from the API. If there is no connection, the expenses are searched in the local storage. If there are no expenses, a message is displayed indicating that the list is empty. In case of any error, an error message is displayed.

In each expense card, it is possible to see the description, date, price, whether it is not saved in the API, and it is still possible to delete or edit an expense (in case of editing, a dialog is opened for this).

Still on the home page, we can see a field with the total sum of expenses, and a floating button with the function of navigating to the new expense screen. In this screen, we have fields to add description, date, price, latitude, and longitude (the current location already comes as default, but it is possible to edit).

After inserting the information and saving, it navigates to the main screen already updated. The update of the main screen happens when adding, editing, and deleting an expense, and also when the cell goes from the status of no connection to connection.

* To get the current location, the [geolocator](https://pub.dev/packages/geolocator) library was used, being called whenever the user clicks to add a new expense.
* To check the connection, the [connectivity_plus](https://pub.dev/packages/connectivity_plus) library was used. In this case, the information is used in a stream, so that whenever there are changes in the connection, something is done. (If I don't have internet, I save all the expenses in local storage and as soon as the connection comes back, I send all the saved expenses to the API).
* To save, edit, and delete expenses in local storage, the [shared_preferences](https://pub.dev/packages/shared_preferences) library was used.

Otherwise, I tried my best to separate the logical part from the presentation part in the app, I created use cases for any functionality that came from the repository.

I didn't focus too much on error handling, but I treated the state of the main page in a more general way.

About tests, I only did the widget test for home_page. Unfortunately I didn't have time to have a greater coverage and variety.

**Notes:**

* The app layout has been tested on the Pixel 3a emulator. I recommend using the same or a similar emulator.
