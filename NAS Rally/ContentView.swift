//
//  ContentView.swift
//  Rally Chat
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

/// The content and behavior of the main interface.
///
/// This property defines a tab-based navigation structure that adapts between
/// a standard tab bar and a sidebar depending on the platform and screen size.
/// It provides access to the primary features of the application:
/// - **Home**: The main landing view and dashboard.
/// - **Rallies**: An overview of upcoming and active rally events.
/// - **Chat**: Real-time messaging and discussion channels.
/// - **Profile**: User account details and personalization options.
/// - **Settings**: App preferences and configuration controls.

struct ContentView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            TabView() {
                Tab("Home", systemImage: "house") {
                    HomeView(person: $person)
                }
                Tab("Rallies", systemImage: "car.2.fill") {
                    RalliesView(person: $person)
                }
                Tab("Chat", systemImage: "bubble.left.and.bubble.right") {
                    ChatView(person: $person)
                }
                Tab("Wavers", systemImage: "long.text.page.and.pencil") {
                    WaversView(person: $person)
                }
                Tab("Settings", systemImage: "gearshape") {
                    SettingsView(person: $person)
                }
                if (person.privligeLevel == "Admin") {
                    Tab("Admin", systemImage: "person.badge.checkmark.seal.fill") {
                        AdminView(person: $person)
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
        } else {
            TabView {
                HomeView(person: $person)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                RalliesView(person: $person)
                    .tabItem {
                        Label("Rallies", systemImage: "car.2.fill")
                    }
                ChatView(person: $person)
                    .tabItem {
                        Label("Chat", systemImage: "bubble.left.and.bubble.right")
                    }
                WaversView(person: $person)
                    .tabItem {
                        Label("Wavers", systemImage: "doc.text")
                    }
                SettingsView(person: $person)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                if person.privligeLevel == "Admin" {
                    AdminView(person: $person)
                        .tabItem {
                            Label("Admin", systemImage: "person.circle")
                        }
                }
            }
        }
    }
}

// MARK: - Compatibility Glass Modifiers for iOS 17 Minimum Deployment

enum GlassEffectStyleCompat {
    case regular
    
    #if os(visionOS)
    @available(visionOS 2.0, *)
    func toSystemStyle() -> GlassEffectStyle {
        switch self {
        case .regular:
            return .regular
        }
    }
    #endif
}

struct GlassEffectCompatModifier<S: Shape>: ViewModifier {
    var style: GlassEffectStyleCompat
    var shape: S?

    func body(content: Content) -> some View {
        #if os(visionOS)
        if #available(visionOS 2.0, *) {
            if let shape = shape {
                content.glassEffect(style.toSystemStyle(), in: shape)
            } else {
                content.glassEffect(style.toSystemStyle())
            }
        } else {
            fallbackBody(content)
        }
        #else
        fallbackBody(content)
        #endif
    }
    
    @ViewBuilder
    private func fallbackBody(_ content: Content) -> some View {
        if let shape = shape {
            content.background(shape.fill(.ultraThinMaterial))
        } else {
            content.background(.ultraThinMaterial)
        }
    }
}

private struct DummyShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path()
    }
}

extension View {
    func glassEffectCompat<S: Shape>(_ style: GlassEffectStyleCompat = .regular, in shape: S) -> some View {
        self.modifier(GlassEffectCompatModifier(style: style, shape: shape))
    }

    func glassEffectCompat(_ style: GlassEffectStyleCompat = .regular) -> some View {
        self.modifier(GlassEffectCompatModifier<DummyShape>(style: style, shape: nil))
    }
}
