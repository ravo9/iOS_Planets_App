import Foundation

// MARK: - FeedViewModel
class FeedViewModel : NSObject {
    
    private var planetsRepository : PlanetsRepository!
    
    var feedContent : [PlanetModel] = []  {
        didSet {
            self.dataFetchingSuccessHandling()
        }
    }
    
    var errorState : Error? {
        didSet {
            self.dataFetchingErrorHandling()
        }
    }
    
    var dataFetchingSuccessHandling : (() -> ()) = {}
    var dataFetchingErrorHandling : (() -> ()) = {}
    
    init(planetsRepository: PlanetsRepository) {
        self.planetsRepository = planetsRepository
    }
    
    func fetchFeedContent() {
        self.planetsRepository.fetchData(completion: { result in
            switch result {
                case .success(let fetchedData):
                    self.feedContent = fetchedData
                case .failure(let error):
                    print("feedViewModel.fetchFeedContent error: " + error.localizedDescription)
                    self.errorState = error
            }
        })
    }
    
    func refresh() {
        fetchFeedContent()
    }
    
    func getNumberOfPlanets() -> Int {
        return feedContent.count
    }
    
}
