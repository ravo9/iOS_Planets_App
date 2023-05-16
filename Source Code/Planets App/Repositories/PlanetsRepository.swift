import Foundation
import CoreData

class PlanetsRepository {
    
    private let managedObjectContext: NSManagedObjectContext
    private let apiClient: APIClient
    
    init(managedObjectContext: NSManagedObjectContext, apiClient: APIClient) {
        self.managedObjectContext = managedObjectContext
        self.apiClient = apiClient
    }
    
    func fetchData(completion: @escaping (Result<[PlanetModel], Error>) -> Void) {
        
        apiClient.getPlanets(completion: { result in
            let models = self.mapToPlanetModels(result.results)
            
            do {
                try self.managedObjectContext.save()
                completion(.success(models))
            } catch {
                self.completeWithErrorOrStoredData(completion: completion, error: error)
            }
            
        }, errorHandling: { error in
            self.completeWithErrorOrStoredData(completion: completion, error: error)
        })
    }
    
    private func mapToPlanetModels(_ data: [PlanetApiModel]) -> [PlanetModel] {
        return data.map { planetData in
            let entity = PlanetModel.entity()
            let planet = PlanetModel(entity: entity, insertInto: self.managedObjectContext)
            self.updatePlanetModel(planet, with: planetData)
            return planet
        }
    }
    
    private func updatePlanetModel(_ planet: PlanetModel, with data: PlanetApiModel) {
        self.managedObjectContext.perform {
            planet.name = data.name
            planet.climate = data.climate
            planet.terrain = data.terrain
            planet.population = data.population
        }
    }
    
    private func getSavedData() -> [PlanetModel] {
        do {
            let fetchRequest: NSFetchRequest<PlanetModel> = PlanetModel.fetchRequest()
            let models = try self.managedObjectContext.fetch(fetchRequest)
            return models
        } catch {
            return []
        }
    }
    
    private func completeWithErrorOrStoredData(completion: @escaping (Result<[PlanetModel], Error>) -> Void, error: Error) {
        print("planetsRepository.fetchData error: " + error.localizedDescription)
        let storedData = self.getSavedData()
        if (storedData.isEmpty) {
            completion(.failure(error))
        }
        else {
            completion(.success(storedData))
        }
    }
}
