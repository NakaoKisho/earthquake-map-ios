//
//  MapScreenViewModel.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Foundation
import GoogleMaps

final class MapScreenViewModel: ObservableObject {
    @Published var markers: [GMSMarker] = []
    
    private let earthquakeUsecase = EarthquakeFlowUsecase()
//    private var disposables = Set<AnyCancellable>()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.earthquakeUsecase
                .execute()
                .sink { value in
                    self.markers.append(value)
                }
//                .store(in: &disposables)
        }
    }
    
    func getEarthquakeData() {
        
    }
}
