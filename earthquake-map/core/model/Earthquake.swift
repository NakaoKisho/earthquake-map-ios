//
//  Earthquake.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Foundation
import GoogleMaps

class Earthquake: Identifiable {
    let id: String
    var hypocenter: Hypocenter?
    var observationPoints: [ObservationPoint]?
    
    init(
        id: String,
        hypocenter: Hypocenter?,
        observationPoints: [ObservationPoint]? = nil
    ) {
        self.id = id
        self.hypocenter = hypocenter
        self.observationPoints = observationPoints
    }
}

class Hypocenter {
    var time: String
    var place: String?
    var magnitude: String?
    var depth: String?
    var marker: GMSMarker?
    
    init(
        time: String,
        place: String?,
        magnitude: String?,
        depth: String?,
        marker: GMSMarker?
    ) {
        self.time = time
        self.place = place
        self.magnitude = magnitude
        self.depth = depth
        self.marker = marker
    }
}

class ObservationPoint: Identifiable {
    var id = UUID()
    var name: String
    var scale: String
//    var marker: GMSMarker?
    
    init(
        name: String,
        scale: String,
//        marker: GMSMarker?
    ) {
        self.name = name
        self.scale = scale
//        self.marker = marker
    }
}
