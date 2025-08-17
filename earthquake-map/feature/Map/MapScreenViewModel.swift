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
    @Published var uiState: MapScreenUIState = MapScreenUIState.loading
    
    private let earthquakeUsecase = EarthquakeFlowUsecase()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        renew()
    }
    
    func renew() {
        uiState = .loading
        
        DispatchQueue.main.async {
            self.earthquakeUsecase
                .execute()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                            case .failure:
                                self.uiState = .failed
                            case .finished: break
                        }
                    },
                    receiveValue: { receiveValue in
                        self.uiState = .succeed(
                            earthquakes: receiveValue
                        )
                    }
                )
                .store(in: &self.cancellables)
        }
    }
}

internal enum MapScreenUIState {
    case loading
    case failed
    case succeed(earthquakes: [Earthquake])
}

 extension MapScreenUIState: Equatable {
    static func == (lhs: MapScreenUIState, rhs: MapScreenUIState) -> Bool {
        switch (lhs, rhs) {
            case (loading, loading):
                return true
            case (loading, failed):
                return false
            case (loading, succeed):
                return false
                
            case (failed, loading):
                return false
            case (failed, failed):
                return true
            case (failed, succeed):
                return false
                
            case (succeed, loading):
                return false
            case (succeed, failed):
                return false
            case (succeed, succeed):
                return true
        }
    }
 }
