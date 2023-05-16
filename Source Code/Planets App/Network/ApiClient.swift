import Foundation

// MARK: - APIClient
class APIClient :  NSObject {
    
    private let apiUrl: URL
    
    init(apiUrl: URL) {
        self.apiUrl = apiUrl
    }
    
    func getPlanets(completion : @escaping (GetPlanetsResponse) -> (),
                   errorHandling : @escaping (Error) -> ()){
        URLSession.shared.dataTask(with: apiUrl) { (data, urlResponse, error) in
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let receivedData = try! jsonDecoder.decode(GetPlanetsResponse.self, from: data)
                completion(receivedData)
            }
            
            if let error = error {
                print("apiClient.getPlanets error: " + error.localizedDescription)
                errorHandling(error)
            }
            
        }.resume()
    }
}
