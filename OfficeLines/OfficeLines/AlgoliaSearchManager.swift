import Foundation
import Search

struct AlgoliaConfig {
    let appID: String
    let apiKey: String
    let indexName: String
    
    static func loadFromPlist() -> AlgoliaConfig? {
        guard let url = Bundle.main.url(forResource: "AlgoliaConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String],
              let appID = plist["app-id"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              let apiKey = plist["api-key"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              let indexName = plist["index-name"]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !appID.isEmpty && !apiKey.isEmpty && !indexName.isEmpty,
              !appID.hasPrefix("YOUR_") && !apiKey.hasPrefix("YOUR_") else {
            print("Error: Could not load valid Algolia configuration from plist")
            return nil
        }
        
        return AlgoliaConfig(appID: appID, apiKey: apiKey, indexName: indexName)
    }
}

// Remove the manual AlgoliaSearchResponse and AlgoliaHit structs since we'll use the library's types
// We'll keep only the conversion functionality that we need

struct AlgoliaHit: Codable {
    let id: Int
    let season: Int
    let episode: Int
    let scene: Int
    let lineText: String
    let speaker: String
    let objectID: String
    
    private enum CodingKeys: String, CodingKey {
        case id, season, episode, scene, speaker, objectID
        case lineText = "line_text"
    }
    
    func toOfficeLine() -> OfficeLine {
        return OfficeLine(id: id, season: season, episode: episode, scene: scene, lineText: lineText, speaker: speaker)
    }
}

class AlgoliaSearchManager: ObservableObject {
    private let config: AlgoliaConfig?
    private let searchClient: SearchClient?
    private let searchIndex: SearchIndex?
    
    init() {
        self.config = AlgoliaConfig.loadFromPlist()
        
        if let config = config {
            self.searchClient = SearchClient(appID: ApplicationID(rawValue: config.appID), apiKey: APIKey(rawValue: config.apiKey))
            self.searchIndex = searchClient?.index(withName: IndexName(rawValue: config.indexName))
        } else {
            self.searchClient = nil
            self.searchIndex = nil
            print("Warning: Algolia configuration not loaded. Search will fall back to local data.")
        }
    }
    
    func search(query: String, completion: @escaping (Result<[OfficeLine], Error>) -> Void) {
        guard let searchIndex = searchIndex else {
            // Fallback to sample data if no config
            let sampleResults = OfficeLine.sampleData.filter { line in
                line.lineText.lowercased().contains(query.lowercased()) ||
                line.speaker.lowercased().contains(query.lowercased())
            }
            completion(.success(sampleResults))
            return
        }
        
        guard !query.isEmpty else {
            completion(.success([]))
            return
        }
        
        let searchQuery = Query(query)
        searchQuery.hitsPerPage = 50
        
        searchIndex.search(query: searchQuery) { result in
            switch result {
            case .success(let searchResponse):
                do {
                    // Convert Algolia hits to our custom format
                    let hits = try searchResponse.hits.map { hit -> AlgoliaHit in
                        let hitData = try JSONSerialization.data(withJSONObject: hit.object)
                        return try JSONDecoder().decode(AlgoliaHit.self, from: hitData)
                    }
                    let officeLines = hits.map { $0.toOfficeLine() }
                    completion(.success(officeLines))
                } catch {
                    print("Algolia response decode error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Algolia search error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

enum AlgoliaError: Error, LocalizedError {
    case configurationMissing
    
    var errorDescription: String? {
        switch self {
        case .configurationMissing:
            return "Algolia configuration missing"
        }
    }
}