import Foundation
import Combine
import WidgetKit

class F1APIService: ObservableObject {
    @Published var races: [F1Race] = []
    @Published var driverStandings: [F1DriverStanding] = []
    @Published var constructorStandings: [F1ConstructorStanding] = []
    @Published var news: [NewsArticle] = []
    @Published var isLoading = false
    
    private let session = URLSession.shared
    
    private let appGroupID = "group.vaidik.Formula1X"
    private let widgetUpcomingKey = "widget_upcoming_f1_races"
    
    @MainActor
    func fetchF1Data() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let fetchedRaces = fetchF1Races()
            async let fetchedStandings = fetchStandings()
            async let fetchedNews = fetchNews()
            
            let (newRaces, newStandings, newNews) = try await (fetchedRaces, fetchedStandings, fetchedNews)
            self.races = newRaces
            self.driverStandings = newStandings.drivers
            self.constructorStandings = newStandings.constructors
            self.news = newNews
            
            // Share data with Widget via App Group
            if let defaults = UserDefaults(suiteName: appGroupID),
               let widgetData = try? JSONEncoder().encode(newRaces) {
                defaults.set(widgetData, forKey: widgetUpcomingKey)
                // Tell WidgetKit to reload
                WidgetCenter.shared.reloadAllTimelines()
            }
        } catch {
            print("Failed to fetch F1 data: \(error)")
        }
    }
    
    private func fetchF1Races() async throws -> [F1Race] {
        let url = URL(string: "\(APIConfig.racingBaseURL)/races/f1")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let events = try JSONDecoder().decode([RacingServerEvent].self, from: data)
        return events
            .filter { $0.event_name.hasSuffix("Race") }
            .compactMap { $0.toF1Race() }
            .sorted { $0.date < $1.date }
    }
    
    private func fetchStandings() async throws -> F1StandingsResponse {
        let url = URL(string: "\(APIConfig.racingBaseURL)/f1/standings")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(F1StandingsResponse.self, from: data)
    }
    
    private func fetchNews() async throws -> [NewsArticle] {
        let url = URL(string: APIConfig.newsURL)!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return [] // Fail gracefully for news
        }
        
        // Filter F1 news implicitly if possible, or just return all
        return try JSONDecoder().decode([NewsArticle].self, from: data)
    }
}
