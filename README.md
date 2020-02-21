# CoreLocation, MapKit Introduction

Introduction to CoreLocation and MapKit.

![corelocation app](Assets/corelocation-app.png)

## 1. Create a strong reference to a CLLocationManager

It's highly recommended that we keep a strong reference to a CLLocationManager in our app.

```swift 
/*
 https://developer.apple.com/documentation/corelocation/adding_location_services_to_your_app
 Create an instance of the CLLocationManager class and store a strong reference to it somewhere in your app.
 You must keep a strong reference to the location manager object until all tasks involving that object complete.
 Because most location manager tasks run asynchronously, storing your location manager in a local variable is insufficient.
*/

public var locationManager: CLLocationManager
```

## 2. Request location permissions 

Required keys to include in the info.plist are: 
1. NSLocationAlwaysAndWhenInUseUsageDescription
2. NSLocationWhenInUseUsageDescription

```swift 
private func requestLocationPersmissions() {
  /*
    This app has attempted to access privacy-sensitive data without a usage description.
    The app's Info.plist must contain both “NSLocationAlwaysAndWhenInUseUsageDescription”
    and “NSLocationWhenInUseUsageDescription” keys with string values explaining to the user how the app uses this data
  */
  //CLLocationManager().requestWhenInUseAuthorization()

  // need to have a strong reference to the location manager
  locationSession.locationManager.requestWhenInUseAuthorization()
}
```

## 3. Set a custom object as the CLLocationManager delegate 

```swift 
locationManager.delegate = self    
```

## 4. didChangeAuthorization method on the CLLocationManagerDelegate which listens for updates for changes to the location authorization status

```swift 
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
  print("didChangeAuthorization")
  switch status {
  case .authorizedAlways:
    print("authorizedAlways")
  case .authorizedWhenInUse:
    print("authorizedWhenInUse")
  case .denied:
    print("denied")
  case .notDetermined:
    print("notDetermined")
  case .restricted:
    print("restricted")
  default:
    break
  }
}
```

## 5. didUpdateLocations protocol method on CLLocationManageDelegate listens for user location changes

```swift 
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  print("didUpdateLocations: \(locations)")
}
```

## 6. Getting user location. 

#### Standard location service. Ideal for navigation apps.

To start the standard location service, configure your CLLocationManager object and call its startUpdatingLocation() method.

```swift 
locationManager.startUpdatingLocation()

/*
 When you no longer need location data, always call your location manager object's stopUpdatingLocation() method.
 If you do not stop location updates, the system continues delivering location data to your app, which could cause
 significant battery drain for the user's device.
*/
```

Saving power with desiredAccuracy 

```swift 
locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // power savings switch to wifi vs GPS when available
```

#### Significant-change location service. More power efficient and less updates.

```swift 
startSignificantLocationChanges()
```

```swift 
private func startSignificantLocationChanges() {
  if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
    print("The device does not support this service")
    return
  }
  locationSession.locationManager.startMonitoringSignificantLocationChanges()
}
```


## 7. Start monitoring a region

```swift 
private func startMonitoringRegion() {
  let location = Location.getLocations()[2] // central park
  let identifier = "monitoring region"
  let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
  region.notifyOnEntry = true
  region.notifyOnExit = false

  locationManager.startMonitoring(for: region)
}
```

## 8. Stop monitoring a region

```swift 
private func stopMonitoringRegion() {
  let location = Location.getLocations()[2] // central park
  let identifier = "monitoring region"
  let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
  region.notifyOnEntry = true
  region.notifyOnExit = false

  locationManager.stopMonitoring(for: region)
}
```
