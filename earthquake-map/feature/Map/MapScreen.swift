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
                    BottomList()
                }
            }
        }
        .sheet(isPresented: $shouldShowBottomSheet) {
            BottomSheet()
        }
    }
}

private struct BottomList: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                EarthquakeInfoSummaryCard()
                EarthquakeInfoSummaryCard()
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            IconText(
                imageName: "paperplane",
                title: "発生日時",
                subtitle: $subtitle1
            )
            
            IconText(
                imageName: "paperplane",
                title: "震源地",
                subtitle: $subtitle2
            )
            
            IconText(
                imageName: "paperplane",
                title: "マグニチュード",
                subtitle: $subtitle3
            )
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .padding(.bottom, 10)
    }
}

private struct IconText: View {
    var imageName: String
    var title: String
    @Binding var subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .padding(5)
            
            Divider().padding(.vertical, 10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .padding(.bottom, 2)
                Text(subtitle)
            }
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
        )
        .padding(2)
    }
}

private struct BottomSheet: View {
    var body: some View {
        Text("Hello World")
            .presentationDetents([
                .fraction(0.3),
                .fraction(0.8)
            ])
        
    }
}

#Preview {
    MapScreenRoute()
}
