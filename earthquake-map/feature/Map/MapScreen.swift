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
    @Binding var isLoading: Bool
    @Binding var isSnackbarReady: Bool
    @Binding var snackbarMessage: String
    @Binding var shouldRenew: Bool
    
    @StateObject private var viewModel = MapScreenViewModel()
    
    var body: some View {
        MapScreen(
            isLoading: $isLoading,
            isSnackbarReady: $isSnackbarReady,
            snackbarMessage: $snackbarMessage,
            uiState: $viewModel.uiState
        )
        .onChange(of: shouldRenew) {
            if !shouldRenew { return }
            
            viewModel.renew()
            shouldRenew = false
        }
    }
}

private struct MapScreen: View {
    @Binding var isLoading: Bool
    @Binding var isSnackbarReady: Bool
    @Binding var snackbarMessage: String
    @Binding var uiState: MapScreenUIState
    
    @State var cameraPosition: GMSCameraPosition?
    @State var earthquakes: [Earthquake]?
    @State var selectedEarthquake: Earthquake?
    @State var zoomInCenter = false
    @State var shouldShowBottomSheet = false
    
    private var markers: [GMSMarker]? {
        guard let earthquakes else {
            return nil
        }
        
        return earthquakes.compactMap { earthquake in
            earthquake.hypocenter?.marker
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                VStack {
                    MapViewControllerBridge(
                        markers: markers,
                        mapViewWillMove: { (isGesture) in
                            guard isGesture else { return }
                            self.zoomInCenter = false
                        },
                        proxy: proxy,
                        cameraPosition: $cameraPosition,
                        earthquakes: $earthquakes,
                        selectedEarthquake: $selectedEarthquake,
                        shouldShowBottomSheet: $shouldShowBottomSheet
                    )
                    .overlay(alignment: .bottom) {
                        if let earthquakes = Binding($earthquakes) {
                            BottomList(
                                cameraPosition: $cameraPosition,
                                earthquakes: earthquakes,
                                selectedEarthquake: $selectedEarthquake,
                                shouldShowBottomSheet: $shouldShowBottomSheet
                            )
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $shouldShowBottomSheet) {
            if let selectedEarthquake {
                BottomSheet(
                    selectedEarthquake: selectedEarthquake,
                )
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .onChange(of: uiState) {
            switch uiState {
                case MapScreenUIState.loading:
                    withAnimation(.easeInOut(duration: 10)) {
                        isLoading = true
                    }
                case MapScreenUIState.failed:
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLoading = false
                    }
                    isSnackbarReady = true
                    snackbarMessage = "Unexpected error"
                    
                case MapScreenUIState.succeed(let earthquakes):
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLoading = false
                    }
                    self.earthquakes = earthquakes
            }
        }
    }
}

private struct BottomList: View {
    @Binding var cameraPosition: GMSCameraPosition?
    @Binding var earthquakes: [Earthquake]
    @Binding var selectedEarthquake: Earthquake?
    @Binding var shouldShowBottomSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(
                    Array($earthquakes.enumerated()),
                    id: \.element.id
                ) { index, earthquake in
                    EarthquakeInfoSummaryCard(
                        cameraPosition: $cameraPosition,
                        earthquake: earthquake,
                        selectedEarthquake: $selectedEarthquake,
                        shouldShowBottomSheet: $shouldShowBottomSheet
                    )
                }
            }
        }
        .frame(
            width: .infinity,
            height: 300,
            alignment: .bottomTrailing
        )
        .scrollContentBackground(.hidden)
    }
}

private struct EarthquakeInfoSummaryCard: View {
    @Binding var cameraPosition: GMSCameraPosition?
    @Binding var earthquake: Earthquake
    @Binding var selectedEarthquake: Earthquake?
    @Binding var shouldShowBottomSheet: Bool
    
    private var hypocenter: Hypocenter? {
        earthquake.hypocenter
    }
    private var time: String {
        hypocenter?.time ?? "No info"
    }
    private var place: String {
        hypocenter?.place ?? "No info"
    }
    private var magnitude: String {
        hypocenter?.magnitude ?? "No info"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EarthquakeInfoCard(
                imageName: "GIClock",
                title: "Time of the earthquake",
                subtitle: time
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillMapPin",
                title: "Hypocenter",
                subtitle: place
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillLandslide",
                title: "Magnitude",
                subtitle: magnitude
            )
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .onTapGesture {
            selectedEarthquake = $earthquake.wrappedValue
            if let position = $earthquake.wrappedValue.hypocenter {
                if let marker = position.marker {
                    cameraPosition = GMSCameraPosition.camera(
                        withTarget: marker.position,
                        zoom: marker.map?.camera.zoom ?? MapViewControllerBridge.defaultCameraZoom
                    )
                }
            }
            shouldShowBottomSheet = true
        }
        .id(earthquake.id)
    }
}

private struct BottomSheet: View {
    var selectedEarthquake: Earthquake
    @State var shouldExpand = false
    
    private var hypocenter: Hypocenter? {
        selectedEarthquake.hypocenter
    }
    private var time: String {
        hypocenter?.time ?? "No info"
    }
    private var place: String {
        hypocenter?.place ?? "No info"
    }
    private var magnitude: String {
        hypocenter?.magnitude ?? "No info"
    }
    private var depth: String {
        hypocenter?.depth ?? "No info"
    }
    private var points: [ObservationPoint]? {
        selectedEarthquake.observationPoints
    }
    
    var body: some View {
        ScrollView {
            EarthquakeInfoCard(
                imageName: "GIClock",
                title: "Time of the earthquake",
                subtitle: time
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillMapPin",
                title: "Hypocenter",
                subtitle: place
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillLandslide",
                title: "Magnitude",
                subtitle: magnitude
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillSolarPower",
                title: "Depth of the earthquake",
                subtitle: depth
            )
            
            ExpandableEarthquakeInfoCard(
                imageName: "GIFillAddLocationAlt",
                title: "Seismic intensity observation point",
                shouldExpand: $shouldExpand
            )
            .onTapGesture {
                withAnimation {
                    shouldExpand = !shouldExpand
                }
            }
            
            if let points {
                ForEach(points) { point in
                    ObservationPointList(
                        point: point,
                        shouldExpandParent: $shouldExpand
                    )
                }
            }
        }
        .padding(10)
        .padding(.top, 30)
        .presentationDetents([
            .fraction(0.1),
            .fraction(0.8)
        ])
    }
}

private struct ObservationPointList: View {
    var point: ObservationPoint
    @Binding var shouldExpandParent: Bool
    @State private var shouldExpandChildren = false
    
    var body: some View {
        if shouldExpandParent {
            HStack {
                Spacer().frame(width: 30)
                
                ExpandableEarthquakeInfoCard(
                    imageName: "GIFillMapPin",
                    title: "Seismic intensity observation point name",
                    subtitle: point.name,
                    shouldExpand: $shouldExpandChildren
                )
            }
            .onTapGesture {
                withAnimation {
                    shouldExpandChildren = !shouldExpandChildren
                }
            }
        }
        
        if shouldExpandParent && shouldExpandChildren {
            HStack {
                Spacer().frame(width: 30)
                Spacer().frame(width: 30)
                
                EarthquakeInfoCard(
                    imageName: "GIFillLandslide",
                    title: "Seismic intensity",
                    subtitle: point.scale
                )
            }
        }
    }
}

private struct EarthquakeInfoCard: View {
    var imageName: String
    var title: LocalizedStringKey
    var subtitle: String
    
    var body: some View {
        IconText(
            backgroundColor: .earthquakeInfoBackground,
            leadingImage: {
                Image(imageName)
            },
            content: {
                Divider().frame(height: 30.0)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .padding(.bottom, 2)
                    Text(subtitle)
                }
                
                Spacer()
            }
        )
    }
}

private struct ExpandableEarthquakeInfoCard: View {
    var imageName: String
    var title: LocalizedStringKey
    var subtitle: String?
    @Binding var shouldExpand: Bool
    
    var body: some View {
        IconText(
            backgroundColor: .earthquakeInfoBackground,
            leadingImage: {
                Image(imageName)
            },
            content: {
                Divider().frame(height: 30.0)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    subtitle.map { text in
                        Text(text)
                    }
                }
                
                Spacer()
            },
            trailingImage: {
                Image("GIKeyboardArrowDown")
                    .rotationEffect(
                        Angle(degrees: shouldExpand ? -180 : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: shouldExpand)
            }
        )
    }
}

#Preview {
    @Previewable @State var isLoading = false
    @Previewable @State var isSnackbarReady = false
    @Previewable @State var snackbarMessage = ""
    @Previewable @State var shouldRenew = false
    
    MapScreenRoute(
        isLoading: $isLoading,
        isSnackbarReady: $isSnackbarReady,
        snackbarMessage: $snackbarMessage,
        shouldRenew: $shouldRenew
    )
}
