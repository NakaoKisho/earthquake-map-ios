//
//  MapViewControllerBridge.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/07/27.
//

import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {    
    var markers: [GMSMarker]?
    var mapViewWillMove: (Bool) -> Void
    var proxy: ScrollViewProxy
    
    @Binding var cameraPosition: GMSCameraPosition?
    @Binding var earthquakes: [Earthquake]?
    @Binding var selectedEarthquake: Earthquake?
    @Binding var shouldShowBottomSheet: Bool
    
    static let defaultCameraZoom: Float = 4.5
    
    static func getDefaultCameraPosition() -> GMSCameraPosition {
        let defaultCameraPosition = CLLocationCoordinate2D(
            latitude: 35.6764,
            longitude: 139.6500
        )
        
        return GMSCameraPosition.camera(
            withTarget: defaultCameraPosition,
            zoom: defaultCameraZoom
        )
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        
        let defaultCameraPosition = CLLocationCoordinate2D(
            latitude: 35.6764,
            longitude: 139.6500
        )
        uiViewController.map.camera = GMSCameraPosition.camera(
            withTarget: defaultCameraPosition,
            zoom: MapViewControllerBridge.defaultCameraZoom
        )
        
        uiViewController.map.delegate = context.coordinator
        
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        moveCamera(uiViewController: uiViewController)
        renewMarkers(uiViewController: uiViewController)
    }
    
    private func moveCamera(uiViewController: MapViewController) {
        guard let cameraPosition else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setValue(NSNumber(value: 0.5), forKey: kCATransactionAnimationDuration)
        uiViewController.map.animate(to: cameraPosition)
        CATransaction.commit()
    }
    
    private func renewMarkers(uiViewController: MapViewController) {
        guard let markers else {
            return
        }
        
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
            updateSelectedEarthquake(didTapMarker: didTapMarker)
            scrollTo()
            self.mapViewControllerBridge.shouldShowBottomSheet = true
            
            return false
        }
        
        private func updateSelectedEarthquake(didTapMarker: GMSMarker) {
            let selected = self.mapViewControllerBridge.earthquakes?.first { earthquake in
                guard let hypocenter = earthquake.hypocenter else {
                    return false
                }
                guard let marker = hypocenter.marker else {
                    return false
                }
                let currentPosition = marker.position
                let tappedPosition = didTapMarker.position
                
                return currentPosition.latitude == tappedPosition.latitude &&
                currentPosition.longitude == tappedPosition.longitude
            }
            self.mapViewControllerBridge.selectedEarthquake = selected
        }
        
        private func scrollTo() {
            let itemPosition = self.mapViewControllerBridge.selectedEarthquake?.id
            withAnimation {
                self.mapViewControllerBridge.proxy.scrollTo(itemPosition, anchor: .center)
            }
        }
    }
}

