import SwiftUI

struct RaceDetailContainerView: View {
    let race: F1Race
    let color: Color
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Top Hero section (matches middle screen in design)
                VStack(spacing: 0) {
                    // Top block
                    ZStack {
                        color
                        VStack(alignment: .leading) {
                            let yearStr = Formatter.year.string(from: race.date)
                            HStack(alignment: .top) {
                                Text(yearStr)
                                    .retroFont(size: 90, isTitle: true)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 40)
                            
                            Divider().background(Color.black)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: -10) {
                                Text(race.location.uppercased())
                                    .retroFont(size: 40)
                                    .foregroundColor(.black)
                                    .opacity(0.5) // Like the outlined text in "BMW"
                                Text(race.name.uppercased())
                                    .retroFont(size: 60, isTitle: true)
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Middle Image block
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 150)
                        .overlay(
                            // Placeholder image block since we don't have images
                            ZStack {
                                Color(hex: "1A1A1A")
                                Image(systemName: "flag.checkered")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(color)
                                    .opacity(0.5)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    
                    // Bottom blocks
                    HStack(spacing: 20) {
                        ZStack {
                            Theme.deepRed
                            Image(systemName: "equal")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(.black)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        ZStack {
                            color
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("CIRCUIT DETAILS")
                                        .retroFont(size: 12)
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                                    Text(race.circuit?.uppercased() ?? "UNKNOWN")
                                        .retroFont(size: 20, isTitle: true)
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Circle()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "map.fill")
                                            .foregroundColor(.black)
                                    )
                            }
                            .padding(.horizontal, 15)
                        }
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                
                // Detailed Grid Section (matches rightmost screen)
                VStack(spacing: 0) {
                    // Title block
                    ZStack {
                        Theme.lightGrey
                        HStack {
                            Text(race.name.uppercased())
                                .retroFont(size: 50, isTitle: true)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .minimumScaleFactor(0.3)
                            Spacer()
                            Image(systemName: "arrow.down")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Grid row 1
                    HStack(spacing: 20) {
                        InfoBlock(color: Theme.oliveGreen, title: "Location", value: race.location.uppercased())
                        InfoBlock(color: color, title: "Date", value: Formatter.date.string(from: race.date).uppercased())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Large Grid row 2
                    ZStack {
                        Theme.deepRed
                        VStack(spacing: 0) {
                            HStack {
                                Text("CIRCUIT")
                                    .retroFont(size: 14)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.top, 15)
                            .padding(.horizontal, 20)
                            
                            HStack {
                                Text(race.circuit?.uppercased() ?? "TBA")
                                    .retroFont(size: 40, isTitle: true)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            
                            Divider().background(Color.black)
                            
                            HStack(spacing: 0) {
                                VStack(alignment: .leading) {
                                    Text("Status")
                                        .retroFont(size: 14)
                                        .foregroundColor(.black)
                                    Text("OFFICIAL")
                                        .retroFont(size: 24, isTitle: true)
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Rectangle().fill(Color.black).frame(width: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("Type")
                                        .retroFont(size: 14)
                                        .foregroundColor(.black)
                                    Text("RACE")
                                        .retroFont(size: 24, isTitle: true)
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Story / Text block
                    ZStack(alignment: .topLeading) {
                        Theme.lightGrey
                        
                        Text(AttributedString("T"))
                            .font(.system(size: 60, weight: .black, design: .serif))
                            .foregroundColor(.black)
                            .baselineOffset(-10) // Faux Drop Cap
                        
                        Text("     he \(race.name) is a highly anticipated event in the Formula 1 calendar, taking place in \(race.location). The circuit \(race.circuit ?? "") challenges drivers with complex corners and high-speed straights. \n\nFans eagerly await this race, as it often provides thrilling overtakes and unpredictable weather conditions.")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.black)
                            .padding(20)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Theme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct InfoBlock: View {
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            color
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .retroFont(size: 12)
                    .foregroundColor(.black)
                Text(value)
                    .retroFont(size: 30, isTitle: true)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(15)
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
