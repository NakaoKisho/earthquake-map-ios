//
//  P2PquakeRepository.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Alamofire
import Combine
import Foundation

struct P2PquakeRepository {
    func getEarthquake() -> DataResponsePublisher<[JMAQuake]> {
        return AF
            .request("https://api.p2pquake.net/v2/history?codes=551&limit=10")
            .validate()
            .publishDecodable(type: [JMAQuake].self)
    }
}
