import SwiftUI
import AppKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var officeLines: [OfficeLine] = []
    @State private var filteredLines: [OfficeLine] = []
    @State private var isDataLoaded = false
    @State private var selectedLine: OfficeLine?
    @State private var copyFeedback = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("The Office Lines Search")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            if isDataLoaded {
                // Search box
                VStack(alignment: .leading, spacing: 8) {
                    Text("Advanced Search for Office lines:")
                        .font(.headline)
                    
                    TextField("Search with synonyms, wildcards, flexible word order...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 14))
                        .onChange(of: searchText) { _, newValue in
                            filterLines(with: newValue)
                        }
                    
                    if !copyFeedback.isEmpty {
                        Text(copyFeedback)
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                
                // Results
                if !filteredLines.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(filteredLines.prefix(50)) { line in
                                LineResultView(line: line) {
                                    copyToClipboard(line.copyText)
                                    selectedLine = line
                                    showCopyFeedback(for: line)
                                }
                                .background(selectedLine?.id == line.id ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(4)
                            }
                            
                            if filteredLines.count > 50 {
                                Text("Showing first 50 results of \(filteredLines.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                } else if !searchText.isEmpty {
                    Text("No lines found matching '\(searchText)'")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Text("Type in the search box to find Office lines")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
                
                // Statistics
                HStack {
                    Text("Total lines loaded: \(officeLines.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if !searchText.isEmpty {
                        Text("Found: \(filteredLines.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
            } else {
                // Loading message
                VStack(spacing: 16) {
                    Image(systemName: "tv.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Loading The Office Lines...")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .padding(40)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            loadOfficeLines()
        }
    }
    
    private func filterLines(with searchText: String) {
        if searchText.isEmpty {
            filteredLines = []
        } else {
            // Use the new AdvancedSearchEngine for enhanced search capabilities
            filteredLines = AdvancedSearchEngine.search(lines: officeLines, searchText: searchText)
        }
    }
    
    private func loadOfficeLines() {
        DispatchQueue.global(qos: .userInitiated).async {
            let parsedLines = CSVParser.loadOfficeLinesFromBundle()
            
            DispatchQueue.main.async {
                self.officeLines = parsedLines
                self.isDataLoaded = !parsedLines.isEmpty
                self.filterLines(with: self.searchText)
            }
        }
    }
    
    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func showCopyFeedback(for line: OfficeLine) {
        copyFeedback = "Copied to clipboard!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copyFeedback = ""
            selectedLine = nil
        }
    }
}

struct LineResultView: View {
    let line: OfficeLine
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Season \(line.season), Episode \(line.episode)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(line.speaker)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                
                Text(line.lineText)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .onHover { isHovering in
            if isHovering {
                NSCursor.pointingHand.set()
            } else {
                NSCursor.arrow.set()
            }
        }
    }
}

#Preview {
    ContentView()
}
