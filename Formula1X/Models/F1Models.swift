import Foundation

struct F1Race: Identifiable, Codable {
    let id: String
    let name: String
    let date: Date
    let location: String
    let circuit: String?
}

struct RacingServerEvent: Codable {
    let id: String
    let series: String
    let event_name: String
    let circuit: String
    let date: String
    let country: String
    let season: String
    let round: Int?
    let description: String?
    
    func toF1Race() -> F1Race? {
        let formatter = ISO8601DateFormatter()
        guard let eventDate = formatter.date(from: date) else { return nil }
        
        return F1Race(
            id: id,
            name: event_name,
            date: eventDate,
            location: country,
            circuit: circuit.isEmpty ? nil : circuit
        )
    }
}

struct F1DriverStanding: Identifiable, Codable {
    let id = UUID()
    let position: Int
    let driverNumber: Int
    let points: Double

    enum CodingKeys: String, CodingKey {
        case position, points
        case driverNumber = "driver_number"
    }
    
    var driverName: String {
        switch driverNumber {
        case 1: return "Max Verstappen"
        case 3: return "Daniel Ricciardo"
        case 4: return "Lando Norris"
        case 6: return "Nicholas Latifi"
        case 10: return "Pierre Gasly"
        case 11: return "Sergio Perez"
        case 12: return "Andrea Kimi Antonelli"
        case 14: return "Fernando Alonso"
        case 16: return "Charles Leclerc"
        case 18: return "Lance Stroll"
        case 20: return "Kevin Magnussen"
        case 22: return "Yuki Tsunoda"
        case 23: return "Alexander Albon"
        case 24: return "Zhou Guanyu"
        case 27: return "Nico Hulkenberg"
        case 30: return "Liam Lawson"
        case 31: return "Esteban Ocon"
        case 41: return "Jack Doohan"
        case 43: return "Franco Colapinto"
        case 44: return "Lewis Hamilton"
        case 55: return "Carlos Sainz"
        case 63: return "George Russell"
        case 77: return "Valtteri Bottas"
        case 81: return "Oscar Piastri"
        case 87: return "Isack Hadjar"
        default: return "Driver #\(driverNumber)"
        }
    }
}

struct F1ConstructorStanding: Identifiable, Codable {
    let id = UUID()
    let position: Int
    let teamName: String
    let points: Double

    enum CodingKeys: String, CodingKey {
        case position, points
        case teamName = "team_name"
    }
}

struct F1StandingsResponse: Codable {
    let drivers: [F1DriverStanding]
    let constructors: [F1ConstructorStanding]
}
