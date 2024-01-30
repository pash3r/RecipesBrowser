//
//  Meal.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

struct Meal: Identifiable {
    let id: String
    let name: String
    let imgUrl: URL
    
    static let preview: [Meal] = {
        (0..<9).map { _ in
            let id = Int.random(in: 0...99999)
            return Meal(id: "\(id)", name: "Name \(id)", imgUrl: URL(string: "https:/www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!)
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
