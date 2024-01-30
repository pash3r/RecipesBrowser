//
//  RecipeListRowView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct RecipeListRowView: View {
    let item: Meal
    
    var body: some View {
        Text(item.name)
    }
}

#Preview {
    RecipeListRowView(item: Meal.preview.first!)
}
