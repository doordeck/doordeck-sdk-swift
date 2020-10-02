# doordeck-sdk-swift

This readme will explain the necessary steps, to import Doordeck into your app.

A sample app has been provided to show how to integrate with Doordeck.


## Step 1 - import Dependencies 

Import [doordeck-sdk-swift](https://github.com/doordeck/doordeck-sdk-swift/tree/master/doordeck-sdk-swift) into your project. I would suggest adding this to a separate folder, within your project.


## Step 2 - install pods 

### Option 1 - Install Via Swift package manager 

To add dependencies via SPM, select `File` > `Swift Packages` > `Add Package Dependency`, enter the following repo's download latest and import all associated projects

Then, to use it in your source code, add:

```swift
https://github.com/yannickl/QRCodeReader.swift.git
https://github.com/ashleymills/Reachability.swift
https://github.com/Alamofire/Alamofire
https://github.com/hyperoslo/Cache
https://github.com/jedisct1/swift-sodium
```
### Option 2 - install pods 
Add the following pods to your project 
```
  pod "QRCodeReader.swift", "~> 10.0"
  pod "ReachabilitySwift", "~> 4.3"
  pod "Alamofire", "~> 4.8"
  pod "Cache", "~> 5.2"
  pod "Sodium", "~> 0.8"
 ```
Add the following pods to your project 

## Step 3 - add permissions
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

## Step 4 - NFC Tag Reading
In your target project go to Capabilities and enable "Near Field Communication Tag Reading", this will then enable the app for NFC.

## Step 5 - Doordeck delegate and Auth Token
Initialise doordeck, Doordeck expect the host app to pass an AuthToken that will be used to authenticate the user. 
Use AuthTokenClass when submitting an AuthToken to Doordeck.
You then need to set the delegate to a class.

### Please keep in mind the that you would need to provide your own token, to use the sample app, for security reasons this has not been committed into the repo.

```
        let token = AuthTokenClass(self.token)
        doordeck = Doordeck(token)
        doordeck?.delegate  = self
```

## Step 6 - Protocol confirmation 
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

## Step 7 - Initialise Doordeck 
We recommend that the host app first calls doordeck initialise, this will speed up the unlock process.
```
doordeck?.Initialize()
```

## Step 8 - Unlock
Unlock a door

```
        doordeck?.showUnlockScreen(success: {
            
        }, fail: {
            
        })
       }

```

Please keep in mind, Doordeck servers can reject a user and ask for permissions, if the Public key sent does not match the one on the server currently.

## Step 9 - Optional Events 
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

