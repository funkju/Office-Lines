#!/bin/bash

# Office Lines App Build Script
echo "🏢 Building Office Lines macOS App..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This app requires macOS to build and run"
    echo "   Please run this on a Mac with Xcode installed"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is required to build this app"
    echo "   Please install Xcode from the Mac App Store"
    exit 1
fi

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion)
echo "📱 macOS Version: $MACOS_VERSION"

# Check Xcode version
XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo "🔨 $XCODE_VERSION"

echo ""
echo "🚀 Building the app..."

# Build the project
xcodebuild -project OfficeLinesApp.xcodeproj \
           -scheme OfficeLinesApp \
           -configuration Release \
           -derivedDataPath build \
           build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "📦 You can find the app at:"
    echo "   build/Build/Products/Release/OfficeLinesApp.app"
    echo ""
    echo "🎯 To run the app:"
    echo "   open build/Build/Products/Release/OfficeLinesApp.app"
    echo ""
    echo "📚 Or open the project in Xcode and run it directly:"
    echo "   open OfficeLinesApp.xcodeproj"
else
    echo ""
    echo "❌ Build failed. Please check the errors above."
    echo "   Try opening the project in Xcode for more details:"
    echo "   open OfficeLinesApp.xcodeproj"
    exit 1
fi