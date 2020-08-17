//
//  ViewController.swift
//  Ibeacon
//
//  Created by Eddie Ruiz on 8/13/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import UIKit
import CoreLocation
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    
    
    override func loadView() {
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          view = webView
      }
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        // Do any additional setup after loading the view.
        
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(iBeaconFoundReceivedNotification), name: Notification.Name("iBeaconFoundReceivedNotification"), object: nil)
        
        

    
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
            
            let urlString = "https://ai-nomads.com/"
            
            let url = URL(string: urlString)
            
            
            
            let requestObject = URLRequest(url: url!)
            
            print("skdjhfkjdshfkjsdhfhdsjkfds-----ksdhfkjsdhfksdf------ \(requestObject)")
            
            webView.load(requestObject)
            
            
            
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

