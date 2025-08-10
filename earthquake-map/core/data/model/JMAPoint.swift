//
//  JMAPoint.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/08.
//

struct JMAPoint: Codable {
    var pref: String
    var addr: String
    var isArea: Bool
    var scale: Int
}
