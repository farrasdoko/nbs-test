//
//  BelongsToCollection.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct BelongsToCollection: Codable {
    
    // MARK: Properties
    public var posterPath: String?
    public var name: String?
    public var backdropPath: String?
    public var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case name = "name"
        case backdropPath = "backdrop_path"
        case id = "id"
    }
    
}
