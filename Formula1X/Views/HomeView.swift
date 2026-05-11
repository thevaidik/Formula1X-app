import SwiftUI

struct HomeView: View {
    @StateObject private var apiService = F1APIService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                if apiService.isLoading {
                    ProgressView()
                        .tint(.white)
                } else if !apiService.races.isEmpty {
                    let currentDate = Date()
                    let upcomingRaces = apiService.races.filter { $0.date >= currentDate }
                    // Fallback to the last race if the season is over
                    let nextRace = upcomingRaces.first ?? apiService.races.last!
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Top Navigation Header
                            HStack {
                                Text("FORMULA1X")
                                    .retroFont(size: 24, isTitle: true)
                                    .foregroundColor(Theme.lightGrey)
                                Spacer()
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(Theme.lightGrey)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            
                            // Center Image Inspiration - Next Race Hero
                            NextRaceHeroView(race: nextRace)
                            
                            // Season Progress
                            SeasonProgressView(
                                totalRaces: apiService.races.count,
                                completedRaces: apiService.races.filter { $0.date < currentDate }.count
                            )
                            
                            // News Link Section
                            NewsSectionView()
                            
                            // Rankings Section
                            if !apiService.driverStandings.isEmpty {
                                RankingsSectionView(
                                    drivers: apiService.driverStandings,
                                    constructors: apiService.constructorStandings
                                )
                            }
                            
                            // Full Schedule Section
                            if upcomingRaces.count > 1 {
                                ScheduleSectionView(races: Array(upcomingRaces.dropFirst()))
                            }
                        }
                        .padding(.bottom, 50)
                    }
                } else {
                    Text("No F1 Data Found")
                        .foregroundColor(.white)
                        .retroFont(size: 20)
                }
            }
            .task {
                if apiService.races.isEmpty {
                    await apiService.fetchF1Data()
                }
            }
        }
    }
}

struct NextRaceHeroView: View {
    let race: F1Race
    
    var body: some View {
        NavigationLink(destination: RaceDetailContainerView(race: race, color: Theme.salmonPink)) {
            VStack(spacing: 0) {
                // Top Pink Block
                ZStack(alignment: .topLeading) {
                    Theme.salmonPink
                    
                    VStack(alignment: .leading, spacing: 0) {
                        let yearStr = Formatter.year.string(from: race.date)
                        HStack(alignment: .top) {
                            Text(yearStr)
                                .retroFont(size: 110, isTitle: true) // Very large, condensed
                                .foregroundColor(.black)
                                .layoutPriority(1)
                            Spacer()
                            Image(systemName: "arrow.up")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(.black)
                                .padding(.top, 25)
                        }
                        
                        Divider().background(Color.black)
                            .padding(.vertical, 10)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: -10) {
                            Text("NEXT RACE")
                                .retroFont(size: 40)
                                .foregroundColor(.black)
                                .opacity(0.3)
                            Text(race.name.uppercased())
                                .retroFont(size: 55, isTitle: true)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(20)
                }
                .frame(height: 380)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                
                // Removed Full Width Image Placeholder to keep the card compact
                
                // Bottom Two Blocks
                HStack(spacing: 0) {
                    // Left Block (Red)
                    ZStack {
                        Theme.deepRed
                        Image(systemName: "equal")
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(.black)
                    }
                    .frame(width: 100)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 0, topTrailingRadius: 0))
                    
                    // Right Block (Pink)
                    ZStack(alignment: .leading) {
                        Theme.salmonPink
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Location & Track")
                                    .retroFont(size: 14)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                Text(race.location.uppercased())
                                    .retroFont(size: 24, isTitle: true)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(width: 55, height: 55)
                                Text(Formatter.date.string(from: race.date).uppercased().replacingOccurrences(of: " ", with: "\n"))
                                    .retroFont(size: 16, isTitle: true)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 20, topTrailingRadius: 0))
                }
                .frame(height: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RankingsSectionView: View {
    let drivers: [F1DriverStanding]
    let constructors: [F1ConstructorStanding]
    
    var body: some View {
        NavigationLink(destination: RankingsListView(drivers: drivers, constructors: constructors)) {
            VStack(spacing: 0) {
                // Header
                ZStack {
                    Theme.lightGrey
                    HStack {
                        Text("WORLD RANKINGS")
                            .retroFont(size: 40, isTitle: true)
                            .foregroundColor(.black)
                        Spacer()
                        Text("SEE ALL")
                            .retroFont(size: 14)
                            .foregroundColor(.black)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            // Top 3 Drivers
            VStack(spacing: 10) {
                ForEach(drivers.prefix(3)) { driver in
                    HStack(spacing: 0) {
                        // Position Box
                        ZStack {
                            Theme.oliveGreen
                            Text("\(driver.position)")
                                .retroFont(size: 40, isTitle: true)
                                .foregroundColor(.black)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0))
                        
                        // Details Box
                        ZStack(alignment: .leading) {
                            Theme.mustardYellow
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Driver #\(driver.driverNumber)")
                                        .retroFont(size: 14)
                                        .foregroundColor(.black)
                                        .opacity(0.7)
                                    Text(driver.driverName)
                                        .retroFont(size: 30, isTitle: true)
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                                Spacer()
                                Text("\(Int(driver.points)) PTS")
                                    .retroFont(size: 24, isTitle: true)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 80)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 40)
        }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScheduleSectionView: View {
    let races: [F1Race]
    let colors: [Color] = [Theme.mustardYellow, Theme.salmonPink, Theme.oliveGreen, Theme.deepRed]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Theme.deepRed
                HStack {
                    Text("FULL SCHEDULE")
                        .retroFont(size: 40, isTitle: true)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(races.enumerated()), id: \.element.id) { index, race in
                        let color = colors[index % colors.count]
                        NavigationLink(destination: RaceDetailContainerView(race: race, color: color)) {
                            ZStack(alignment: .topLeading) {
                                color
                                VStack(alignment: .leading) {
                                    Text(Formatter.date.string(from: race.date).uppercased())
                                        .retroFont(size: 20, isTitle: true)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(race.location.uppercased())
                                        .retroFont(size: 30, isTitle: true)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(15)
                            }
                            .frame(width: 160, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct NewsSectionView: View {
    var body: some View {
        NavigationLink(destination: NewsView()) {
            ZStack {
                Theme.oliveGreen
                HStack {
                    Text("LATEST NEWS")
                        .retroFont(size: 40, isTitle: true)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SeasonProgressView: View {
    let totalRaces: Int
    let completedRaces: Int
    
    var progress: Double {
        guard totalRaces > 0 else { return 0 }
        return Double(completedRaces) / Double(totalRaces)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("SEASON PROGRESS")
                    .retroFont(size: 20, isTitle: true)
                    .foregroundColor(Theme.lightGrey)
                Spacer()
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Track
                    Theme.lightGrey.opacity(0.2)
                    
                    // Filled Track
                    Theme.mustardYellow
                        .frame(width: geometry.size.width * CGFloat(progress))
                }
            }
            .frame(height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Text("\(Int(progress * 100))% COMPLETED")
                    .retroFont(size: 14)
                    .foregroundColor(Theme.lightGrey.opacity(0.7))
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

class Formatter {
    static let year: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        return df
    }()
    
    static let date: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        return df
    }()
}
