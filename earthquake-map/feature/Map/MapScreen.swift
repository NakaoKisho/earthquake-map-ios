//
//  MapScreen.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Combine
import GoogleMaps
import SwiftUI

struct MapScreenRoute: View {
    @ObservedObject private var viewModel = MapScreenViewModel()
    
    var body: some View {
        MapScreen(
            markers: $viewModel.markers
        )
    }
}

private struct MapScreen: View {
    @Binding var markers: [GMSMarker]
    @State var zoomInCenter = false
    
    var body: some View {
        MapViewControllerBridge(
            markers: $markers,
            mapViewWillMove: { (isGesture) in
                guard isGesture else { return }
                self.zoomInCenter = false
            }
        )
    }
}

#Preview {
    MapScreenRoute()
}
