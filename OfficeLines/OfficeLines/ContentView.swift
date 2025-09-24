import SwiftUI
import AppKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var officeLines: [OfficeLine] = []
    @State private var filteredLines: [OfficeLine] = []
    @State private var isDataLoaded = false
    @State private var selectedLine: OfficeLine?
    @State private var copyFeedback = ""
    @State private var selectedIndex = 0
    @State private var isSearching = false
    @FocusState private var isSearchFocused: Bool
    @StateObject private var algoliaManager = AlgoliaSearchManager()
    
    var body: some View {
        VStack(spacing: 0) {
            if isDataLoaded {
                // Spotlight-style centered search
                VStack(spacing: 16) {
                    // Minimal search field
                    TextField("Search The Office lines...", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(isSearchFocused ? 0.2 : 0.1), radius: isSearchFocused ? 2 : 1, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor.opacity(isSearchFocused ? 0.3 : 0), lineWidth: 1)
                        )
                        .focused($isSearchFocused)
                        .onSubmit {
                            if !filteredLines.isEmpty && selectedIndex < filteredLines.count {
                                let line = filteredLines[selectedIndex]
                                copyToClipboard(line.copyText)
                                selectedLine = line
                                showCopyFeedback(for: line)
                            }
                        }
                        .onChange(of: searchText) { _, newValue in
                            performAlgoliaSearch(query: newValue)
                            selectedIndex = 0
                        }
                        .onKeyPress(.upArrow) {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            }
                            return .handled
                        }
                        .onKeyPress(.downArrow) {
                            if selectedIndex < filteredLines.count - 1 {
                                selectedIndex += 1
                            }
                            return .handled
                        }
                    
                    // Copy feedback
                    if !copyFeedback.isEmpty {
                        Text(copyFeedback)
                            .foregroundColor(.green)
                            .font(.caption)
                            .animation(.easeInOut(duration: 0.2), value: copyFeedback)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 40)
                .padding(.bottom, searchText.isEmpty ? 0 : 20)
                
                // Results
                if !filteredLines.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(Array(filteredLines.prefix(50).enumerated()), id: \.element.id) { index, line in
                                SpotlightResultView(line: line, isSelected: index == selectedIndex) {
                                    copyToClipboard(line.copyText)
                                    selectedLine = line
                                    showCopyFeedback(for: line)
                                    selectedIndex = index
                                }
                                .background(selectedLine?.id == line.id ? Color.accentColor.opacity(0.1) : 
                                           (index == selectedIndex ? Color.accentColor.opacity(0.05) : Color.clear))
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                } else if !searchText.isEmpty {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        Text("No results found")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                } else {
                    // Empty state - show nothing, like Spotlight
                    Spacer()
                }
            } else {
                // Minimal loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                    
                    Text(isSearching ? "Searching..." : "Loading...")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 640, minHeight: 480)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            loadOfficeLines()
            isSearchFocused = true
        }
    }
    
    private func performAlgoliaSearch(query: String) {
        if query.isEmpty {
            filteredLines = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        algoliaManager.search(query: query) { result in
            DispatchQueue.main.async {
                self.isSearching = false
                switch result {
                case .success(let lines):
                    self.filteredLines = lines
                case .failure(let error):
                    print("Algolia search error: \(error)")
                    // Fallback to empty results on error
                    self.filteredLines = []
                }
            }
        }
    }
    
    private func loadOfficeLines() {
        // With Algolia, we don't need to preload all data
        // Just mark as loaded and ready for search
        DispatchQueue.main.async {
            self.isDataLoaded = true
            self.performAlgoliaSearch(query: self.searchText)
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

struct SpotlightResultView: View {
    let line: OfficeLine
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: "quote.bubble")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(line.lineText)
                        .font(.system(size: 14))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(line.speaker)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("S\(line.season)E\(line.episode)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color.clear)
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
