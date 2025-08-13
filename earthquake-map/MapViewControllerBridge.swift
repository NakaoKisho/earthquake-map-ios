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
    
    @Binding var shouldShowBottomSheet: Bool
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        uiViewController.map.camera = getDefaultCameraPosition()
        uiViewController.map.delegate = context.coordinator
        
        return uiViewController
    }
    
    private func getDefaultCameraPosition() -> GMSCameraPosition {
        let defaultCameraPosition = CLLocationCoordinate2D(
            latitude: 35.6764,
            longitude: 139.6500
        )
        let zoom: Float = 4.5
        
        return GMSCameraPosition.camera(
            withTarget: defaultCameraPosition,
            zoom: zoom
        )
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        markers.forEach { marker in
            marker.map = uiViewController.map
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
        
        func mapView(_ mapView: GMSMapView, didTap didTapMarker: GMSMarker) -> Bool {
            mapViewControllerBridge.shouldShowBottomSheet = true
            return false
        }
    }
}
