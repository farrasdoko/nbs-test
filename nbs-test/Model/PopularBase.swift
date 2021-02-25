//
//  PopularBase.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

struct PopularBase: Codable {
    
    // MARK: Properties
    public var totalResults: Int?
    public var page: Int?
    public var results: [PopularResults]?
    public var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
    }
    
}
