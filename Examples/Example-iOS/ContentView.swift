//
//  ContentView.swift
//  Example-iOS
//
//  Created by Alex.M on 26.05.2022.
//

import SwiftUI
import MediaPicker

struct ContentView: View {
    @State private var showDefaultMediaPicker = false
    @State private var showCustomizedMediaPicker = false
    @State private var medias: [Media] = []
    
    var body: some View {
        NavigationView {
            List {
                Text("Default")
                    .onTapGesture {
                        showDefaultMediaPicker = true
                    }
                Text("Customized")
                    .onTapGesture {
                        showCustomizedMediaPicker = true
                    }
            }
            .navigationTitle("Examples")
        }
        // MARK: - Default media picker
        .mediaPicker(
            isPresented: $showDefaultMediaPicker,
            leadingNavigation: {
                Button("Cancel") {
                    showDefaultMediaPicker = false
                }
            },
            trailingNavigation: {
                Button("Send") {
                    print("Sent:", medias)
                }
            },
            onChange: { medias = $0 }
        )

        // MARK: - Built-in media picker
        .sheet(isPresented: $showCustomizedMediaPicker) {
            BuiltInPickerView(isPresented: $showCustomizedMediaPicker)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
