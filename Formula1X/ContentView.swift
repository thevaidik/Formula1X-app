//
//  ContentView.swift
//  Formula1X
//
//  Created by Vaidik Dubey on 11/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .preferredColorScheme(.dark)
        .tint(Theme.salmonPink)
    }
}

#Preview {
    ContentView()
}
