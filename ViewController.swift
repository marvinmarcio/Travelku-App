import UIKit
import MapKit

protocol HandleMapSearches {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController , CLLocationManagerDelegate, HandleMapSearches, HandleMapSearch{
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        myMapView.removeAnnotations(myMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        myMapView.addAnnotation(annotation)
  
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        myMapView.setRegion(region, animated: true)
    }
    
    @IBOutlet weak var myMapView: MKMapView!
    let locationManager = CLLocationManager ()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let locationSearchTables = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTables") as! LocationSearchTables
             resultSearchController = UISearchController(searchResultsController: locationSearchTables)
             resultSearchController?.searchResultsUpdater = locationSearchTables
             let searchBar = resultSearchController!.searchBar
             searchBar.sizeToFit()
             searchBar.placeholder = "Search for places"
             navigationItem.titleView = resultSearchController?.searchBar
             resultSearchController?.hidesNavigationBarDuringPresentation = false
             resultSearchController?.dimsBackgroundDuringPresentation = true
             definesPresentationContext = true
             locationSearchTables.mapView = myMapView
             locationSearchTables.handleMapSearchesDelegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    //User Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            manager.stopUpdatingLocation()
            let userCoordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: userCoordinates, span: span)
            myMapView.setRegion(region, animated: true)
            
            //User Location Pin
            let myPin = MKPointAnnotation()
            myPin.coordinate = userCoordinates
            myPin.title = "Pin"
            myPin.subtitle = "Subtitle"
            myMapView.addAnnotation(myPin)
        }
    }
    
    //Requesting Location Authorization
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedAlways:
//            return
//        case .authorizedWhenInUse:
//            return
//        case .denied:
//            return
//        case .restricted:
//            locationManager.requestWhenInUseAuthorization()
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        default:
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    //User Generated Pin
    @objc func addUserAnnotation(press:UILongPressGestureRecognizer){
        if press.state == .began {
            let location = press.location(in: self.myMapView)
            let coordinates = myMapView.convert(location, toCoordinateFrom: myMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            annotation.title = "LongPress Annotation"
            
            myMapView.addAnnotation(annotation)
            
            let uilpgr = UILongPressGestureRecognizer (target: self, action: #selector (addUserAnnotation(press:)))
            
            uilpgr.minimumPressDuration = 1
            myMapView.addGestureRecognizer(uilpgr)
            
            addUserAnnotation(press: uilpgr)
        }
    }
}
