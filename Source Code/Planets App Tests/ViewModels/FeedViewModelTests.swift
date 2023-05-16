import XCTest
@testable import Planets_App

class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    var mockManagedObjectContext: MockContext!
    var mockRepository: MockPlanetsRepository!
    
    override func setUp() {
        super.setUp()
        setupMockContext()
        setupPlanetsRepository()
        viewModel = FeedViewModel(planetsRepository: mockRepository)
    }
    
    private func setupMockContext() {
        mockManagedObjectContext = MockContext(concurrencyType: .privateQueueConcurrencyType)
    }
    
    private func setupPlanetsRepository() {
        let mockAPIClient = MockAPIClient(apiUrl: URL(string: Constants.apiUrl)!)
        mockRepository = MockPlanetsRepository(managedObjectContext: mockManagedObjectContext, apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchFeedContent_Success() {
        
        // Given
        let entity = PlanetModel.entity()
        let planet = PlanetModel(entity: entity, insertInto: self.mockManagedObjectContext)
        planet.name = "Tatooine"
        planet.climate = "arid"
        planet.terrain = "desert"
        planet.population = "2000000"
        let expectedData = [planet]
        mockRepository.fetchDataResult = .success(expectedData)

        // When
        viewModel.fetchFeedContent()

        // Then
        XCTAssertEqual(viewModel.feedContent.count, expectedData.count)
        XCTAssertEqual(viewModel.feedContent, expectedData)
    }
    
    func testFetchFeedContent_Success_EmptyData() {
        // Given
        let emptyData: [PlanetModel] = []
        mockRepository.fetchDataResult = .success(emptyData)
        
        // When
        viewModel.fetchFeedContent()
        
        // Then
        XCTAssertEqual(viewModel.feedContent.count, 0)
        XCTAssertNil(viewModel.errorState)
    }
    
    func testFetchFeedContent_Failure() {
        
        // Given
        let expectedError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        mockRepository.fetchDataResult = .failure(expectedError)
        
        // When
        viewModel.fetchFeedContent()
        
        // Then
        XCTAssertTrue(viewModel.feedContent.isEmpty)
        XCTAssertEqual(viewModel.errorState as NSError?, expectedError)
    }
}
