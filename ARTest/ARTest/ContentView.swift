//
//  ContentView.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import SwiftUI
import SceneKit
import ARKit

struct ContentView : View {
    var body: some View {
        NavigationStack {
            VStack(content: {
                Spacer();
                NavigationLink("Camera") {
                    ScanningView()
                };
                Spacer();
                Button("Clear") {
                    
                };
                Spacer();
                Button("Share") {
                    
                };
                Spacer();
                
            })
        }
    }
}

#Preview {
    ContentView()
}
