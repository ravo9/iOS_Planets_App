import XCTest
import CoreData

@testable import Planets_App

class PlanetsRepositoryTests: XCTestCase {
    
    var mockManagedObjectContext: NSManagedObjectContext!
    var mockAPIClient: MockAPIClient!
    var planetsRepository: PlanetsRepository!
    
    override func setUp() {
        super.setUp()
        setupMockContext()
        setupMockAPIClient()
        setupPlanetsRepository()
    }
    
    private func setupMockContext() {
        mockManagedObjectContext = MockContext(concurrencyType: .privateQueueConcurrencyType)
    }
        
    private func setupMockAPIClient() {
        mockAPIClient = MockAPIClient(apiUrl: URL(string: Constants.apiUrl)!)
    }
        
    private func setupPlanetsRepository() {
        planetsRepository = PlanetsRepository(managedObjectContext: mockManagedObjectContext, apiClient: mockAPIClient)
    }
    
    private func setupPersistentStoreCoordinator() {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        mockManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    override func tearDown() {
        mockManagedObjectContext = nil
        mockAPIClient = nil
        planetsRepository = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        
        // Given
        let expectedPlanets = [
            PlanetApiModel(name: "Tatooine", climate: "arid", terrain: "desert", population: "200000"),
            PlanetApiModel(name: "Alderaan", climate: "temperate", terrain: "grasslands, mountains", population: "2000000000")
        ]
        mockAPIClient.mockResponse = GetPlanetsResponse(results: expectedPlanets)

        // When
            let expectation = self.expectation(description: "Fetch planets data")
            var planetsResult: [PlanetModel]?
            planetsRepository.fetchData(completion: { result in
                switch result {
                case .success(let planets):
                    planetsResult = planets
                    print("Got planets data")
                    
                    // Then
                    XCTAssertNotNil(planetsResult)
                    XCTAssertEqual(planetsResult?.count, 2)
                    XCTAssertEqual(planetsResult?.first?.name, "Tatooine")
                    XCTAssertEqual(planetsResult?.first?.climate, "arid")
                    XCTAssertEqual(planetsResult?.first?.terrain, "desert")
                    XCTAssertEqual(planetsResult?.first?.population, "200000")
                    XCTAssertEqual(planetsResult?.last?.name, "Alderaan")
                    XCTAssertEqual(planetsResult?.last?.climate, "temperate")
                    XCTAssertEqual(planetsResult?.last?.terrain, "grasslands, mountains")
                    XCTAssertEqual(planetsResult?.last?.population, "2000000000")
                    
                case .failure(_):
                    print("Failed to get planets data")
                    planetsResult = nil
                }
                expectation.fulfill()
            })
            waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchDataFailure() {
        setupPersistentStoreCoordinator()

        // Given
        mockAPIClient.mockResponse = nil // Set mock response to nil to simulate error

        // When
        let expectation = self.expectation(description: "Fetch planets data")
        var planetsResult: [PlanetModel]?
        var error: Error?
        planetsRepository.fetchData(completion: { result in
            switch result {
            case .success(let planets):
                planetsResult = planets
                print("Got planets data")
            case .failure(let err):
                print("Failed to get planets data: \(err)")
                error = err
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        // Then
        XCTAssertNil(planetsResult)
        XCTAssertNotNil(error)
    }
}
