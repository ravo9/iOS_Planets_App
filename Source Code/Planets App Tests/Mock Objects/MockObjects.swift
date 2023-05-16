import XCTest
import CoreData

@testable import Planets_App

class MockContext: NSManagedObjectContext {
    
    override init(concurrencyType ct: NSManagedObjectContextConcurrencyType) {
        super.init(concurrencyType: ct)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func save() throws {}
    
}

class MockAPIClient: APIClient {
    var mockResponse: GetPlanetsResponse?
    
    override func getPlanets(completion: @escaping (GetPlanetsResponse) -> (), errorHandling: @escaping (Error) -> ()) {
        if let mockResponse = mockResponse {
            completion(mockResponse)
        } else {
            errorHandling(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
}

class MockPlanetsRepository: PlanetsRepository {
    
    var fetchDataResult: Result<[PlanetModel], Error>?
    
    override func fetchData(completion: @escaping (Result<[PlanetModel], Error>) -> Void) {
        if let result = fetchDataResult {
            completion(result)
        } else {
            // Handle the case where fetchDataResult is not set
            fatalError("fetchDataResult is not set")
        }
    }
}
