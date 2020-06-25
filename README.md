#  Sona - The Social Music App

Welcome to the documentation for Sona! This documentation will show you how to set up the repo for yourself, the methodology behind the code, and some of my hopes for the app's future.

## Setting up the project locally

1. First, clone the repo using `git clone https://github.com/Hoid/Sona.git`
2. Open the workspace (`.xcworkspace` file) in XCode, *not* the project file (`.xcodeproj`). This is because CocoaPods doesn't work when you just open the project file.
3. Navigate to the root Sona directory for the repo, ensure you have CocoaPods installed, and run `pod install`
4. Assuming all goes well, you should be able to build the project in XCode now. If you have problems building, you can open up an issue ticket on Github and I'll look into helping you get set up.
5. Message me directly for the AppleMusicAuthKey.p8 file :)
6. You can run the project in the simulator, but you'll get errors when doing certain things because you can't make calls to the device's Apple Music Library from the simulator (there's no library to query from). As a result you have to run Sona on a physical device to test all of the features. 

## Methodology

### App Flow

Sona currently starts with a signup flow that's veeery rudimentary and bare-minimum. It uses Firebase to authenticate users and return a firebaseUID, which we store on the local database and the server as the user's primary ID. 

Once the user is authenticated, if they are new, we show them a Choose Username screen that will only allow the user to choose a username if the username is not present in the local database or the server. The server database check happens on click of submit currently. We will soon move that into the "Check" button click instead. If the user is able to successfully create their user with their chosen username in the local database and on the server,  we create them a `Profile` that corresponds to their `User` object. This `Profile` object will house things like the user's profile photo, settings, and other metainformation about the user.

Once the `User` and `Profile` have been created, the user is taken to the Home Screen. From there the user can go public or go private using the Public switch at the top, go to their Profile at the top left, or can search for broadcasts to join. 

### Local Database

Sona uses [GRDB](https://github.com/groue/GRDB.swift/blob/master/README.md) as its local database framework. GRDB is a wrapper for SQLite, works really well with multithreaded applications, and is easy to understand. It's documentation is also fairly good.

Currently, the structure of database access is a `DAO` protocol, which only forces adopters to implement a `setupTable()` method; a `BaseDAO` class, which houses the global static var `dbQueue` which is the main entrypoint for database operations, sets up the database, and calls `setupTable()` on all the DAOs you define;  and individual DAOs, e.g. `UserDAO`, which defines all of the operations you can take on the `user` table in the database. Individual DAOs should adopt both the `DAO` protocol and the `BaseDAO` class. I don't love that these are different currently, but I'm not sure of a better way to do it in swift, honestly. I think it's best to force DAOs to implement the `setupTable()` method, but I also wish we could automagically call `setupTable()` in the `BaseDAO.setup()` method on all of its subclasses. We could also potentially genericize the `createUserTable()` method and all other methods in invidividual DAOs to be just `createTable()` and genericize the `setupTable()` method in the protocol or `BaseDAO` class.

The only methods in individual DAOs that do not throw Errors are the `create*Table()` method and the `exists()` method in each DAO, because if the database table creation fails we always want to immediately quit the app, and the `exists()` method doesn't require throwing. All other methods will throw errors back to the caller so that they can be dealt with appropriately at that level. Sometimes we catch errors inside the DAO methods and then throw a more useful Error, such as `UserError.cannotFetch` instead of just a `DatabaseError`.

Individual DTOs that define what the database object looks like are subclasses of the GRDB `Record` class. For example, `User` defines all of the necessary methods for database access and insertion to work. See the GRDB documentation at the link above for more information.


