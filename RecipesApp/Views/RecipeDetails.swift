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
            ScrollView{
                
                if loading{
                    ProgressView().tint(.white)
                } else if let recipe = recipe{
                    WebImage(url: URL(string: recipe.image))
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    
                    Text(recipe.title)
                        .foregroundColor(.black)
                        .font(.title2).italic()
                        .bold()
                        .padding()
                    
                    Text("Intructions:")
                        .foregroundColor(.black)
                        .font(.title).italic()
                        .bold()
                        .padding(.horizontal)
                    
                        Text(recipe.instructions!)
                            .bold()
                            .padding()
                    
                    Spacer()
                    
                    Text("Ingridients:")
                        .foregroundColor(.black)
                        .font(.title2).italic()
                        .bold()
                    
                    ForEach(recipe.extendedIngredients, id: \.name){ingridient in
                        HStack{
                            Text("\(ingridient.name):")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .bold()
                            if let amount = ingridient.amount, let unit = ingridient.unit{
                                Text("\(amount) \(unit)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                } else {
                    Text("No hay imgen")
                }
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
