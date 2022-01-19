//
//  SearchResponse.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import Foundation
struct SearchResponse: Codable {
    var data: [SearchData]
}

struct SearchResult: Codable {
    var data: SearchData
}
