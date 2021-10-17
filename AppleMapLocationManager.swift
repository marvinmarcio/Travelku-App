import UIKit
import CoreLocation
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class AppleMapLocationManager: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchInputField: UITextField!
    @IBOutlet weak var appleMapView: MKMapView!
    //    var weatherManager = WeatherManager()
    var locationManager=CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.searchInputField.delegate=self
//        weatherManager.delegate=self
        locationManager.delegate = self
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.requestWhenInUseAuthorization()
             locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
             resultSearchController = UISearchController(searchResultsController: locationSearchTable)
             resultSearchController?.searchResultsUpdater = locationSearchTable
             let searchBar = resultSearchController!.searchBar
             searchBar.sizeToFit()
             searchBar.placeholder = "Search for places"
             navigationItem.titleView = resultSearchController?.searchBar
             resultSearchController?.hidesNavigationBarDuringPresentation = false
             resultSearchController?.dimsBackgroundDuringPresentation = true
             definesPresentationContext = true
             locationSearchTable.mapView = appleMapView
             locationSearchTable.handleMapSearchDelegate = self
        // Do any additional setup after loading the view.
    }
    func animateToUserLocation() {
        if let annotation = appleMapView.annotations.filter ({ $0 is MKUserLocation }).first {
            let coordinate = annotation.coordinate
            let annotation = MKPointAnnotation()
            annotation.title = "Your text here"
            //You can also add a subtitle that displays under the annotation such as
            annotation.subtitle = "One day I'll go here..."
       
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            appleMapView.setRegion(viewRegion, animated: true)
        }
    }
    
   @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
 
}
extension AppleMapLocationManager : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
        if let location = locations.first {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta:
            0.05)
              let region = MKCoordinateRegion(center: location.coordinate, span: span)
              appleMapView.setRegion(region, animated: true)
          }
    }
    

}

extension AppleMapLocationManager: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        appleMapView.removeAnnotations(appleMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        appleMapView.addAnnotation(annotation)
  
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        appleMapView.setRegion(region, animated: true)
    }
}

extension AppleMapLocationManager : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}


