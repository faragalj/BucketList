//
//  MapView2.swift
//  BucketList
//
//  Created by Joseph Faragalla on 2020-09-11.
//  Copyright © 2020 Joseph Farag Alla. All rights reserved.
//
import MapKit
import SwiftUI

struct MapView2: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        //if what is in the array doesnt match what is on the map, update it
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView2
        
        init(_ parent: MapView2) {
            self.parent = parent
            
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        //creating the "i" that shows more info. Reusing views to improve performance
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //this is our unique identifier for view reuse
            let identifier = "Placemark"
            
            //attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //we didnt find one. make a new one
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                //allow this to show popup info
                annotationView?.canShowCallout = true
                
                //attach an information button to the view
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
            } else {
                //we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
                
            }
            
            //whether its the new view or recycled, send it back
            return annotationView
        }
        //gets called when the "i" is tapped. We get to decide what happens
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            guard let placeMark = view.annotation as? MKPointAnnotation else { return }
            
            //set selected place and show alert
            parent.selectedPlace = placeMark
            parent.showingPlaceDetails = true
        }
    }
    
}

