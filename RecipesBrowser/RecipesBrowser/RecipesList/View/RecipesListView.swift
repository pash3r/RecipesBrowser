//
//  RecipesListView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct RecipesListView: View {
    let testData: [Int] = { (0..<9).map { $0 } }()
    
    var body: some View {
        NavigationStack {
            List(testData, id: \.self) { item in
                NavigationLink {
                    Text("\(item)")
                } label: {
                    Text("\(item)")
                }

            }
            .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipesListView()
}
