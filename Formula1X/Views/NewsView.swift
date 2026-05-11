import SwiftUI

struct NewsView: View {
    @StateObject private var apiService = F1APIService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                if apiService.isLoading {
                    ProgressView().tint(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            HStack {
                                Text("LATEST NEWS")
                                    .retroFont(size: 40, isTitle: true)
                                    .foregroundColor(Theme.salmonPink)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                            
                            ForEach(apiService.news) { article in
                                NewsArticleRow(article: article)
                            }
                        }
                    }
                }
            }
            .task {
                if apiService.news.isEmpty {
                    await apiService.fetchF1Data()
                }
            }
        }
    }
}

struct NewsArticleRow: View {
    let article: NewsArticle
    
    var body: some View {
        Link(destination: URL(string: article.articleUrl) ?? URL(string: "https://formula1.com")!) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    Theme.deepRed
                    HStack {
                        Text(article.source.uppercased())
                            .retroFont(size: 14)
                            .foregroundColor(.black)
                        Spacer()
                        Text(article.formattedDate.uppercased())
                            .retroFont(size: 14)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 40)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15))
                
                ZStack(alignment: .topLeading) {
                    Theme.lightGrey
                    VStack(alignment: .leading, spacing: 10) {
                        Text(article.title)
                            .retroFont(size: 24, isTitle: true)
                            .foregroundColor(.black)
                            .lineLimit(3)
                        
                        Text(article.summary)
                            .retroFont(size: 16)
                            .foregroundColor(.black)
                            .opacity(0.8)
                            .lineLimit(4)
                    }
                    .padding(20)
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 0))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
