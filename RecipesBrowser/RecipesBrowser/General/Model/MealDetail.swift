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

extension MealDetail {
    static let preview: Self = {
        MealDetail(id: "53062",
                   name: "Walnut Roll Gu\\u017evara",
                   instructions: "Mix all the ingredients for the dough together and knead well. Cover the dough and put to rise until doubled in size which should take about 2 hours. Knock back the dough and knead lightly.\r\n\r\nDivide the dough into two equal pieces; roll each piece into an oblong about 12 inches by 8 inches. Mix the filling ingredients together and divide between the dough, spreading over each piece. Roll up the oblongs as tightly as possible to give two 12 inch sausages. Place these side by side, touching each other, on a greased baking sheet. Cover and leave to rise for about 40 minutes. Heat oven to 200\\u00baC (425\\u00baF). Bake for 30-35 minutes until well risen and golden brown. Bread should sound hollow when the base is tapped.\r\n\r\nRemove from oven and brush the hot bread top with milk. Sift with a generous covering of icing sugar.",
                   imgUrl: URL(string: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg"),
                   ingredients: [])
    }()
}
