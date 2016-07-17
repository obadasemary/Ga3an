//
//  MapViewController.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 4/14/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            
            if error != nil {
                print(error)
                self.showError("Connection Error", mes: "Sorry Connection Error")
                return
            }
            
            if let placemarks = placemarks {
                
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        }
        
        // Map customization
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        // Set the MKMapViewDelegate
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftIconView.image = UIImage(data: restaurant.image!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        // Pin color customization
        annotationView?.pinTintColor = UIColor.orangeColor()
        
        self.spinner.stopAnimating()
        
        return annotationView
    }
    
    func showError(title:String, mes: String) {
        
        let optionMenu = UIAlertController(title: title, message: mes, preferredStyle: .Alert)
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        // Display the menu
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        spinner.stopAnimating()
    }
}
