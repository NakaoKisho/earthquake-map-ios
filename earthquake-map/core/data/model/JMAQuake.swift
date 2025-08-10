//
//  P2PquakeResource.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

struct JMAQuake: Codable {
    var id: String
    var code: Int
    var time: String
    var issue: JMAIssue
    var earthquake: JMAEarthquake
    var points: [JMAPoint]?
    var comments: JMAComment
}
