# Algolia Search Integration Setup

## Overview

The Office Lines app now uses Algolia for search functionality instead of local CSV filtering. This provides more powerful search capabilities and real-time results.

## Configuration

### 1. Algolia Configuration File

The app loads Algolia configuration from `AlgoliaConfig.plist`. You need to update this file with your actual Algolia credentials:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>app-id</key>
	<string>YOUR_ALGOLIA_APP_ID</string>
	<key>api-key</key>
	<string>YOUR_ALGOLIA_SEARCH_API_KEY</string>
	<key>index-name</key>
	<string>office_lines</string>
</dict>
</plist>
```

### 2. Required Credentials

You need to obtain from your Algolia dashboard:
- **App ID**: Your Algolia application ID
- **API Key**: Your search-only API key (not admin key)
- **Index Name**: The name of your Algolia index containing Office lines data

### 3. Data Structure

Your Algolia index should contain documents with the following structure:

```json
{
  "objectID": "unique_id",
  "id": 1,
  "season": 1,
  "episode": 1,
  "scene": 1,
  "line_text": "That's what she said!",
  "speaker": "Michael Scott"
}
```

## Features

### Search Capabilities
- Real-time search as you type
- Search across both line text and speaker names
- Results limited to 50 items for performance
- Fallback to sample data if Algolia is unavailable

### Error Handling
- Graceful fallback when Algolia configuration is missing
- Network error handling with empty results fallback
- Debug logging for troubleshooting

## Network Requirements

The app now requires network access and includes the following entitlement:
```xml
<key>com.apple.security.network.client</key>
<true/>
```

## Migration from CSV

The previous CSV-based search is still available as a fallback. The `AlgoliaSearchManager` will use sample data if:
- `AlgoliaConfig.plist` is missing or invalid
- Network requests fail
- Algolia credentials are invalid

## Testing

Run the included tests to verify:
- Algolia configuration loading
- Search manager initialization
- Data structure conversions
- Fallback behavior