//
//  RecipeDetailView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeId: String
    @EnvironmentObject private var provider: RecipeDetailsProvider
    private let viewModel = ViewModel()
        
    var body: some View {
        VStack {
            switch viewModel.state(from: provider) {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let mealDetail):
                ScrollView {
                    makeImage(with: mealDetail.imgUrl)
                    
                    VStack(alignment: .leading) {
                        makeTitleAndInstructions(with: mealDetail)
                            .padding(.bottom, Constants.verticalPadding)
                        Text(viewModel.ingredientsTitle)
                            .font(.title3)
                        ForEach(mealDetail.ingredients) { item in
                            IngredientView(ingredient: item)
                        }
                    }
                    .padding([.leading, .trailing, .bottom], Constants.verticalPadding)
                }
            case .error(let text):
                ErrorRetryView(text: text) {
                    Task {
                        await provider.retry(with: recipeId)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.navbarTitle(with: provider))
        .task {
            await provider.loadRecipe(with: recipeId)
        }
    }
    
    func makeTitleAndInstructions(with model: MealDetail) -> some View {
        VStack(spacing: Constants.verticalPadding) {
            Text(model.name)
                .font(.title)
            
            Text(viewModel.instructionsTitle)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(model.instructions)
        }
    }
    
    func makeImage(with url: URL?) -> some View {
        AsyncImage(url: url) { imgPhase in
            switch imgPhase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                makeImgPlaceholder()
            @unknown default:
                makeImgPlaceholder()
            }
        }
    }
    
    func makeImgPlaceholder() -> some View {
        Image(systemName: "fork.knife.circle")
    }
    
    private struct Constants {
        static let verticalPadding: CGFloat = 12
    }
}

private extension RecipeDetailView {
    struct ViewModel {
        let instructionsTitle: String = "Instructions:"
        let ingredientsTitle: String = "Ingredients:"
        
        func state(from provider: RecipeDetailsProvider) -> State {
            let result: State
            switch provider.state {
            case .initial:
                result = .initial
            case .loading:
                result = .loading
            case .loaded(let recipe):
                result = .loaded(recipe)
            case .error:
                result = .error("Something went wrong") // use default error text
            }
            
            return result
        }
        
        func navbarTitle(with provider: RecipeDetailsProvider) -> String {
            guard case let .loaded(recipe) = provider.state else {
                return ""
            }
            
            return recipe.name
        }
        
        enum State {
            case initial
            case loading
            case loaded(MealDetail)
            case error(String)
        }
    }
}

#if DEBUG
#Preview {
    RecipeDetailView(recipeId: "")
}
#endif
