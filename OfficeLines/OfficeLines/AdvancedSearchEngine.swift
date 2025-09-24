import Foundation

/// Advanced search engine supporting synonyms, wildcards, and flexible word matching
class AdvancedSearchEngine {
    
    // MARK: - Synonym Dictionary
    private static let synonyms: [String: [String]] = [
        // Common contractions and variations
        "wouldn't": ["would not", "wouldnt", "won't", "wont"],
        "won't": ["will not", "would not", "wouldn't", "wont"],
        "it's": ["it is", "its"],
        "you're": ["you are"],
        "don't": ["do not", "dont"],
        "can't": ["cannot", "can not"],
        "isn't": ["is not"],
        "aren't": ["are not"],
        
        // Understanding synonyms
        "understand": ["get", "comprehend", "grasp", "realize", "see", "know"],
        "get": ["understand", "comprehend", "grasp", "realize", "see", "know"],
        "comprehend": ["understand", "get", "grasp", "realize", "see", "know"],
        "grasp": ["understand", "get", "comprehend", "realize", "see", "know"],
        "realize": ["understand", "get", "comprehend", "grasp", "see", "know"],
        "see": ["understand", "get", "comprehend", "grasp", "realize", "know"],
        "know": ["understand", "get", "comprehend", "grasp", "realize", "see"],
        
        // Secret synonyms
        "secret": ["confidential", "private", "hidden", "classified"],
        "confidential": ["secret", "private", "hidden", "classified"],
        "private": ["secret", "confidential", "hidden", "classified"],
        "hidden": ["secret", "confidential", "private", "classified"],
        
        // Common words
        "said": ["told", "mentioned", "stated", "spoke"],
        "told": ["said", "mentioned", "stated", "spoke"],
        "mentioned": ["said", "told", "stated", "spoke"],
        "stated": ["said", "told", "mentioned", "spoke"],
        "spoke": ["said", "told", "mentioned", "stated"],
        
        // Question words
        "what": ["which", "that"],
        "which": ["what", "that"],
        "that": ["what", "which"],
        
        // Common replacements
        "awesome": ["great", "amazing", "fantastic", "wonderful"],
        "great": ["awesome", "amazing", "fantastic", "wonderful"],
        "amazing": ["awesome", "great", "fantastic", "wonderful"],
        "fantastic": ["awesome", "great", "amazing", "wonderful"],
        "wonderful": ["awesome", "great", "amazing", "fantastic"]
    ]
    
    // MARK: - Public Methods
    
    /// Performs advanced search on office lines with synonym support and flexible matching
    /// - Parameters:
    ///   - lines: Array of office lines to search
    ///   - searchText: Search query
    /// - Returns: Array of matching office lines
    static func search(lines: [OfficeLine], searchText: String) -> [OfficeLine] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        let processedQuery = preprocessSearchQuery(searchText)
        
        return lines.filter { line in
            matchesLine(line: line, query: processedQuery)
        }
    }
    
    // MARK: - Private Methods
    
    /// Preprocesses the search query to handle wildcards and create search terms
    private static func preprocessSearchQuery(_ query: String) -> SearchQuery {
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Check if it's a phrase search (contains quotes)
        if cleanQuery.contains("\"") {
            let phrase = cleanQuery.replacingOccurrences(of: "\"", with: "")
            return SearchQuery(originalText: query, isPhrase: true, words: [phrase], expandedWords: expandWithSynonyms([phrase]))
        }
        
        // Split into words and handle wildcards
        let words = cleanQuery.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        let expandedWords = expandWithSynonyms(words)
        
        return SearchQuery(originalText: query, isPhrase: false, words: words, expandedWords: expandedWords)
    }
    
    /// Expands words with their synonyms
    private static func expandWithSynonyms(_ words: [String]) -> [String] {
        var expanded = Set<String>()
        
        for word in words {
            // Add the original word
            expanded.insert(word)
            
            // Add synonyms
            if let synonymList = synonyms[word] {
                synonymList.forEach { expanded.insert($0) }
            }
            
            // Handle wildcards - if word contains *, we'll handle it in matching
            if word.contains("*") {
                expanded.insert(word)
            }
        }
        
        return Array(expanded)
    }
    
    /// Checks if a line matches the search query
    private static func matchesLine(line: OfficeLine, query: SearchQuery) -> Bool {
        let lineText = line.lineText.lowercased()
        let speaker = line.speaker.lowercased()
        let searchableText = "\(lineText) \(speaker)"
        
        if query.isPhrase {
            // For phrase matching, check if any expanded phrase matches
            return query.expandedWords.contains { expandedPhrase in
                matchesPhrase(text: searchableText, phrase: expandedPhrase)
            }
        } else {
            // For word matching, all words must be found (flexible order)
            return query.words.allSatisfy { word in
                matchesWord(text: searchableText, word: word, synonyms: query.expandedWords)
            }
        }
    }
    
    /// Checks if text matches a phrase (allowing for synonyms)
    private static func matchesPhrase(text: String, phrase: String) -> Bool {
        // Direct substring match
        if text.contains(phrase) {
            return true
        }
        
        // Try with word boundaries for better matching
        let words = phrase.components(separatedBy: .whitespacesAndNewlines)
        if words.count > 1 {
            // For multi-word phrases, check if all words appear in order with reasonable distance
            return matchesOrderedWords(text: text, words: words)
        }
        
        return false
    }
    
    /// Checks if a word (or its synonyms) appears in the text
    private static func matchesWord(text: String, word: String, synonyms: [String]) -> Bool {
        // Handle wildcard matching
        if word.contains("*") {
            return matchesWildcard(text: text, pattern: word)
        }
        
        // Check if the original word appears in text
        if text.contains(word) {
            return true
        }
        
        // Check if any synonyms of this word appear in the text
        if let wordSynonyms = self.synonyms[word] {
            return wordSynonyms.contains { synonym in
                text.contains(synonym)
            }
        }
        
        return false
    }
    
    /// Checks if words appear in text in order (with some flexibility)
    private static func matchesOrderedWords(text: String, words: [String]) -> Bool {
        let textWords = text.components(separatedBy: .whitespacesAndNewlines)
        var searchIndex = 0
        
        for textWord in textWords {
            if searchIndex < words.count && textWord.contains(words[searchIndex]) {
                searchIndex += 1
            }
        }
        
        return searchIndex == words.count
    }
    
    /// Handles wildcard pattern matching
    private static func matchesWildcard(text: String, pattern: String) -> Bool {
        // Convert wildcard pattern to regex
        let regexPattern = pattern
            .replacingOccurrences(of: "*", with: ".*")
            .replacingOccurrences(of: "?", with: ".")
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: text.utf16.count)
            return regex.firstMatch(in: text, options: [], range: range) != nil
        } catch {
            // Fallback to simple contains if regex fails
            return text.contains(pattern.replacingOccurrences(of: "*", with: ""))
        }
    }
}

// MARK: - Supporting Types

/// Represents a processed search query
private struct SearchQuery {
    let originalText: String
    let isPhrase: Bool
    let words: [String]
    let expandedWords: [String]
}