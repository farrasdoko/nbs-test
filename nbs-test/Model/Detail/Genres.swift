//
//  Genres.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Genres: Codable, Identifiable {

  // MARK: Properties
  public var id: Int?
  public var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

}
