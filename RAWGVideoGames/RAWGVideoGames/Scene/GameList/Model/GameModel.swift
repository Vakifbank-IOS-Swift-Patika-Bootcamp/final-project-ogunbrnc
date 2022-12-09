//
//  Game.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

struct GameModel: Decodable {
    let name: String
    let playtime: Int
    let platforms: [Platform]
    let releaseDate: String
    let imageURL: String
    let rating: Double
    let ratings: [Rating]
    let ratingsCount: Int
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case name
        case playtime
        case platforms
        case releaseDate = "released"
        case imageURL = "background_image"
        case rating
        case ratings
        case ratingsCount = "ratings_count"
        case genres
    }
}

struct Platform: Decodable {
    let platform: PlatformInfo
}

struct PlatformInfo: Decodable {
    let id: Int
    let name: String
    let slug: String
}

struct Rating: Decodable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

struct Genre: Decodable {
    let id: Int
    let name: String
    let slug: String
}
