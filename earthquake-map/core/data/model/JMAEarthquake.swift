//
//  JMAEarthquake.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/08.
//

struct JMAEarthquake: Codable {
    var time: String
    var hypocenter: JMAHypocenter?
    var maxScale: Int?
    var domesticTsunami: String?
    var foreignTsunami: String?
}

struct JMAHypocenter: Codable {
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var depth: Int?
    var magnitude: Double?
}
