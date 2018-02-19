//
//  ChooseLocationTableViewController.swift
//  dolochallenge
//
//  Created by Casey Wilcox on 2/16/18.
//  Copyright © 2018 Casey Wilcox. All rights reserved.
//

import UIKit
import CoreLocation

class ChooseLocationTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locations = [JSON]()
    var filteredLocations = [JSON]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.cornerRadius = 50
        searchBar.delegate = self
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            currentLocation = locationManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        performSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count: Int
        
        if filteredLocations.count > 0 {
            count = filteredLocations.count
        } else {
            count = locations.count
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set up the SearchCells with data from the searchResults array
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationTableViewCell
        
        if filteredLocations.count > 0 {
            cell.locationLabel.text = filteredLocations[(indexPath as NSIndexPath).row]["name"].string
            cell.addressLabel.text = filteredLocations[(indexPath as NSIndexPath).row]["location"]["address"].string
            cell.distanceLabel.text = "\(round(filteredLocations[(indexPath as NSIndexPath).row]["location"]["distance"].doubleValue / 3.28084))ft"
        } else {
            cell.locationLabel.text = locations[(indexPath as NSIndexPath).row]["name"].string
            cell.addressLabel.text = locations[(indexPath as NSIndexPath).row]["location"]["address"].string
            cell.distanceLabel.text = "\(round(locations[(indexPath as NSIndexPath).row]["location"]["distance"].doubleValue / 3.28084))ft"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectedLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedLocation" {
            if filteredLocations.isEmpty {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let selected = locations[indexPath.row]["name"].string!
                    let newPostVC = segue.destination as! NewPostViewController
                    print("locations", selected)
                    newPostVC.updatedLocation = selected
                }
                
            } else {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let selected = filteredLocations[indexPath.row]["name"].string!
                    let newPostVC = segue.destination as! NewPostViewController
                    print("locations", selected)
                    newPostVC.updatedLocation = selected
                }
            }
        }
    }

    func performSearch() {
        var lat = currentLocation.coordinate.latitude
        var lon = currentLocation.coordinate.longitude
        
        let url = "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(lon)&intent=checkin&radius=500&limit=20&oauth_token=HBLNLMNHPS5WSGURD4PB3UFGQXBKSPJVWG4UMDSQKTCCFV0E&v=20180219"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let json = JSON(data: data!)
            self.locations = json["response"]["venues"].arrayValue
            
            // set label name and visible
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLocations = locations.filter {
            return (($0["name"].stringValue).lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "selectedLocation", sender: self)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
