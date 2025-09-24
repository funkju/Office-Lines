# Setup Instructions for Baked-in CSV Loading

## Important: Xcode Project Configuration Required

After pulling these changes, you need to add the CSV file to the Xcode project bundle to ensure it's included in the compiled app:

### Steps to Complete Setup:

1. **Open the project in Xcode**
   ```
   open OfficeLinesApp.xcodeproj
   ```

2. **Add the CSV file to the project bundle:**
   - In Xcode, right-click on the "OfficeLines" folder in the project navigator
   - Select "Add Files to 'OfficeLinesApp'"
   - Navigate to and select `OfficeLines/OfficeLines/the-office-lines.csv`
   - Make sure "Add to target" includes "OfficeLines"
   - Click "Add"

3. **Verify the setup:**
   - Build and run the project
   - The app should automatically load all Office lines on startup
   - Check the console for any "Loading CSV from fallback path" messages

### Alternative: Manual Resource Bundle Addition

If the above steps don't work, you can also:

1. Select the project file in Xcode (top of the navigator)
2. Select the "OfficeLines" target
3. Go to "Build Phases" tab
4. Expand "Copy Bundle Resources"
5. Click the "+" button
6. Add `the-office-lines.csv`

### Verification

The app should load approximately 58,000 Office lines automatically when it starts. If you see "Loading CSV from fallback path" in the console, the file isn't properly bundled but the app found it anyway (development mode).

### Fallback Behavior

If the CSV file cannot be found, the app will display a small set of sample Office quotes as a fallback to ensure it still functions.