//
// ContentView.swift
// Created by zsj on 2023/8/7.
//


import PhotosUI
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ImageModel()
    @State private var shouldShowAttributes: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                // Button in the center of the screen
                Button(action: {
                    shouldShowAttributes.toggle()
                }, label: {
                    Text(shouldShowAttributes ? "PhotosPicker inline": "PhotosPicker Modal")
                })
                .padding()
                
                ScrollView {
                    ForEach(Array(viewModel.images.keys), id: \.self) { key in
                        if let image = viewModel.images[key] {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                
                // Picker section fixed at the bottom
                photosPicker
                .frame(height: 200) // Fixed height at the bottom
            }
        }
    }
    
    var photosPicker: some View {
        PhotosPicker(selection: $viewModel.imageSelection,
                     selectionBehavior: .continuous,
                     matching: .images,
                     preferredItemEncoding: .current,
                     photoLibrary: .shared()) {
                        Image(systemName: "pencil.circle.fill")
                            .imageScale(.large)
        }
        .applyAttributes(shouldShow: shouldShowAttributes)
    }
}

extension View {
    func applyAttributes(shouldShow: Bool) -> some View {
        Group {
            if shouldShow {
                self
                    .photosPickerStyle(.inline)
                    .photosPickerDisabledCapabilities(.selectionActions)
                    .photosPickerAccessoryVisibility(.hidden, edges: .all)
            } else {
                self
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


