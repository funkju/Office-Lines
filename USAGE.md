# Office Lines App - Usage Guide

## Getting Started

### Step 1: Build and Run the App
1. Open `OfficeLinesApp.xcodeproj` in Xcode
2. Make sure you have macOS 14.0+ and Xcode 15.0+
3. Build and run the project (⌘+R)

### Step 2: Start Searching
- The app automatically loads all Office lines when it starts
- You'll see a loading screen briefly while the database is loaded
- Once loaded, you can immediately start searching

### Step 3: Search for Lines
1. Type in the search box to find lines
2. Search works on both line text and speaker names
3. Results update in real-time as you type
4. Shows up to 50 results at once

### Step 4: Copy Lines to Clipboard
- Click on any search result
- The line text is automatically copied to your clipboard
- Green confirmation message appears
- Use ⌘+V to paste anywhere

## Advanced Features

### Search Tips
- **Wildcard search**: Type partial words to find matches
- **Speaker search**: Search by character names (e.g., "Michael", "Dwight")
- **Case insensitive**: Search works regardless of capitalization
- **Phrase search**: Find exact phrases or partial quotes

### Database Details
The app includes a complete database of Office lines with:
- `id`: Unique identifier for each line
- `season`: Season number
- `episode`: Episode number  
- `scene`: Scene number
- `line_text`: The actual quote
- `speaker`: Character name

### Performance
- App handles tens of thousands of lines efficiently
- Search results appear instantly
- First 50 results shown to maintain performance
- All data loads into memory for fast searching

## Complete Database Included

The app comes with a complete database of Office lines built-in, containing:
- Over 50,000 lines from all seasons
- Complete character information
- Season and episode details
- All data is automatically loaded when you start the app

## Troubleshooting

### App Takes Time to Load
- The app loads a large database of Office lines on startup
- Wait for the loading screen to complete
- This only happens once when the app starts

### Search Not Working
- Verify data loaded successfully (check the "Total lines loaded" counter)
- Try simpler search terms
- Remember search is case-insensitive

### Clipboard Not Working
- Make sure you're clicking directly on the search result
- Check for the green "Copied to clipboard!" confirmation message
- Try pasting with ⌘+V in another application

## Privacy and Security

- App is sandboxed for security
- No file access permissions required
- No network access required
- All data is included in the app bundle and stays on your local machine