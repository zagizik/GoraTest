import Foundation

// MARK: - Photo
struct Photo: Codable {
    let albumID, id: Int?
    let title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
    }
}
