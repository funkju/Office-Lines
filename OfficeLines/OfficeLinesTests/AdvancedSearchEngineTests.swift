import Testing
@testable import OfficeLines

struct AdvancedSearchEngineTests {
    
    // Test data based on the issue requirements
    private let testLines = [
        OfficeLine(id: 1, season: 1, episode: 1, scene: 1, 
                  lineText: "You wouldn't understand. It's a secret", 
                  speaker: "Jim Halpert"),
        OfficeLine(id: 2, season: 1, episode: 2, scene: 1, 
                  lineText: "That's what she said!", 
                  speaker: "Michael Scott"),
        OfficeLine(id: 3, season: 2, episode: 1, scene: 1, 
                  lineText: "Bears. Beets. Battlestar Galactica.", 
                  speaker: "Jim Halpert"),
        OfficeLine(id: 4, season: 1, episode: 3, scene: 2, 
                  lineText: "I don't get it, but it's confidential", 
                  speaker: "Dwight Schrute"),
        OfficeLine(id: 5, season: 2, episode: 2, scene: 1, 
                  lineText: "Identity theft is not a joke, Jim!", 
                  speaker: "Dwight Schrute")
    ]
    
    @Test func testBasicWordMatching() async throws {
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "secret")
        
        #expect(results.count == 1)
        #expect(results[0].lineText.contains("secret"))
    }
    
    @Test func testSynonymMatching() async throws {
        // "get" should match "understand" via synonyms
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "get")
        
        // Should find both lines: one with "understand" and one with "get"
        #expect(results.count == 2)
        
        let lineTexts = results.map { $0.lineText }
        #expect(lineTexts.contains("You wouldn't understand. It's a secret"))
        #expect(lineTexts.contains("I don't get it, but it's confidential"))
    }
    
    @Test func testFlexibleWordOrder() async throws {
        // "understand secret" should match "You wouldn't understand. It's a secret"
        let results1 = AdvancedSearchEngine.search(lines: testLines, searchText: "understand secret")
        #expect(results1.count == 1)
        #expect(results1[0].lineText == "You wouldn't understand. It's a secret")
        
        // "secret understand" should also match the same line
        let results2 = AdvancedSearchEngine.search(lines: testLines, searchText: "secret understand")
        #expect(results2.count == 1)
        #expect(results2[0].lineText == "You wouldn't understand. It's a secret")
    }
    
    @Test func testSynonymPhrasematching() async throws {
        // "You wouldn't get it, it's a secret" should match via synonyms
        // "get" is synonym for "understand", "it's" matches "it's"
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "get secret")
        
        // Should match both lines with understand/get and secret/confidential
        #expect(results.count >= 1)
        
        let lineTexts = results.map { $0.lineText }
        #expect(lineTexts.contains("You wouldn't understand. It's a secret") || 
                lineTexts.contains("I don't get it, but it's confidential"))
    }
    
    @Test func testExactPhraseMatching() async throws {
        // "it's a secret" should match exactly
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "\"it's a secret\"")
        
        #expect(results.count == 1)
        #expect(results[0].lineText == "You wouldn't understand. It's a secret")
    }
    
    @Test func testWildcardMatching() async throws {
        // Test wildcard matching
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "secret*")
        
        #expect(results.count >= 1)
        #expect(results.map { $0.lineText }.contains("You wouldn't understand. It's a secret"))
    }
    
    @Test func testSpeakerMatching() async throws {
        // Should match by speaker name
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "Jim")
        
        #expect(results.count == 2) // Two lines by Jim Halpert
        
        let speakers = results.map { $0.speaker }
        #expect(speakers.allSatisfy { $0.contains("Jim") })
    }
    
    @Test func testEmptySearch() async throws {
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "")
        #expect(results.isEmpty)
        
        let results2 = AdvancedSearchEngine.search(lines: testLines, searchText: "   ")
        #expect(results2.isEmpty)
    }
    
    @Test func testNoMatch() async throws {
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "nonexistentword")
        #expect(results.isEmpty)
    }
    
    @Test func testCaseInsensitive() async throws {
        let results1 = AdvancedSearchEngine.search(lines: testLines, searchText: "SECRET")
        let results2 = AdvancedSearchEngine.search(lines: testLines, searchText: "secret")
        let results3 = AdvancedSearchEngine.search(lines: testLines, searchText: "Secret")
        
        #expect(results1.count == results2.count)
        #expect(results2.count == results3.count)
        #expect(results1.count > 0)
    }
    
    @Test func testMultipleWordRequirement() async throws {
        // All words must be present (flexible order)
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "understand secret")
        
        #expect(results.count == 1)
        #expect(results[0].lineText == "You wouldn't understand. It's a secret")
        
        // Should not match lines that only have one of the words
        let singleWordResults = AdvancedSearchEngine.search(lines: testLines, searchText: "understand nonexistent")
        #expect(singleWordResults.isEmpty)
    }
    
    @Test func testContractionSynonyms() async throws {
        // Test contraction synonyms
        let results1 = AdvancedSearchEngine.search(lines: testLines, searchText: "wouldn't")
        let results2 = AdvancedSearchEngine.search(lines: testLines, searchText: "would not")
        
        #expect(results1.count > 0)
        #expect(results1.count == results2.count)
    }
    
    @Test func testSynonymExpansion() async throws {
        // "confidential" should match "secret" via synonyms
        let results = AdvancedSearchEngine.search(lines: testLines, searchText: "secret")
        
        let confidentialResults = results.filter { $0.lineText.contains("confidential") }
        #expect(confidentialResults.count > 0, "Should find lines with 'confidential' when searching for 'secret'")
    }
}