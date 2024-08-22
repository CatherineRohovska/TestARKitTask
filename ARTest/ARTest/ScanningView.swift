//
//  ScanningView.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import SwiftUI
import RealityKit
import ARKit

struct ScanningView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                ARManager.shared.stopSession {
                    self.mode.wrappedValue.dismiss()
                }
            }){
                Image(systemName: "arrow.left")
            })
    }
}

#Preview {
    ScanningView()
}
