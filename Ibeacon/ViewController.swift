//
//  ViewController.swift
//  Ibeacon
//
//  Created by Eddie Ruiz on 8/13/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(iBeaconFoundReceivedNotification), name: Notification.Name("iBeaconFoundReceivedNotification"), object: nil)
        
        
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("iBeaconFoundReceivedNotification")), name: NSNotification.Name(rawValue: "iBeaconFoundReceivedNotification"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: "ibeaconFound:", name: NSNotification.Name(rawValue: "ibeaconFound"), object: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   @objc func iBeaconFoundReceivedNotification(notification : NSNotification){
        
        // MARK : TAKE ACTION FROM THE NOTIFICATION
    
        
    
        
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            
            let major = userInfo["major"]!
            let minor = userInfo["minor"]!
            
            let messageInfo = "Major ------ \(String(describing: major)) ------ Minor \(String(describing: minor))"
            
            let alert = UIAlertController(title: "Ibeacon Found Bruh", message: messageInfo, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertAction.Style.default, handler: nil))
            
            
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

