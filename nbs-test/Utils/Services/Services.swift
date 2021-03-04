//
//  Services.swift
//  nbs-test
//
//  Created by Farras Doko on 03/03/21.
//

import Foundation
import Combine

protocol ImageService {
    func search(_ query: String) -> AnyPublisher<[String], Never>
}

func call<T: Decodable>(_ request: URL) -> AnyPublisher<T, Error> {
    let publisher = URLSession.shared.dataTaskPublisher(for: request)
        .map{$0.data}
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    
    return publisher
}
