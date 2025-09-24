import Foundation

class CSVParser {
    static func loadOfficeLinesFromBundle() -> [OfficeLine] {
        guard let url = Bundle.main.url(forResource: "the-office-lines", withExtension: "csv") else {
            print("Error: Could not find the-office-lines.csv in app bundle")
            return []
        }
        
        do {
            let csvContent = try String(contentsOf: url)
            return parseOfficeLines(from: csvContent)
        } catch {
            print("Error reading CSV file from bundle: \(error)")
            return []
        }
    }
    
    static func parseOfficeLines(from csvContent: String) -> [OfficeLine] {
        // Remove BOM if present
        let cleanContent = csvContent.hasPrefix("\u{FEFF}") ? String(csvContent.dropFirst()) : csvContent
        let lines = cleanContent.components(separatedBy: .newlines)
        var officeLines: [OfficeLine] = []
        
        // Skip header row
        for (index, line) in lines.enumerated() {
            if index == 0 || line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }
            
            if let officeLine = parseLine(line) {
                officeLines.append(officeLine)
            }
        }
        
        return officeLines
    }
    
    private static func parseLine(_ line: String) -> OfficeLine? {
        let columns = parseCSVLine(line)
        
        guard columns.count >= 6,
              let id = Int(columns[0]),
              let season = Int(columns[1]),
              let episode = Int(columns[2]),
              let scene = Int(columns[3]) else {
            return nil
        }
        
        // Skip deleted lines if there's a "deleted" column
        if columns.count >= 7 {
            let deleted = columns[6].trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if deleted == "TRUE" {
                return nil
            }
        }
        
        let lineText = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
        let speaker = columns[5].trimmingCharacters(in: .whitespacesAndNewlines)
        
        return OfficeLine(id: id, season: season, episode: episode, scene: scene, lineText: lineText, speaker: speaker)
    }
    
    private static func parseCSVLine(_ line: String) -> [String] {
        var columns: [String] = []
        var currentColumn = ""
        var insideQuotes = false
        
        for char in line {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                columns.append(currentColumn)
                currentColumn = ""
            } else {
                currentColumn.append(char)
            }
        }
        
        // Add the last column
        columns.append(currentColumn)
        
        // Remove quotes from columns if they exist
        return columns.map { column in
            let trimmed = column.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("\"") && trimmed.hasSuffix("\"") && trimmed.count > 1 {
                return String(trimmed.dropFirst().dropLast())
            }
            return trimmed
        }
    }
}