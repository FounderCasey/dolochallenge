//
//  HomeViewController.swift
//  dolochallenge
//
//  Created by Casey Wilcox on 2/15/18.
//  Copyright © 2018 Casey Wilcox. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var showCheckmark = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newPostButton.layer.borderColor = UIColor.white.cgColor
        newPostButton.layer.borderWidth = 1
        newPostButton.layer.cornerRadius = 25
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            newPostButton.isEnabled = true
        }
        
        if showCheckmark == true {
            imageView.image = #imageLiteral(resourceName: "checkmark")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Oops, we need your location.", message: "Please allow your location from the settings.", preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Dolo Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }))
    }

}

