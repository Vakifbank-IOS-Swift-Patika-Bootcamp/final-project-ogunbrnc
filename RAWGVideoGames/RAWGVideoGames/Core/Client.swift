//
//  Client.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

final class Client {
    
    enum Endpoints {
        static let base = "https://api.rawg.io/api"

        case games
        
        var stringValue: String {
            switch self {
            case .games:
                return Endpoints.base + "/games" + "?dates=2022-01-01,2022-12-31" + "&ordering=-added" + "&key=" + Constants.API_KEY
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()

        return task
    }
    
    class func getGames(completion: @escaping ([GameModel]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.games.url, responseType: GetGamesResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
}
