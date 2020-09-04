//
//  MapView.swift
//  BucketList
//
//  Created by Joseph Faragalla on 2020-09-04.
//  Copyright © 2020 Joseph Farag Alla. All rights reserved.
//
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    //adding the coordinator to communicate to and from the swiftui View
    class Coordinator: NSObject, MKMapViewDelegate {
        //need to reference MapView in our class, this is how we get it in here
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        //now we get to set the action for if anything happens
        
        //when it changes visible region
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        //customizing the way the point looks
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    //make and return the view
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        //adding an item on the map
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Capital of England"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13)
        mapView.addAnnotation(annotation)
        
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
}
