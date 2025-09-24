# Office Lines App - Usage Guide

## Getting Started

### Step 1: Configure Algolia (Required)
1. Set up your Algolia account and index
2. Update `AlgoliaConfig.plist` with your credentials
3. See `ALGOLIA_SETUP.md` for detailed instructions

### Step 2: Build and Run the App
1. Open `OfficeLinesApp.xcodeproj` in Xcode
2. Make sure you have macOS 14.0+ and Xcode 15.0+
3. Build and run the project (⌘+R)

### Step 3: Start Searching
- The app connects to Algolia for real-time search
- You'll see a loading screen briefly while initializing
- Once loaded, you can immediately start searching

### Step 4: Search for Lines
1. Type in the search box to find lines
2. Search works on both line text and speaker names using Algolia's intelligent matching
3. Results update in real-time as you type with superior relevance ranking
4. Shows up to 50 results at once

### Step 5: Copy Lines to Clipboard
- Click on any search result
- The line text is automatically copied to your clipboard
- Green confirmation message appears
- Use ⌘+V to paste anywhere

## Advanced Features

### Search Tips
- **Intelligent Matching**: Algolia provides fuzzy matching and typo tolerance
- **Relevance Ranking**: Results are ranked by relevance, not just text matching
- **Speaker search**: Search by character names (e.g., "Michael", "Dwight")
- **Case insensitive**: Search works regardless of capitalization
- **Phrase search**: Find exact phrases or partial quotes
- **Real-time**: Results appear instantly as you type

### Algolia-Powered Search
The app uses Algolia's search API for:
- Superior search quality and relevance
- Typo tolerance and fuzzy matching
- Fast response times
- Scalable search infrastructure
- Advanced filtering and ranking

### Performance
- Search results appear in real-time using Algolia's fast API
- Network optimized for quick response times
- First 50 results shown to maintain performance
- Fallback to sample data when offline

## Search Data Structure

The Algolia index contains Office lines with:
- `id`: Unique identifier for each line
- `season`: Season number
- `episode`: Episode number  
- `scene`: Scene number
- `line_text`: The actual quote
- `speaker`: Character name
- `objectID`: Algolia's unique document identifier

## Troubleshooting

### App Takes Time to Load
- The app initializes the Algolia search connection on startup
- Ensure you have a stable internet connection
- Check that your Algolia credentials in `AlgoliaConfig.plist` are correct

### Search Not Working
- Verify your Algolia configuration is set up correctly
- Check your internet connection
- Look for error messages in the Xcode console
- The app will fall back to sample data if Algolia is unavailable

### No Search Results
- Try simpler search terms
- Check if your Algolia index contains data
- Verify the index name in your configuration matches your Algolia dashboard
- Remember search is case-insensitive but requires an internet connection

### Clipboard Not Working
- Make sure you're clicking directly on the search result
- Check for the green "Copied to clipboard!" confirmation message
- Try pasting with ⌘+V in another application

### Configuration Issues
- Ensure `AlgoliaConfig.plist` is included in your Xcode project
- Double-check your Algolia App ID, API Key, and Index Name
- Use a search-only API key, not an admin key
- Refer to `ALGOLIA_SETUP.md` for detailed setup instructions

## Privacy and Security

- App is sandboxed for security with network client permissions
- Network access is only used for Algolia search API calls
- No personal data is sent to Algolia beyond search queries
- Algolia credentials are stored locally in the app bundle
- Falls back to sample data when network is unavailable