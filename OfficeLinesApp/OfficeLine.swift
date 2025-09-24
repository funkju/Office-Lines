import Foundation

struct OfficeLine: Identifiable, Codable {
    let id: Int
    let season: Int
    let episode: Int
    let scene: Int
    let lineText: String
    let speaker: String
    
    var displayText: String {
        "S\(season)E\(episode) - \(speaker): \(lineText)"
    }
    
    var copyText: String {
        lineText
    }
}

extension OfficeLine {
    static let sampleData: [OfficeLine] = [
        OfficeLine(id: 1, season: 1, episode: 1, scene: 1, lineText: "That's what she said!", speaker: "Michael Scott"),
        OfficeLine(id: 2, season: 1, episode: 1, scene: 2, lineText: "Bears. Beets. Battlestar Galactica.", speaker: "Jim Halpert"),
        OfficeLine(id: 3, season: 1, episode: 2, scene: 1, lineText: "I DECLARE BANKRUPTCY!", speaker: "Michael Scott"),
        OfficeLine(id: 4, season: 2, episode: 1, scene: 1, lineText: "Dwight, you ignorant slut!", speaker: "Michael Scott"),
        OfficeLine(id: 5, season: 2, episode: 3, scene: 2, lineText: "Identity theft is not a joke, Jim!", speaker: "Dwight Schrute")
    ]
}