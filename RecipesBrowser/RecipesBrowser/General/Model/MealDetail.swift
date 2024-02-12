//
//  MealDetail.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import Foundation

struct MealDetail {
    let id: String
    let name: String
    let instructions: String
    let imgUrl: URL?
    let ingredients: [Ingredient]
    
    private init(id: String, name: String, instructions: String, imgUrl: URL?, ingredients: [Ingredient]) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.imgUrl = imgUrl
        self.ingredients = ingredients
    }
    
    struct Ingredient: Identifiable {
        let id = UUID()
        let name: String
        let value: String
    }
}

extension MealDetail {
    init?(rawValue: [String: String]?) {
        guard let rawValue else {
            return nil
        }
        
        guard let id = rawValue[CodingKeys.id.rawValue],
              let name = rawValue[CodingKeys.name.rawValue],
              let instructions = rawValue[CodingKeys.instructions.rawValue],
              let imgUrlString = rawValue[CodingKeys.imgUrl.rawValue] else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.instructions = instructions
        self.imgUrl = URL(string: imgUrlString)
        
        var ingredientKeys = [String]()
        var measurementKeys = [String]()
        var ingredients = [Ingredient]()
        
        for (key, value) in rawValue {
            guard !value.isEmpty else {
                continue
            }
                                    
            if key.starts(with: Self.ingredientNamePrefix) {
                ingredientKeys.append(key)
            }
            if key.starts(with: Self.ingredientMeasurementPrefix) {
                measurementKeys.append(key)
            }
        }
        
        ingredientKeys.sort()
        measurementKeys.sort()
        
        zip(ingredientKeys, measurementKeys).forEach { ingredient, measurement in
            if let name = rawValue[ingredient], let value = rawValue[measurement] {
                ingredients.append(Ingredient(name: name, value: value))
            }
        }
        
        self.ingredients = ingredients
    }
    
    private enum CodingKeys: String {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case imgUrl = "strMealThumb"
    }
    
    private static let ingredientNamePrefix = "strIngredient"
    private static let ingredientMeasurementPrefix = "strMeasure"
}
