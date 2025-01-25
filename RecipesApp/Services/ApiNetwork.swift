//
//  ApiNetwork.swift
//  RecipesApp
//
//  Created by Erick Bojorquez on 24/01/25.
//

import Foundation

class ApiNetwork{
    struct Wrapper:Codable{
        let results:[Recipes]
    }
    
    struct Recipes:Codable, Identifiable{
        let id:Int
        let title:String
        let image:String
    }
    
    
    func getRecipesByQuery(query:String) async throws -> Wrapper{
        let apiKey:String = "5edff3e7de4f4dea962a1a197dab3a06"
        let apiUrl = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)&number=20")!
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        return try JSONDecoder().decode(Wrapper.self, from: data)
    }
    
}
