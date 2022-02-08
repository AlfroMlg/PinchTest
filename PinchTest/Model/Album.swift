//
//  Album.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import Foundation
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
