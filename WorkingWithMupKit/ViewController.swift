//
//  ViewController.swift
//  WorkingWithMupKit
//
//  Created by Mac on 22.01.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var dataArray: [String] = ["Independence Square","Kreschatyk Street","National Opera of Ukraine"]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    struct Places {
        var id: Double
        var name: String
        var lattitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
    }
    
    func getPlaceLocation() -> [Places] {
        return [
        Places(id: 1, name:"Independence Square", lattitude: 50.450555, longtitude: 30.5210808),
        Places(id: 2, name:"Khreschatyk Street", lattitude: 50.4475888, longtitude: 30.5198317),
        Places(id: 3, name: "National Opera of Ukraine", lattitude: 50.44671, longtitude: 30.5101755)
        ]
    }
    
    func setAnnotation(places:[Places]) {
        
        for place in places {
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.lattitude, longitude: place.longtitude)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let radius: CLLocationDistance = 1500
    
    let startingLocation = CLLocation(latitude:50.4536, longitude:30.5164)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        func setStartingPosition(){
            let position = MKCoordinateRegion(center: startingLocation.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
            
            mapView.setRegion(position, animated: true)
        }
        setStartingPosition()
        let places = getPlaceLocation()
        setAnnotation(places: places)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLocationServiceEnabled()
    }
    
    
    func isLocationServiceEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            checkAuthorizationStatus()
        }
        else{
            displayAlert(isServiceEnabled: true)
        }
    }
    
    func checkAuthorizationStatus(){
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else if status == .restricted || status == .denied {
            displayAlert(isServiceEnabled: false)
        }
        else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        }
        
    }
    
    func displayAlert(isServiceEnabled:Bool){
        let serviceEnableMessage = "Location services must to be enabled to use this awesome app feature. You can enable location services in your settings."
        let authorizationStatusMessage = "This awesome app needs authorization to do some cool stuff with the map"
        let message = isServiceEnabled ? serviceEnableMessage : authorizationStatusMessage
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "OK", style: .default)
        
        
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)

        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
}
