//
//  TrendingData.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import Foundation

struct TrendingData: Codable {
    var id: String
    var title: String
    var rating: String
    var sourceTld: String
    var images: TrendingImages
}

struct TrendingImages: Codable {
    var fixedHeightSmall: TrendFixedHeightSmall
    var downsized: TrendDownsized
}

struct TrendFixedHeightSmall: Codable {
    var url: String
}

struct TrendDownsized: Codable {
    var url: String
}
