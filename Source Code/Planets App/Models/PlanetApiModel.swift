import Foundation

// MARK: - PlanetApiModel
struct PlanetApiModel: Decodable {
    
    let name: String
    
    let climate: String
    
    let terrain: String
    
    let population: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case climate
        case terrain
        case population
    }
}
