# Office Lines App - Usage Guide

## Getting Started

### Step 1: Build and Run the App
1. Open `OfficeLinesApp.xcodeproj` in Xcode
2. Make sure you have macOS 14.0+ and Xcode 15.0+
3. Build and run the project (⌘+R)

### Step 2: Load Your Data
You have two options:

#### Option A: Load Sample Data (Quick Start)
- Click "Load Sample Data" button
- This loads 30+ popular Office quotes for immediate testing

#### Option B: Import CSV File
- Click "Load CSV File" button
- Select your CSV file containing Office lines
- The file should follow this format:
  ```csv
  id,season,episode,scene,line_text,speaker
  1,1,1,1,"That's what she said!","Michael Scott"
  ```

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

### CSV Format Details
Your CSV file must have these exact column headers:
- `id`: Unique identifier (integer)
- `season`: Season number (integer)
- `episode`: Episode number (integer)  
- `scene`: Scene number (integer)
- `line_text`: The actual quote (text, can contain commas if quoted)
- `speaker`: Character name (text)

### Performance
- App handles thousands of lines efficiently
- Search results appear instantly
- First 50 results shown to maintain performance
- All data loads into memory for fast searching

## Sample Files Included

### `sample_office_lines.csv`
- Contains 15 popular Office quotes
- Perfect for quick testing

### `extended_office_lines.csv`
- Contains 30+ quotes from various seasons
- Demonstrates full app capabilities
- Includes quotes from multiple characters

## Troubleshooting

### CSV Won't Load
- Check that your CSV has the exact column headers shown above
- Ensure numeric columns (id, season, episode, scene) contain valid integers
- Make sure text with commas is properly quoted

### Search Not Working
- Verify data loaded successfully (check the "Total lines loaded" counter)
- Try simpler search terms
- Remember search is case-insensitive

### Clipboard Not Working
- Make sure you're clicking directly on the search result
- Check for the green "Copied to clipboard!" confirmation message
- Try pasting with ⌘+V in another application

## Examples

### Good CSV Format ✅
```csv
id,season,episode,scene,line_text,speaker
1,2,1,5,"That's a really, really good point.","Michael Scott"
2,1,3,2,"Bears eat beets.","Dwight Schrute"
```

### Bad CSV Format ❌
```csv
ID,Season,Episode,Line,Person
one,2,1,"That's a good point","Michael"
```

## Privacy and Security

- App is sandboxed for security
- Only accesses files you explicitly select
- No network access required
- All data stays on your local machine