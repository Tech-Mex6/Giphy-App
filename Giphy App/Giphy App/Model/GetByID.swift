//
//  GetByID.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import Foundation
struct GetByID: Codable {
    var id: String
    var title: String
    var rating: String
    var sourcePostUrl: String
    var images: GetImages
}

struct GetImages: Codable {
    var fixedHeightSmall: GetFixedHeightSmall
    var downsized: GetDownsized
}

struct GetFixedHeightSmall: Codable {
    var url: String
}

struct GetDownsized: Codable {
    var url: String
}
