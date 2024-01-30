//
//  Meal.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

struct Meal: Identifiable {
    let id: Int
    let name: String
    let imgUrl: URL?
    
    static let preview: [Meal] = {
        (0..<9).map { _ in
            let id = Int.random(in: 0...99999)
            return Meal(id: id, name: "Name \(id)", imgUrl: nil)
        }
    }()
}

extension Meal: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imgUrl = "strMealThumb"
    }
}
