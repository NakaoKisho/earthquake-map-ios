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
    @State var shouldShowBottomSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MapViewControllerBridge(
                    markers: $markers,
                    mapViewWillMove: { (isGesture) in
                        guard isGesture else { return }
                        self.zoomInCenter = false
                    },
                    shouldShowBottomSheet: $shouldShowBottomSheet
                )
                .overlay(alignment: .bottom) {
                    BottomList(
                        shouldShowBottomSheet: $shouldShowBottomSheet
                    )
                }
            }
        }
        .sheet(isPresented: $shouldShowBottomSheet) {
            BottomSheet()
        }
    }
}

private struct BottomList: View {
    @Binding var shouldShowBottomSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                EarthquakeInfoSummaryCard(
                    shouldShowBottomSheet: $shouldShowBottomSheet
                )
                EarthquakeInfoSummaryCard(
                    shouldShowBottomSheet: $shouldShowBottomSheet
                )
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
    @State var subtitle1 = "2025/08/13 04:10"
    @State var subtitle2 = "大分県西部"
    @State var subtitle3 = "2.5"
    @Binding var shouldShowBottomSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EarthquakeInfoCard(
                imageName: "GIClock",
                title: "Time of the earthquake",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillMapPin",
                title: "Epicenter",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillLandslide",
                title: "Magnitude",
                subtitle: subtitle1
            )
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .onTapGesture {
            shouldShowBottomSheet = true
        }
    }
}

private struct BottomSheet: View {
    @State var subtitle1 = "2025/08/13 04:10"
    @State var shouldExpand = false
    
    var body: some View {
        ScrollView {
            EarthquakeInfoCard(
                imageName: "GIClock",
                title: "Time of the earthquake",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillMapPin",
                title: "Epicenter",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillLandslide",
                title: "Magnitude",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GIFillSolarPower",
                title: "Depth of the earthquake",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GILanguage",
                title: "Latitude of the earthquake",
                subtitle: subtitle1
            )
            
            EarthquakeInfoCard(
                imageName: "GILanguage",
                title: "Longitude of the earthquake",
                subtitle: subtitle1
            )
            
            ExpandableEarthquakeInfoCard(
                imageName: "GIFillAddLocationAlt",
                title: "Seismic intensity observation point",
                shouldExpand: $shouldExpand
            )
            .onTapGesture {
                shouldExpand = !shouldExpand
            }
            
            ObservationPointList(
                subtitle: "aaa",
                shouldExpandParent: $shouldExpand
            )
        }
        .padding(10)
        .padding(.top, 30)
        .presentationDetents([
            .fraction(0.3),
            .fraction(0.8)
        ])
    }
}

private struct ObservationPointList: View {
    var subtitle: String
    @Binding var shouldExpandParent: Bool
    @State private var shouldExpandChildren = false
    
    var body: some View {
        HStack {
            Spacer().frame(width: 30)
            
            ExpandableEarthquakeInfoCard(
                imageName: "GIFillMapPin",
                title: "Seismic intensity observation point name",
                subtitle: subtitle,
                shouldExpand: $shouldExpandChildren
            )
        }
        .opacity(shouldExpandParent ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: shouldExpandParent)
        .onTapGesture {
            shouldExpandChildren = !shouldExpandChildren
        }
        
        HStack {
            Spacer().frame(width: 30)
            Spacer().frame(width: 30)
            
            EarthquakeInfoCard(
                imageName: "GIFillLandslide",
                title: "Seismic intensity",
                subtitle: subtitle
            )
            .opacity(shouldExpandParent && shouldExpandChildren ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.2),
                value: shouldExpandParent && shouldExpandChildren
            )
        }
        
        HStack {
            Spacer().frame(width: 30)
            Spacer().frame(width: 30)
            
            EarthquakeInfoCard(
                imageName: "GILanguage",
                title: "Latitude of the earthquake",
                subtitle: subtitle
            )
            .opacity(shouldExpandParent && shouldExpandChildren ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.2),
                value: shouldExpandParent && shouldExpandChildren
            )
        }
        
        HStack {
            Spacer().frame(width: 30)
            Spacer().frame(width: 30)
            
            EarthquakeInfoCard(
                imageName: "GILanguage",
                title: "Longitude of the earthquake",
                subtitle: subtitle
            )
            .opacity(shouldExpandParent && shouldExpandChildren ? 1 : 0)
            .animation(
                .easeInOut(duration: 0.2),
                value: shouldExpandParent && shouldExpandChildren
            )
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
    MapScreenRoute()
}
