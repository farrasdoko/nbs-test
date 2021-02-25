//
//  ApiManager.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import Foundation

class ApiManager {
    let urlString = "https://api.themoviedb.org"
    let API_KEY = "7e6dc9e445f1edd16330cb045b7ba4c0"
    
    func fetchPopular(isComingSoon: Bool, completion: @escaping (Result<PopularBase, Error>)->()) {
        var components = URLComponents(string: urlString)
        components?.path = ApiHeader.popular.rawValue
        
        // params
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: API_KEY),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "page", value: "1"),
        ]
        if isComingSoon {
            let year = Calendar.current.component(.year, from: Date())
            components?.queryItems?.append(URLQueryItem(name: "year", value: String(year+1) ))
        }
        
        guard let url = components?.url else { return }
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.noData))
                return }
            
            let jsonDecoder = JSONDecoder()
            guard let popular = try? jsonDecoder.decode(PopularBase.self, from: data) else {return}
            
            completion(.success(popular))
        }
        task.resume()
    }
    
    func fetchDetail(_ movieID: String, completion: @escaping (Result<Detail, Error>)->()) {
        var components = URLComponents(string: urlString)
        let path = "\(ApiHeader.detail.rawValue)/\(movieID))"
        components?.path = path
        
        // params
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: API_KEY),
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = components?.url else { return }
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.noData))
                return }
            
            let jsonDecoder = JSONDecoder()
            guard let detail = try? jsonDecoder.decode(Detail.self, from: data) else {
                completion(.failure(ApiError.cantDecode))
                return}
            completion(.success(detail))
        }
        task.resume()
    }
    
}
