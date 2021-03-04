//
//  Tmdb.swift
//  nbs-test
//
//  Created by Farras Doko on 03/03/21.
//

import Foundation
import Combine

class TmdbApi: ImageService {
    
    private let baseUrl = "https://api.themoviedb.org"
    private let API_KEY = "7e6dc9e445f1edd16330cb045b7ba4c0"
    
    func search(_ query: String) -> AnyPublisher<[String], Never> {
        return getImagesUrl(query)
            .tryMap { response -> [String] in
                let result = response.results?.compactMap {$0.posterPath}
                guard result != nil else {
                    throw ApiError.noData
                }
                return result!
            }
            .replaceError(with: [String]())
            .eraseToAnyPublisher()
    }
    
    func getRequest(_ query: String) -> URL {
        var components = URLComponents(string: baseUrl)
        components?.path = ApiHeader.search.rawValue
        
        // params
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: API_KEY),
            URLQueryItem(name: "query", value: query)
        ]
        
        return components!.url!
    }
    
    func getImagesUrl(_ query: String) -> AnyPublisher<PopularBase, Error> {
        return call(getRequest(query))
    }
}
