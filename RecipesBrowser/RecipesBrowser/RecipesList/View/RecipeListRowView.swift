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
            .clipShape(RoundedRectangle(cornerSize: Constants.imageCornerSize))
            .frame(width: Constants.imageSideLength, height: Constants.imageSideLength)

            Text(item.name)
        }
    }
    
    private var imgPlaceholder: some View {
        Image(systemName: Constants.placeholderName)
    }
    
    private struct Constants {
        static let imageCornerSize: CGSize = .init(width: 8, height: 8)
        static let imageSideLength: CGFloat = 50
        static let placeholderName: String = "birthday.cake"
    }
}

#Preview {
    RecipeListRowView(item: Meal.preview.first!)
}
