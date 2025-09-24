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

}
