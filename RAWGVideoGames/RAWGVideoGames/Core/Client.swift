//
//  Client.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import Foundation

enum ClientError: Error {
    case failedToFetchData
}

final class Client {
    
    enum Endpoints {
        static let base = "https://api.rawg.io/api"

        case games
        case gameDetail(Int)
        
        var stringValue: String {
            switch self {
            case .games:
                return Endpoints.base + "/games" + "?key=" + Constants.API_KEY
            case .gameDetail(let movieId):
                return Endpoints.base + "/games/" + String(movieId) + "?key=" + Constants.API_KEY
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
    
    class func getGames(by orderString: String = "", with urlString: String, search searchString: String = "", completion: @escaping (Result<GetGamesResponseModel,Error>)-> Void) {
        var requestURLString = urlString
        if urlString.isEmpty {
            requestURLString = Endpoints.games.stringValue
        }
        if !orderString.isEmpty {
            requestURLString += "&ordering=-\(orderString)"
        }
        if !searchString.isEmpty {
            requestURLString += "&search=\(searchString)"
        }
        print(requestURLString)
        guard let requestURL = URL(string: requestURLString) else { return }
        taskForGETRequest(url: requestURL , responseType: GetGamesResponseModel.self) { responseModel, error in
            guard let responseModel = responseModel else{
                return
            }
            completion(.success(responseModel))
        }
    }
    
    class func getGameDetail(movieId: Int,completion: @escaping (Result<GameDetailModel,Error>)-> Void ) {
        taskForGETRequest(url: Endpoints.gameDetail(movieId).url, responseType: GameDetailModel.self) { responseModel, error in
            guard let responseModel = responseModel, error == nil else{
                completion(.failure(ClientError.failedToFetchData))
                return
            }
            completion(.success(responseModel))
        }
    }
    
    
}
