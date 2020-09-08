//
//  SandwichStore.swift
//  Sandwiches
//
//  Created by Murilo Teixeira on 23/06/20.
//

import SwiftUI

class SandwichStore: ObservableObject {
    @Published var sandwiches: [Sandwich]
    
    init(sandwiches: [Sandwich] = []) {
        self.sandwiches = sandwiches
    }
}

let testStore = SandwichStore(sandwiches: testData)
