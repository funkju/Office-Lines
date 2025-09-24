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
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .onChange(of: searchText) { _, newValue in
                            filterLines(with: newValue)
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
                            ForEach(filteredLines.prefix(50)) { line in
                                SpotlightResultView(line: line) {
                                    copyToClipboard(line.copyText)
                                    selectedLine = line
                                    showCopyFeedback(for: line)
                                }
                                .background(selectedLine?.id == line.id ? Color.accentColor.opacity(0.1) : Color.clear)
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
                    
                    Text("Loading...")
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
        }
    }
    
    private func filterLines(with searchText: String) {
        if searchText.isEmpty {
            filteredLines = []
        } else {
            let lowercaseSearch = searchText.lowercased()
            filteredLines = officeLines.filter { line in
                line.lineText.lowercased().contains(lowercaseSearch) ||
                line.speaker.lowercased().contains(lowercaseSearch)
            }
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

struct SpotlightResultView: View {
    let line: OfficeLine
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
