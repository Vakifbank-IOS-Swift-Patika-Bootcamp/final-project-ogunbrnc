//
//  Game.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

struct GameModel: Decodable {
    let id: Int
    let name: String
    let playtime: Int?
    let parentPlatforms: [Platform]?
    let releaseDate: String?
    let imageURL: String?
    let rating: Double?
    let ratings: [Rating]?
    let ratingsCount: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case playtime
        case parentPlatforms = "parent_platforms"
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


extension Platform: Equatable {
    static func == (lhs: Platform, rhs: Platform) -> Bool {
        return lhs.platform.id == rhs.platform.id
    }
}

extension Rating: Equatable {
    static func == (lhs: Rating, rhs: Rating) -> Bool {
        return lhs.id == rhs.id && lhs.count == rhs.count && lhs.title == rhs.title && lhs.percent == rhs.percent
    }
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}
