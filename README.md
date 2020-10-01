# doordeck-sdk-swift

This readme will explain the necessary steps, to import Doordeck into your app.

A sample app has been provided to show how to integrate with Doordeck.


## Step 1 - import Dependencies 

To add doordeck_sdk_swift as dependency to your Xcode project, select `File` > `Swift Packages` > `Add Package Dependency`, enter its repository URL: `https://github.com/doordeck/doordeck-sdk-swift` and import `doordeck_sdk_swift`

Then, to use it in your source code, add:

```swift
import doordeck_sdk_swift
```

## Step 2 - add permissions
Add the following to your project plist.

```
 “Privacy - Camera Usage Description” -> “NSCameraUsageDescription”
 “Privacy - NFC Scan Usage Description” -> “NFCReaderUsageDescription”
 “Privacy - Location When In Use Usage Description” -> “NSLocationAlwaysAndWhenInUseUsageDescription”
```

### Optional - this is helpful if you are using Doordeck in a today widget.
```
 “Privacy - Location Always Usage Description” -> “NSLocationAlwaysUsageDescription"
```

The Camera permission is needed for the QR code reader, the NFC is needed for the NFC reader. The GPS permissions are used for GPS geofenced locks. 
Please make sure adequate descriptions are added to the keys, as they will be seen by the end user 

## Step 3 - NFC Tag Reading
In your target project go to Capabilities and enable "Near Field Communication Tag Reading", this will then enable the app for NFC.

## Step 4 - Doordeck delegate and Auth Token
Initialise doordeck, Doordeck expect the host app to pass an AuthToken that will be used to authenticate the user. 
Use AuthTokenClass when submitting an AuthToken to Doordeck.
You then need to set the delegate to a class.

### Please keep in mind the that you would need to provide your own token, to use the sample app, for security reasons this has not been committed into the repo.

```
        let token = AuthTokenClass(self.token)
        doordeck = Doordeck(token)
        doordeck?.delegate  = self
```

## Step 5 - Protocol confirmation 
Conform to DoordeckProtocal, These methods can be used to keep the app up to date.

```
extension ViewController: DoordeckProtocol {
    func verificationNeeded() {
        print("verificationNeeded")
    }
    
    func newAuthTokenRequired() -> AuthTokenClass {
        print("newAuthTokenRequired")
        return AuthTokenClass(self.token)
    }
    
    func unlockSuccessful() {
        print("unlockSuccessful")
    }
}
```

## Step 6 - Initialise Doordeck 
We recommend that the host app first calls doordeck initialise, this will speed up the unlock process.
```
doordeck?.Initialize()
```

## Step 7 - Unlock
Unlock a door

```
        doordeck?.showUnlockScreen(success: {
            
        }, fail: {
            
        })
       }

```

Please keep in mind, Doordeck servers can reject a user and ask for permissions, if the Public key sent does not match the one on the server currently.

## Step 8 - Optional Events 
This is an optional step, suscribing to events will allow you to get an Enum of the events that the SDK is going through. 
This is helpful for both debugging problems and events collection.

place the following in viewDidAppear
```
NotificationCenter.default.addObserver(self, selector: #selector(self.doordeckEvents(_:)), name: SDKEvent().doordeckEventsName, object: nil)
```

This is the Method for the events
```
    @objc func doordeckEvents (_ event: NSNotification) {
        guard let eventAction = event.object as? SDKEvent.EventAction else {
            return
        }
        print(eventAction)
    }
```
Place this is in the viewDidDisappear
```
NotificationCenter.default.removeObserver(self, name: SDKEvent().doordeckEventsName, object: nil)
```

