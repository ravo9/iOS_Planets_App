import Foundation
import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var videoTableView: UITableView!
    
    private var feedViewModel : FeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.register(PlanetViewCell.nib(), forCellReuseIdentifier: PlanetViewCell.identifier)
        videoTableView.delegate = self
        videoTableView.dataSource = self
       
        setupViewModel()
        fetchFeedContent()
    }
    
    func setupViewModel(){
        let context = CoreDataManager.shared.backgroundContext()
        let apiUrl = URL.init(string: Constants.apiUrl)!
        let apiClient = APIClient(apiUrl: apiUrl)
        
        self.feedViewModel = FeedViewModel(planetsRepository: PlanetsRepository(managedObjectContext: context, apiClient: apiClient))
        self.feedViewModel.dataFetchingSuccessHandling = {
            self.updateDataSource()
        }
        self.feedViewModel.dataFetchingErrorHandling = {
            self.displayErrorDialog()
        }
    }
    
    func fetchFeedContent(){
        self.feedViewModel.fetchFeedContent()
    }
    
    func updateDataSource(){
        DispatchQueue.main.async {
            self.videoTableView.dataSource = self
            self.videoTableView.reloadData()
        }
    }
    
    func displayErrorDialog() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {_ in
                self.feedViewModel.refresh()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedViewModel.getNumberOfPlanets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = videoTableView.dequeueReusableCell(withIdentifier: PlanetViewCell.identifier, for: indexPath) as! PlanetViewCell
        
        cell.configure(with: feedViewModel.feedContent[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 288.0
    }
}
