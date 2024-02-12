//
//  MealDetailPreview.swift
//  RecipesBrowser
//
//  Created by Pavel Tikhonov on 2/12/24.
//

import Foundation

extension MealDetail {
    static let preview: Self = {
        let jsonData = rawJsonString.data(using: .utf8)!
        let jsonObj = try! JSONDecoder().decode([String: String?].self, from: jsonData)
            .compactMapValues { $0 }
        return MealDetail(rawValue: jsonObj)!
    }()
    
    static let rawJsonString =
    """
    {
        "idMeal": "52894",
        "strMeal": "Battenberg Cake",
        "strDrinkAlternate": null,
        "strCategory": "Dessert",
        "strArea": "British",
        "strInstructions": "Heat oven to 180C/160C fan/gas 4 and line the base and sides of a 20cm square tin with baking parchment (the easiest way is to cross 2 x 20cm-long strips over the base). To make the almond sponge, put the butter, sugar, flour, ground almonds, baking powder, eggs, vanilla and almond extract in a large bowl. Beat with an electric whisk until the mix comes together smoothly. Scrape into the tin, spreading to the corners, and bake for 25-30 mins – when you poke in a skewer, it should come out clean. Cool in the tin for 10 mins, then transfer to a wire rack to finish cooling while you make the second sponge.\\r\\nFor the pink sponge, line the tin as above. Mix all the ingredients together as above, but don’t add the almond extract. Fold in some pink food colouring. Then scrape it all into the tin and bake as before. Cool.\\r\\nTo assemble, heat the jam in a small pan until runny, then sieve. Barely trim two opposite edges from the almond sponge, then well trim a third edge. Roughly measure the height of the sponge, then cutting from the well-trimmed edge, use a ruler to help you cut 4 slices each the same width as the sponge height. Discard or nibble leftover sponge. Repeat with pink cake.\\r\\nTake 2 x almond slices and 2 x pink slices and trim so they are all the same length. Roll out one marzipan block on a surface lightly dusted with icing sugar to just over 20cm wide, then keep rolling lengthways until the marzipan is roughly 0.5cm thick. Brush with apricot jam, then lay a pink and an almond slice side by side at one end of the marzipan, brushing jam in between to stick sponges, and leaving 4cm clear marzipan at the end. Brush more jam on top of the sponges, then sandwich remaining 2 slices on top, alternating colours to give a checkerboard effect. Trim the marzipan to the length of the cakes.\\r\\nCarefully lift up the marzipan and smooth over the cake with your hands, but leave a small marzipan fold along the bottom edge before you stick it to the first side. Trim opposite side to match size of fold, then crimp edges using fingers and thumb (or, more simply, press with prongs of fork). If you like, mark the 10 slices using the prongs of a fork.\\r\\nAssemble second Battenberg and keep in an airtight box or well wrapped in cling film for up to 3 days. Can be frozen for up to a month.",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg",
        "strTags": "Cake,Sweet",
        "strYoutube": "https://www.youtube.com/watch?v=aB41Q7kDZQ0",
        "strIngredient1": "Butter",
        "strIngredient2": "Caster Sugar",
        "strIngredient3": "Self-raising Flour",
        "strIngredient4": "Almonds",
        "strIngredient5": "Baking Powder",
        "strIngredient6": "Eggs",
        "strIngredient7": "Vanilla Extract",
        "strIngredient8": "Almond Extract",
        "strIngredient9": "Butter",
        "strIngredient10": "Caster Sugar",
        "strIngredient11": "Self-raising Flour",
        "strIngredient12": "Almonds",
        "strIngredient13": "Baking Powder",
        "strIngredient14": "Eggs",
        "strIngredient15": "Vanilla Extract",
        "strIngredient16": "Almond Extract",
        "strIngredient17": "Pink Food Colouring",
        "strIngredient18": "Apricot",
        "strIngredient19": "Marzipan",
        "strIngredient20": "Icing Sugar",
        "strMeasure1": "175g",
        "strMeasure2": "175g",
        "strMeasure3": "140g",
        "strMeasure4": "50g",
        "strMeasure5": "½ tsp",
        "strMeasure6": "3 Medium",
        "strMeasure7": "½ tsp",
        "strMeasure8": "¼ teaspoon",
        "strMeasure9": "175g",
        "strMeasure10": "175g",
        "strMeasure11": "140g",
        "strMeasure12": "50g",
        "strMeasure13": "½ tsp",
        "strMeasure14": "3 Medium",
        "strMeasure15": "½ tsp",
        "strMeasure16": "¼ teaspoon",
        "strMeasure17": "½ tsp",
        "strMeasure18": "200g",
        "strMeasure19": "1kg",
        "strMeasure20": "Dusting",
        "strSource": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
        "strImageSource": null,
        "strCreativeCommonsConfirmed": null,
        "dateModified": null
    }
    """
}
