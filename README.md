
This readme will explain the necessary steps, to import Doordeck into your app.
*due to a bug in Xcode 10, I cannot create a pod at the minute, this will be coming soon. 

A sample app has been provided to show how to integrate with Doordeck.



## Step 1
Import doordeck-sdk-swift into your project. I would suggest adding it in a separate folder.

## Step 2
Add the following pods to your project 
```
  pod "QRCodeReader.swift", "~> 10.0"
  pod "ReachabilitySwift", "~> 4.3"
  pod "Alamofire", "~> 4.8"
  pod "SwiftyRSA", "~> 1.5"
  pod "Cache", "~> 5.2"
  pod "Sodium", :git => "https://github.com/Westacular/swift-sodium.git", :branch => “fix_xcode10.2"
 ```

Sodium does not currently work with Xcode 10, please use this fix, until Sodium is updated.

## Step 3
Add the following to your project plist.

```
 “Privacy - Camera Usage Description” -> “NSCameraUsageDescription”
 “Privacy - NFC Scan Usage Description” -> “NFCReaderUsageDescription”
 “Privacy - Location Always Usage Description” -> “NSLocationAlwaysUsageDescription"
 “Privacy - Location When In Use Usage Description” -> “NSLocationAlwaysAndWhenInUseUsageDescription”
```

The Camera permission is needed for the QR code reader, the NFC is needed for the NFC reader. The GPS permissions are used for GPS geofenced locks. 
Please make sure adequate descriptions are added to the keys, as they will be seen by the end user 

## Step 4
Initialise doordeck, Doordeck expect the host app to pass an AuthToken that will be used to authenticate the user. 
Use AuthTokenClass when submitting an AuthToken to Doordeck.
You then need to set the delegate to a class.
```
        let token = AuthTokenClass(self.token)
        doordeck = Doordeck(token)
        doordeck?.delegate  = self
```

## Step 5
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

## Step 6
We recommend that the host app first calls doordeck initialise, this will speed up the unlock process.
```
doordeck?.Initialize()
```

## Step 7
Unlock a door

```
        doordeck?.showUnlockScreen(success: {
            
        }, fail: {
            
        })
       }

```

Please keep in mind, Doordeck servers can reject a user and ask for permissions, if the Public key sent does not match the one on the server currently.

