import Foundation

struct NewsArticle: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let summary: String
    let imageUrl: String?
    let articleUrl: String
    let publishedAt: String
    let source: String
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: publishedAt) {
            let relativeFormatter = RelativeDateTimeFormatter()
            relativeFormatter.unitsStyle = .short
            return relativeFormatter.localizedString(for: date, relativeTo: Date())
        }
        return publishedAt
    }
}
