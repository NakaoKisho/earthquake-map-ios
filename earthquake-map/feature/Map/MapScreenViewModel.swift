//
//  MapScreenViewModel.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Combine
import Foundation
import GoogleMaps

final class MapScreenViewModel: ObservableObject {
    @Published var markers: [GMSMarker] = []
    
    private let earthquakeUsecase = EarthquakeFlowUsecase()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.earthquakeUsecase
                .execute()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                            case .failure: break
                            case .finished: break
                        }
                    },
                    receiveValue: { receiveValue in
                        guard let jmaQuake = receiveValue.value else { return }
                        
                        let markers = jmaQuake.map { earthquakeInfo in
                            let hypocenter = earthquakeInfo.earthquake.hypocenter
                            let latitude = hypocenter?.latitude ?? 0.0
                            let longitude = hypocenter?.longitude ?? 0.0
                            
                            return GMSMarker(
                                position: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                )
                            )
                        }
                        
                        self.markers.append(contentsOf: markers)
                    }
                )
                .store(in: &self.cancellables)
        }
    }
    
    func getEarthquakeData() {
        
    }
}
