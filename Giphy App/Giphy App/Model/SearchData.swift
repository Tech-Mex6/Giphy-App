//
//  SearchData.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import Foundation

struct SearchData: Codable {
    var id: String
    var title: String
    var rating: String
    var sourceTld: String
    var images: Images
}

struct Images: Codable {
    var fixedHeightSmall: FixedHeightSmall
    var downsized: Downsized
}

struct FixedHeightSmall: Codable {
    var url: String
}

struct Downsized: Codable {
    var url: String
}
