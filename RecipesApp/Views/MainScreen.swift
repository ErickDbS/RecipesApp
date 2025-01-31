import SwiftUI
import SDWebImageSwiftUI

struct MainScreen: View {
    @State var recipe: String = ""
    @State var recipes: [ApiNetwork.Recipes] = []
    @State var isLoading: Bool = true

    var body: some View {
        VStack {
            TextField("", text: $recipe, prompt: Text("Buscar")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
            )
            .padding(16)
            .border(.white, width: 1.5)
            .padding(.horizontal)
            .autocorrectionDisabled()
            .onSubmit {
                searchRecipes()
            }

            // Lista de recetas
            
            if isLoading {
                ProgressView("Cargando recetas...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if recipes.isEmpty {
                Text("No se encontraron recetas. Intenta nuevamente.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
            } else {
                NavigationStack{
                    List(recipes) { recipe in
                        ZStack {
                            RecipeItem(recipe: recipe)
                            NavigationLink(destination: {RecipeDetails(id: recipe.id)}){EmptyView()}.opacity(0)
                        }.listRowBackground(Color.backgroundApp)
                    }
                    .listStyle(.plain)
                    
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundApp)
        .onAppear {
            Task {
                await loadRandomRecipes()
            }
        }
    }

    func loadRandomRecipes() async {
        do {
            isLoading = true
            let randomRecipes = ["Pasta", "Pizza", "Hamburger", "Eggs", "HotDogs"]
            let randomQueryRecipe = randomRecipes.randomElement()!
            let wrapper = try await ApiNetwork().getRecipesByQuery(query: randomQueryRecipe)
            recipes = wrapper.results
            print("Recetas aleatorias obtenidas: \(recipes)") 
            isLoading = false
        } catch {
            print("Error al cargar recetas aleatorias: \(error.localizedDescription)")
            isLoading = false
        }
    }

    func searchRecipes() {
        Task {
            if recipe.isEmpty {
                await loadRandomRecipes()
            } else {
                do {
                    isLoading = true
                    let wrapper = try await ApiNetwork().getRecipesByQuery(query: recipe)
                    recipes = wrapper.results
                    isLoading = false
                } catch {
                    print("Error al buscar recetas: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct RecipeItem: View {
    let recipe: ApiNetwork.Recipes
    var body: some View {
        ZStack {
            WebImage(url: URL(string: recipe.image))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(height: 200)
            VStack {
                Spacer()
                Text(recipe.title)
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.5))
            }
        }
        .frame(height: 200)
        .cornerRadius(22)
    }
}

#Preview {
    
}
