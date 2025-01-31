//
//  RecipeDetails.swift
//  RecipesApp
//
//  Created by Erick Bojorquez on 24/01/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeDetails: View {
    var id:Int
    @State var recipe:ApiNetwork.RecipeDetails? = nil
    @State var loading:Bool = true
    
    var body: some View {
        VStack{
            if loading{
                ProgressView().tint(.white)
            } else if let recipe = recipe{
                WebImage(url: URL(string: recipe.image))
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                
                Text(recipe.title)
                    .font(.title2)
                    .bold()
                    .padding()
                                
                Text("Intructions:")
                    .font(.title)
                    .padding(.horizontal)
                ScrollView{
                    Text(recipe.instructions!)
                        .font(.title2).italic()
                        .padding()
                }
                    
                    
                
            } else {
                Text("No hay imgen")
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundApp)
            .onAppear{
                Task{
                    do{
                        recipe = try await ApiNetwork().getRecipeById(id: id)
                    } catch{
                        recipe = nil
                    }
                    loading = false
                }
            }
    }
}

#Preview {
    RecipeDetails(id: 715538)
}
