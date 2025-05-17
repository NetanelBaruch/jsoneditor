# EuroILS Widget

This repository contains a minimal SwiftUI project that displays the real-time exchange rate from Euro (EUR) to Israeli Shekel (ILS).

The app and widget fetch the latest rate from [exchangerate.host](https://exchangerate.host) and refresh every hour.

## Project Structure

```
EuroILSWidget/
├── EuroILSWidgetApp/
│   ├── ContentView.swift
│   └── EuroILSApp.swift
└── EuroILSWidgetExtension/
    └── EuroILSWidget.swift
```

- `EuroILSWidgetApp` contains the main iOS application.
- `EuroILSWidgetExtension` provides a WidgetKit extension that can be added to the iPhone home screen.

## Building

1. Open the project folder in Xcode.
2. Build and run the **EuroILSApp** target on an iOS simulator or device.
3. Add the *Euro to ILS Rate* widget from the home screen widget gallery.

Both the app and widget display the conversion rate using a simple SwiftUI layout.
