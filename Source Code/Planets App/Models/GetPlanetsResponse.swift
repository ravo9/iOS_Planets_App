import Foundation

// MARK: - GetPlanetsResponse
struct GetPlanetsResponse: Decodable {
    var results: [PlanetApiModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
