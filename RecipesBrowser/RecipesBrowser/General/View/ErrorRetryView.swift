//
//  ErrorRetryView.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 1/29/24.
//

import SwiftUI

struct ErrorRetryView: View {
    let text: String
    let action: (() -> Void)?
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
            Button("Reload") {
                action?()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    ErrorRetryView(text: "Something went wrong", action: nil)
}
#endif
