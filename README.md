# UIKitMapsProject

In this project I work with Apple Maps, Google Maps and Yandex Maps. All three screens are made on one UITabBar, each one has its own ViewController. All the interface inside the viewcontroller is made programatically

By default, the app shows you the region of ShangHai (my favourite city), with 5 top attractions pinned to the map. You can tap on the pins to show information about attraction (except for Yandex ones).

Also you can tap on the circle button on the right down corner of the screen to center the map on your location (you need to give the app admission to do so beforehand)

You also have plus and minus buttons on the right down corner of the screen, which are zoom in and zoom out buttons

NOTE: In order for Google Maps and Yandex Maps to work, you should provide your own API keys, and type them in the AppDelegate ->  GMSServices.provideAPIKey(" Your API key") (Google) and YMKMapKit.setApiKey("Your API key") (Yandex)

NOTE: You need to install all the frameworks (google, yandex) beforehand in order for the app to work. You can do it in the termainal for the app's folder, whre you should type 'pod install' . You also should have cocoaPods installed
