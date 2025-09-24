# Office Lines - The Office Quote Search App

A native macOS application for searching through every line from the TV show "The Office". Load a CSV file containing Office lines and use the autocomplete search to find your favorite quotes instantly!

## Features

- **Built-in Office Lines**: All Office lines are pre-loaded from the included database
- **Wildcard Search**: Search through all lines with real-time filtering
- **Copy to Clipboard**: Click any result to copy the line text to your clipboard
- **Responsive UI**: Native macOS interface with SwiftUI
- **Complete Database**: Contains thousands of lines from all seasons of The Office

## Data Source

The app includes a complete database of lines from The Office TV show, pre-loaded and ready to search. The database contains:
- Lines from all seasons and episodes
- Character names for each line
- Season and episode information
- Over 50,000 lines from the complete series

## How to Build and Run

### Prerequisites
- macOS 14.0 or later
- Xcode 15.0 or later

### Building the App
1. Clone this repository
2. Open `OfficeLinesApp.xcodeproj` in Xcode
3. Select the "OfficeLinesApp" scheme
4. Build and run (⌘+R)

### Using the App
1. Launch the application - all Office lines will be loaded automatically
2. Type in the search box to find lines containing your search term
3. Click on any result to copy the line text to your clipboard

## Project Structure

```
OfficeLinesApp/
├── OfficeLinesAppApp.swift      # Main app entry point
├── ContentView.swift            # Main UI view with search interface
├── OfficeLine.swift             # Data model for Office lines
├── CSVParser.swift              # CSV parsing logic
├── Assets.xcassets/             # App icons and assets
└── OfficeLinesApp.entitlements  # App permissions (file access)
```

## Sample Data

The app comes with the complete Office lines database built-in, so no additional setup is required.

## Requirements

- The app is sandboxed for security
- No network access required - all data is stored locally
- All Office lines are included in the app bundle