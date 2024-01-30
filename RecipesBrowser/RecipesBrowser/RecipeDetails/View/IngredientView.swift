//
//  IngredientView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/30/24.
//

import SwiftUI

struct IngredientView: View {
    let ingredient: MealDetail.Ingredient
    
    var body: some View {
        HStack {
            Text("\(ingredient.name):")
            Text(ingredient.value)
        }
    }
}

#Preview {
    let sample = MealDetail.Ingredient(name: "Some name", value: "2 ml")
    return IngredientView(ingredient: sample)
}
