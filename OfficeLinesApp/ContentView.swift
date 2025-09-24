import SwiftUI
import AppKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var officeLines: [OfficeLine] = []
    @State private var filteredLines: [OfficeLine] = []
    @State private var showingImporter = false
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
                
                Button("Load CSV File") {
                    showingImporter = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            if isDataLoaded {
                // Search box
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search for Office lines:")
                        .font(.headline)
                    
                    TextField("Type to search lines...", text: $searchText)
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
                // Welcome message
                VStack(spacing: 16) {
                    Image(systemName: "tv.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to The Office Lines Search")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Load a CSV file containing Office lines to get started")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Load CSV File") {
                        showingImporter = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // Show sample data for demo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Or try with sample data:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Load Sample Data") {
                            loadSampleData()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .padding(40)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .fileImporter(
            isPresented: $showingImporter,
            allowedContentTypes: [.commaSeparatedText, .plainText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
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
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            do {
                let csvContent = try String(contentsOf: url)
                let parsedLines = CSVParser.parseOfficeLines(from: csvContent)
                
                DispatchQueue.main.async {
                    self.officeLines = parsedLines
                    self.isDataLoaded = !parsedLines.isEmpty
                    self.filterLines(with: self.searchText)
                }
            } catch {
                print("Error reading CSV file: \(error)")
            }
            
        case .failure(let error):
            print("Error importing file: \(error)")
        }
    }
    
    private func loadSampleData() {
        officeLines = OfficeLine.sampleData
        isDataLoaded = true
        filterLines(with: searchText)
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