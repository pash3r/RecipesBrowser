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
        HStack {
            AsyncImage(url: item.thumbnailUrl) { imgPhase in
                switch imgPhase {
                case .success(let image):
                    image
                        .resizable()
                case .empty:
                    ProgressView()
                case .failure:
                    imgPlaceholder
                @unknown default:
                    imgPlaceholder
                }
            }
            .frame(width: 50, height: 50)

            Text(item.name)
        }
    }
    
    private var imgPlaceholder: some View {
        Image(systemName: "birthday.cake")
    }
}

#Preview {
    RecipeListRowView(item: Meal.preview.first!)
}
