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
    @State private var path = NavigationPath()
    @ObservedObject var arManager = ARManager.shared
    var body: some View {
        NavigationStack {
            VStack(content: {
                Spacer();
                NavigationLink("Camera") {
                    ScanningView()
                };
                Spacer();
                Button("Clear") {
                    ARManager.shared.clearData()
                };
                Spacer();
                ShareLink(item: ARManager.shared.loadPathUSDZ()) {
                    Text(arManager.hasUsdz ? "Share" : "Nothing to share yet")
                }.allowsHitTesting(arManager.hasUsdz);
                Spacer();
                
            })
        }
    }
    
    func shareContent() {
            let textToShare = "Share!"
            let itemsToShare = [textToShare]
            
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
}

#Preview {
    ContentView()
}
