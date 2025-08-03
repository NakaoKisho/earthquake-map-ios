//
//  MapViewControllerBridge.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/07/27.
//

import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    @Binding var markers: [GMSMarker]
    
    var mapViewWillMove: (Bool) -> Void
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        uiViewController.map.delegate = context.coordinator
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        withAnimation {
            markers.forEach { marker in
                marker.map = uiViewController.map
            }
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge
        
        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            self.mapViewControllerBridge.mapViewWillMove(gesture)
        }
    }
}
