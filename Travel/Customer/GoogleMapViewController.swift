//
//  GoogleMapViewController.swift
//  Travel
//
//  Created by Marvin Marcio on 26/06/21.
//

import UIKit
import GoogleMaps
import MapKit

class GoogleMapViewController: UIViewController, UISearchResultsUpdating, ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        let annotations = mapViews.annotations
        mapViews.removeAnnotations(annotations)
        
        let pin = MKPointAnnotation()
               pin.coordinate = coordinates
               mapViews.addAnnotation(pin)
               mapViews.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
    
   
    
    

    @IBOutlet weak var mapView: GMSMapView!
    let mapViews = MKMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapViews)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
//        let sourceLocation = "\(28.704060), \(77.102493)"
//        let destinationLocation = "\(28.459497), \(77.026634)"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyC9vEIALEe-f97gVyX-LTDS7Io8SFcV1Rg"
//
//
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds


        mapViews.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultsViewController
        else
        {
            return
        }
        resultsVC.delegate = self
        GooglePlacesManager.shared.findPlaces(query: query) {result in
            switch result
            {
            case .success(let places):
          
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                print(places)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

//extension ViewController: ResultsViewControllerDelegate
//{
//    func didTapPlace(with coordinates: CLLocationCoordinate2D)
//    {
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinates
//        mapViews.addAnnotation(pin)
//        mapViews.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
//    }
//}

