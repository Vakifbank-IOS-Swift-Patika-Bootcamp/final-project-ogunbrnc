//
//  GetGamesResponseModel.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

struct GetGamesResponseModel: Decodable {
    let results: [GameModel]
    let next: String
}
