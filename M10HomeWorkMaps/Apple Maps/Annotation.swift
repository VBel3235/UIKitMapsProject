//
//  Annotation.swift
//  M10HomeWorkMaps
//
//  Created by Владислав Белов on 04.07.2021.
//

import Foundation
import MapKit
import UIKit

class Annotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var annotationImage: UIImage
    
   init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, annotationImage: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.annotationImage = annotationImage
    }
}
