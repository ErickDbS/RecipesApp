//
//  ApiNetwork.swift
//  RecipesApp
//
//  Created by Erick Bojorquez on 24/01/25.
//

import Foundation

class ApiNetwork{
    
    private let apiKey:String = "5edff3e7de4f4dea962a1a197dab3a06"
    
    struct Wrapper:Codable{
        let results:[Recipes]
    }
    
    struct Recipes:Codable, Identifiable{
        let id:Int
        let title:String
        let image:String
    }
    
    struct RecipeDetails:Codable, Identifiable{
        let id:Int
        let title:String
        let image:String
        let instructions:String?
        let Ingredients:[Ingredient]?
        let extendedIngredients: [Ingredient]
    }
    
    struct Ingredient: Identifiable, Codable {
        var id: Int
        var name: String
        var amount: Double?
        var unit: String?
        var aisle: String?
        var image: String?
    }
    
    struct RestaurantResponse: Decodable {
        let restaurants: [RestaurantDetails]
    }

    struct RestaurantDetails: Identifiable, Decodable {
        let id: String
        let name: String
        let phone_number: Int?
        let logo_photos: [String]?
        
        enum CodingKeys:String, CodingKey{
            case id = "_id"
            case name,phone_number,logo_photos
        }
    }


//    struct Address: Codable {
//        let zipcode: String?
//        let country: String?
//        let city: String?
//        let latitude: Double?
//        let longitude: Double?
//        let street_addr: String?
//        let state: String?
//    }

    
    func getRestaurantsByQuery(query:String) async throws -> RestaurantResponse{
        let apiUrl = URL(string: "https://api.spoonacular.com/food/restaurants/search?query=\(query)&lat=37.7786357&lng=-122.3918135&apiKey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        return try JSONDecoder().decode(RestaurantResponse.self, from: data)
    }

    
    
    func getRecipesByQuery(query:String) async throws -> Wrapper{
        let apiUrl = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&apiKey=\(apiKey)&number=20")!
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        return try JSONDecoder().decode(Wrapper.self, from: data)
    }
    
    func getRecipeById(id: Int) async throws -> RecipeDetails {
        let apiUrl = URL(string: "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        return try JSONDecoder().decode(RecipeDetails.self, from: data)
    }

}
