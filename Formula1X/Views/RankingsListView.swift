import SwiftUI

struct RankingsListView: View {
    let drivers: [F1DriverStanding]
    let constructors: [F1ConstructorStanding]
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Segmented Control
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        ZStack {
                            selectedTab == 0 ? Theme.mustardYellow : Theme.lightGrey
                            Text("DRIVERS")
                                .retroFont(size: 30, isTitle: true)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Button(action: { selectedTab = 1 }) {
                        ZStack {
                            selectedTab == 1 ? Theme.mustardYellow : Theme.lightGrey
                            Text("TEAMS")
                                .retroFont(size: 30, isTitle: true)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if selectedTab == 0 {
                            ForEach(drivers) { driver in
                                DriverRow(driver: driver)
                            }
                        } else {
                            ForEach(constructors) { constructor in
                                ConstructorRow(constructor: constructor)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DriverRow: View {
    let driver: F1DriverStanding
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Theme.oliveGreen
                Text("\(driver.position)")
                    .retroFont(size: 40, isTitle: true)
                    .foregroundColor(.black)
            }
            .frame(width: 80, height: 80)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0))
            
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
    }
}

struct ConstructorRow: View {
    let constructor: F1ConstructorStanding
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Theme.salmonPink
                Text("\(constructor.position)")
                    .retroFont(size: 40, isTitle: true)
                    .foregroundColor(.black)
            }
            .frame(width: 80, height: 80)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0))
            
            ZStack(alignment: .leading) {
                Theme.lightGrey
                HStack {
                    Text(constructor.teamName)
                        .retroFont(size: 30, isTitle: true)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Text("\(Int(constructor.points)) PTS")
                        .retroFont(size: 24, isTitle: true)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 80)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
        }
    }
}
