import WidgetKit
import SwiftUI

// Use simple hardcoded Theme for widget to ensure independence
struct WidgetTheme {
    static let background = Color(red: 18/255, green: 18/255, blue: 18/255)
    static let salmonPink = Color(red: 227/255, green: 144/255, blue: 140/255)
    static let mustardYellow = Color(red: 221/255, green: 162/255, blue: 59/255)
    static let oliveGreen = Color(red: 160/255, green: 168/255, blue: 122/255)
    static let deepRed = Color(red: 195/255, green: 66/255, blue: 66/255)
    static let lightGrey = Color(red: 205/255, green: 202/255, blue: 202/255)
}

struct F1RaceWidgetModel: Identifiable, Codable {
    let id: String
    let name: String
    let location: String
    let date: Date
}

struct Provider: TimelineProvider {
    // Using the App Group you explicitly created!
    private let appGroupID = "group.vaidik.Formula1X"
    private let widgetUpcomingKey = "widget_upcoming_f1_races"

    func placeholder(in context: Context) -> RaceEntry {
        RaceEntry(date: Date(), nextRace: sampleRace())
    }

    func getSnapshot(in context: Context, completion: @escaping (RaceEntry) -> ()) {
        if context.isPreview {
            // ALWAYS show sample data in the gallery preview
            completion(RaceEntry(date: Date(), nextRace: sampleRace()))
            return
        }
        
        let all = loadSharedRaces()
        if let all = all, !all.isEmpty {
            let upcoming = all.filter { $0.date >= Date() }
            let nextRace = upcoming.first ?? all.last ?? sampleRace()
            completion(RaceEntry(date: Date(), nextRace: nextRace))
        } else {
            completion(RaceEntry(date: Date(), nextRace: sampleRace()))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RaceEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate) ?? currentDate
        
        // If it's a gallery preview, always show mock data so it doesn't look empty!
        if context.isPreview {
            let entry = RaceEntry(date: currentDate, nextRace: sampleRace())
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            return
        }
        
        guard let defaults = UserDefaults(suiteName: appGroupID) else {
            let entry = RaceEntry(date: currentDate, nextRace: nil)
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            return
        }
        
        guard let data = defaults.data(forKey: widgetUpcomingKey) else {
            let entry = RaceEntry(date: currentDate, nextRace: nil)
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            return
        }
        
        do {
            let all = try JSONDecoder().decode([F1RaceWidgetModel].self, from: data)
            if all.isEmpty {
                let entry = RaceEntry(date: currentDate, nextRace: nil)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            } else {
                let upcoming = all.filter { $0.date >= currentDate }
                let nextRace = upcoming.first ?? all.last
                let entry = RaceEntry(date: currentDate, nextRace: nextRace)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            }
        } catch {
            let entry = RaceEntry(date: currentDate, nextRace: nil)
            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
        }
    }
    
    // MARK: - Shared Data Loading
    private func loadSharedRaces() -> [F1RaceWidgetModel]? {
        guard let defaults = UserDefaults(suiteName: appGroupID),
              let data = defaults.data(forKey: widgetUpcomingKey) else {
            return nil
        }
        return try? JSONDecoder().decode([F1RaceWidgetModel].self, from: data)
    }

    private func sampleRace() -> F1RaceWidgetModel {
        F1RaceWidgetModel(id: UUID().uuidString, name: "Monaco Grand Prix", location: "Monaco", date: Date().addingTimeInterval(86400))
    }
}

struct RaceEntry: TimelineEntry {
    let date: Date
    let nextRace: F1RaceWidgetModel?
}

struct Formula1XWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            WidgetTheme.background
            
            if let race = entry.nextRace {
                VStack(spacing: 0) {
                    ZStack(alignment: .leading) {
                        WidgetTheme.salmonPink
                        VStack(alignment: .leading, spacing: 5) {
                            Text("NEXT RACE")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.black.opacity(0.6))
                            
                            Text(race.name.uppercased())
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .fontWidth(.condensed)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                        .padding(15)
                    }
                    
                    HStack(spacing: 0) {
                        ZStack {
                            WidgetTheme.deepRed
                            Text(formatDay(race.date))
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .fontWidth(.condensed)
                                .foregroundColor(.black)
                        }
                        .frame(width: 50)
                        
                        ZStack(alignment: .leading) {
                            WidgetTheme.lightGrey
                            Text(race.location.uppercased())
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .fontWidth(.condensed)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .padding(.horizontal, 10)
                        }
                    }
                    .frame(height: 50)
                }
            } else {
                VStack(spacing: 5) {
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 24))
                        .foregroundColor(WidgetTheme.lightGrey)
                    Text("NO RACES")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(WidgetTheme.lightGrey)
                    Text("Launch app to sync data.")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(WidgetTheme.lightGrey.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    func formatDay(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd\nMMM"
        return df.string(from: date).uppercased()
    }
}

struct Formula1XWidget: Widget {
    let kind: String = "Formula1XWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Formula1XWidgetEntryView(entry: entry)
                    .containerBackground(WidgetTheme.background, for: .widget)
            } else {
                Formula1XWidgetEntryView(entry: entry)
                    .background(WidgetTheme.background)
            }
        }
        .configurationDisplayName("Next F1 Race")
        .description("View the upcoming Formula 1 race in retro style.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    Formula1XWidget()
} timeline: {
    RaceEntry(date: .now, nextRace: F1RaceWidgetModel(id: UUID().uuidString, name: "Monaco Grand Prix", location: "Monaco", date: Date().addingTimeInterval(86400)))
}
