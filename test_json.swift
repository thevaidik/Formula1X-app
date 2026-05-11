import Foundation

struct F1Race: Identifiable, Codable {
    let id: String
    let name: String
    let date: Date
    let location: String
    let circuit: String?
}

struct F1RaceWidgetModel: Identifiable, Codable {
    let id: String
    let name: String
    let location: String
    let date: Date
}

let race = F1Race(id: "123", name: "Test Race", date: Date(), location: "Test Loc", circuit: "Test Circ")
do {
    let data = try JSONEncoder().encode([race])
    let decoded = try JSONDecoder().decode([F1RaceWidgetModel].self, from: data)
    print("SUCCESS: \(decoded)")
} catch {
    print("ERROR: \(error)")
}
