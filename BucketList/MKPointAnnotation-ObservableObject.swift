//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Joseph Faragalla on 2020-09-12.
//  Copyright © 2020 Joseph Farag Alla. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? ""
        }
        set {
            title = newValue
        }
        
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? ""
        }
        set {
            subtitle = newValue
        }
    }
}
