import Foundation

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

struct AlgoliaSearchResponse: Codable {
    let hits: [AlgoliaHit]
    let nbHits: Int
    let page: Int
    let nbPages: Int
    let hitsPerPage: Int
    let processingTimeMS: Int
    let query: String
}

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
    private let session = URLSession.shared
    
    init() {
        self.config = AlgoliaConfig.loadFromPlist()
        if self.config == nil {
            print("Warning: Algolia configuration not loaded. Search will fall back to local data.")
        }
    }
    
    func search(query: String, completion: @escaping (Result<[OfficeLine], Error>) -> Void) {
        guard let config = config else {
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
        
        let urlString = "https://\(config.appID)-dsn.algolia.net/1/indexes/\(config.indexName)/query"
        guard let url = URL(string: urlString) else {
            completion(.failure(AlgoliaError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(config.appID, forHTTPHeaderField: "X-Algolia-Application-Id")
        request.setValue(config.apiKey, forHTTPHeaderField: "X-Algolia-API-Key")
        
        let searchParams = [
            "query": query,
            "hitsPerPage": 50
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: searchParams)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(AlgoliaError.noData))
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode(AlgoliaSearchResponse.self, from: data)
                let officeLines = searchResponse.hits.map { $0.toOfficeLine() }
                completion(.success(officeLines))
            } catch {
                print("Algolia response decode error: \(error)")
                // Log the raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw Algolia response: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
}

enum AlgoliaError: Error, LocalizedError {
    case invalidURL
    case noData
    case configurationMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Algolia URL"
        case .noData:
            return "No data received from Algolia"
        case .configurationMissing:
            return "Algolia configuration missing"
        }
    }
}