//
//  AppDelegate.swift
//  Ibeacon
//
//  Created by Eddie Ruiz on 8/13/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import EstimoteProximitySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var locationManager : CLLocationManager?
    
    var lastProximity : CLProximity?
    
    var proximityObserver: ProximityObserver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let uuidString:String = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        let beaconRegionIdentifier = "ainomads.Ibeacon"
        
        let beaconUUID: NSUUID = NSUUID(uuidString: uuidString)!
        
        let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID as UUID, identifier: beaconRegionIdentifier)
        
        print(beaconRegion)
        
        let notificationCenter = UNUserNotificationCenter.current()
               notificationCenter.delegate = self
               notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                   print("notifications permission granted = \(granted), error = \(error?.localizedDescription ?? "(none)")")
               }
        
        
        
        let estimoteCloudCredentials = CloudCredentials(appID: "ibeacontest-0ro", appToken: "9bc7cae35b2b6c9b48939a4efa866466")

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error)")
        })

        let zone = ProximityZone(tag: "ibeacontest-0ro", range: ProximityRange.near)
        zone.onEnter = { context in
            let content = UNMutableNotificationContent()
            content.title = "You have just entered Juans Mancave"
            content.body = "Grab a beer"
        
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "enter", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }
        zone.onExit = { context in
            let content = UNMutableNotificationContent()
            content.title = "Bye"
            content.body = "Hope to see you soon"
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "exit", content: content, trigger: nil)
            notificationCenter.add(request, withCompletionHandler: nil)
        }

        proximityObserver.startObserving([zone])
        
        
        locationManager = CLLocationManager()
        
     
        locationManager!.requestAlwaysAuthorization()


        locationManager!.delegate = self
        
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoring(for: beaconRegion)
        
        // MARK: START MONITORING INCASE WE HAVE A BEACON IN OUR REGION
        
        locationManager!.startRangingBeacons(in: beaconRegion)
        locationManager!.startUpdatingLocation()
        
        
        // MARK : SET UP NOTIFICATIONS
        
        

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        print("YOU ENTERED THE REGION")
        

     
        
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        print("YOU EXITED THE REGION")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        print("------ I FOUND SOME BEACONS BITCH -----");
        
        print("DID RANGE BEACONS: NUMBER OF BEACONS FOUND = \(beacons.count)")
        
        for aBeacon in beacons {
        
            switch aBeacon.proximity{
            case CLProximity.unknown:
                print("wtf man this shit unknown.....MAJOR: \(aBeacon.major)---- MINOR: \(aBeacon.minor) accuracy: \(aBeacon.accuracy) RSSI: \(aBeacon.rssi)")
                break
            case CLProximity.far:
                
                print("wtf man this shit far.....MAJOR: \(aBeacon.major)---- MINOR: \(aBeacon.minor) accuracy: \(aBeacon.accuracy) RSSI: \(aBeacon.rssi)")
                break
                
            case CLProximity.near:
                 print("wtf man this shit near.....MAJOR: \(aBeacon.major)---- MINOR: \(aBeacon.minor) accuracy: \(aBeacon.accuracy) RSSI: \(aBeacon.rssi)")
                break
                
            case CLProximity.immediate:
                 print("wtf man this shit is shit.....MAJOR: \(aBeacon.major)---- MINOR: \(aBeacon.minor) accuracy: \(aBeacon.accuracy) RSSI: \(aBeacon.rssi)")
                break
                
            @unknown default:
                print("YU DONE FCKED UP")
            }
        }
        
        
        
        // MARK : LETS GET THE FIRST BEACON ON THE LIST
        
        let currentBeacon = beacons.first!
        
        // MARK : IF THE PROXIMITY IS THE SAME BEFORE, DO NOTHING
        
        if lastProximity != nil && currentBeacon.proximity == lastProximity{
            return
        }
        
        // MARK : SET THE PROXIMITY
        
        lastProximity = currentBeacon.proximity
        
        // MARK : IF WE ARE IMMEDIATE, SEND NOTIFICATION TO ANYONE INTERESTED
        
        if currentBeacon.proximity == CLProximity.immediate{
            
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("iBeaconFoundReceivedNotification"), object: nil,userInfo:["major": currentBeacon.major , "minor" : currentBeacon.minor])
            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "iBeaconFoundReceivedNotification") , object: nil, userInfo:["major": currentBeacon.major , "minor" : currentBeacon.minor])
//
      
            
        }
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Needs to be implemented to receive notifications both in foreground and background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }
}
