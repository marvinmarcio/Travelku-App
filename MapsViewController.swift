//
//  MapsViewController.swift
//  Travel
//
//  Created by Marvin Marcio on 23/07/21.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class MapsViewController: UIViewController, SearchViewControllerDelegate {
   
    let mapView = MKMapView()
    let panel = FloatingPanelController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
title = "Uber"
        let searchVC = SearchViewController()
        searchVC.delegate = self
   
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        guard let coordinates = coordinates else
        {
            return
        }
        panel.move(to: .tip, animated: true)
        mapView.removeAnnotations(mapView.annotations)
    
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
}

