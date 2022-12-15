//
//  GameDetailModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

struct GameDetailModel: Decodable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let releaseDate: String
    let imageURL: String
    let parentPlatforms: [Platform]
    let genres: [Genre]
    let ratings: [Rating]
    let tags: [Tag]
    let playtime: Int
    let ratingsCount: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionRaw = "description_raw"
        case releaseDate = "released"
        case imageURL = "background_image"
        case parentPlatforms = "parent_platforms"
        case genres
        case ratings
        case tags
        case playtime
        case ratingsCount = "ratings_count"
        case rating
    }
}

struct Tag: Decodable {
    let id: Int
    let name: String
    let slug: String
}


