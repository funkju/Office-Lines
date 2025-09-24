# Office Lines - The Office Quote Search App

A native macOS application for searching through every line from the TV show "The Office". Load a CSV file containing Office lines and use the autocomplete search to find your favorite quotes instantly!

## Features

- **CSV Import**: Load your own CSV file with Office lines
- **Wildcard Search**: Search through all lines with real-time filtering
- **Copy to Clipboard**: Click any result to copy the line text to your clipboard
- **Sample Data**: Try the app immediately with built-in sample quotes
- **Responsive UI**: Native macOS interface with SwiftUI

## CSV Format

The application expects a CSV file with the following columns:
```
id,season,episode,scene,line_text,speaker
```

Example:
```csv
id,season,episode,scene,line_text,speaker
1,1,1,1,"That's what she said!","Michael Scott"
2,1,1,2,"Bears. Beets. Battlestar Galactica.","Jim Halpert"
```

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
1. Launch the application
2. Either:
   - Click "Load CSV File" to import your own Office lines CSV
   - Click "Load Sample Data" to try with built-in examples
3. Type in the search box to find lines containing your search term
4. Click on any result to copy the line text to your clipboard

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

The app includes sample data with popular Office quotes for immediate testing. You can also use the provided `sample_office_lines.csv` file to test the CSV import functionality.

## Requirements

- The app is sandboxed for security
- File access is limited to user-selected files only
- Requires permission to read CSV files from your computer