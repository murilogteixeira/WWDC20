//
//  SandwichesApp.swift
//  Shared
//
//  Created by Murilo Teixeira on 23/06/20.
//

import SwiftUI

@main
struct SandwichesApp: App {
    @StateObject private var store = SandwichStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
