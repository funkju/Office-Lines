//
//  OfficeLinesTests.swift
//  OfficeLinesTests
//
//  Created by Justin Funk on 9/24/25.
//

import Testing
@testable import OfficeLines

struct OfficeLinesTests {

    @Test func testCSVParsingWithBOM() async throws {
        let csvContent = "\u{FEFF}id,season,episode,scene,line_text,speaker,deleted\n1,1,1,1,\"Test line\",\"Test Speaker\",FALSE"
        let lines = CSVParser.parseOfficeLines(from: csvContent)
        
        #expect(lines.count == 1)
        #expect(lines[0].id == 1)
        #expect(lines[0].lineText == "Test line")
        #expect(lines[0].speaker == "Test Speaker")
    }
    
    @Test func testCSVParsingFiltersDeleted() async throws {
        let csvContent = "id,season,episode,scene,line_text,speaker,deleted\n1,1,1,1,\"Keep this\",\"Speaker1\",FALSE\n2,1,1,2,\"Delete this\",\"Speaker2\",TRUE"
        let lines = CSVParser.parseOfficeLines(from: csvContent)
        
        #expect(lines.count == 1)
        #expect(lines[0].lineText == "Keep this")
    }
    
    @Test func testLoadFromBundle() async throws {
        let lines = CSVParser.loadOfficeLinesFromBundle()
        #expect(lines.count > 0, "Should load lines from bundle")
    }
    
    @Test func testAlgoliaConfigLoading() async throws {
        // Test that the config can be loaded (will be nil in test environment without proper plist)
        let config = AlgoliaConfig.loadFromPlist()
        // In test environment, we expect this to be nil since we don't have valid config
        // but we should not crash
        #expect(config == nil || (config?.appID.count ?? 0) > 0, "Config should be nil or valid")
    }
    
    @Test func testAlgoliaSearchManagerInitialization() async throws {
        let manager = AlgoliaSearchManager()
        // Should initialize without crashing
        #expect(manager != nil, "AlgoliaSearchManager should initialize")
    }
    
    @Test func testAlgoliaHitConversion() async throws {
        let hit = AlgoliaHit(
            id: 1,
            season: 2,
            episode: 3,
            scene: 4,
            lineText: "Test line",
            speaker: "Test Speaker",
            objectID: "test_123"
        )
        
        let officeLine = hit.toOfficeLine()
        #expect(officeLine.id == 1)
        #expect(officeLine.season == 2)
        #expect(officeLine.episode == 3)
        #expect(officeLine.scene == 4)
        #expect(officeLine.lineText == "Test line")
        #expect(officeLine.speaker == "Test Speaker")
    }

}
