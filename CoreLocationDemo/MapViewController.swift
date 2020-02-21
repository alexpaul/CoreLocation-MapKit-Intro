//
//  ViewController.swift
//  CoreLocationDemo
//
//  Created by Alex Paul on 2/21/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private let locationSession = CoreLocationSession()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // testing converting coordinate to placemark
    convertCoordinateToPlacemark()
    
    // testing converting place name to coordinate
    convertPlaceNameToCoordinate()
    
    // configure map view
    // attempt to show the user's current location
    mapView.showsUserLocation = true
    mapView.delegate = self
    
    loadMapView()
  }
  
  private func makeAnnotations() -> [MKPointAnnotation] {
    var annotations = [MKPointAnnotation]()
    for location in Location.getLocations() {
      let annotation = MKPointAnnotation()
      annotation.coordinate = location.coordinate
      annotation.title = location.title
      annotations.append(annotation)
    }
    return annotations
  }
  
  private func loadMapView() {
    let annotations = makeAnnotations()
    mapView.showAnnotations(annotations, animated: true)
  }
  
  
  private func convertCoordinateToPlacemark() {
    let location = Location.getLocations()[2]
    locationSession.convertCoordinateToPlacemark(coordinate: location.coordinate)
  }
  
  private func convertPlaceNameToCoordinate() {
    locationSession.convertPlaceNameToCoordinate(addressString: "pursuit, queens")
  }

}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("didSelect")
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else {
      return nil
    }
    let identifier = "locationAnnotation"
    var annotationView: MKPinAnnotationView
    
    // try to dequeue and reuse annotation view
    if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
      annotationView = dequeueView
    } else {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView.canShowCallout = true
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    print("calloutAccessoryControlTapped")
  }
}
