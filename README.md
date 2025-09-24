# Office Lines - The Office Quote Search App

A native macOS application for searching through every line from the TV show "The Office". Now powered by Algolia search for fast, intelligent search results!

## Features

- **Algolia-Powered Search**: Fast, intelligent search using Algolia's search API
- **Real-time Results**: Search results appear instantly as you type
- **Advanced Search**: Search through both line text and speaker names
- **Copy to Clipboard**: Click any result to copy the line text to your clipboard
- **Responsive UI**: Native macOS interface with SwiftUI
- **Fallback Support**: Works offline with sample data when Algolia is unavailable

## Search Technology

The app now uses **Algolia** for search functionality, providing:
- Superior search relevance and ranking
- Real-time search as you type
- Fuzzy matching and typo tolerance
- Fast response times
- Scalable search infrastructure

## Setup Requirements

### Prerequisites
- macOS 14.0 or later
- Xcode 15.0 or later
- **Algolia Account**: Required for full search functionality

### Algolia Configuration
1. Create an Algolia account and index your Office lines data
2. Update `OfficeLines/OfficeLines/AlgoliaConfig.plist` with your credentials:
   - `app-id`: Your Algolia Application ID
   - `api-key`: Your Algolia Search API Key
   - `index-name`: Your Algolia index name

See `ALGOLIA_SETUP.md` for detailed configuration instructions.

### Building the App
1. Clone this repository
2. **Configure Algolia**: Update `AlgoliaConfig.plist` with your Algolia credentials
3. Open `OfficeLinesApp.xcodeproj` in Xcode
4. Select the "OfficeLinesApp" scheme
5. Build and run (⌘+R)

### Using the App
1. Launch the application
2. Start typing in the search box to find Office lines
3. Results appear in real-time using Algolia search
4. Click on any result to copy the line text to your clipboard

**Note**: If Algolia is not configured, the app will fall back to a small set of sample quotes.

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

- **Network Access**: The app requires internet connectivity for Algolia search
- **Algolia Account**: Free tier available for development and small-scale usage
- The app is sandboxed for security with network client permissions
- Fallback functionality works offline with limited sample data