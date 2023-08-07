//
// ImageModel.swift
// Created by zsj on 2023/8/7.
//
    

import SwiftUI
import PhotosUI

@MainActor
class ImageModel: ObservableObject {
    @Published var images = [String: Image]()
    @Published var imageSelection: [PhotosPickerItem] = [] {
        didSet {
            Task {
                try await loadTransferable(from: imageSelection)
            }
        }
    }

    func loadTransferable(from imageSelection: [PhotosPickerItem]) async throws {
        // Create a Set of existing keys
        var existingKeys = Set(images.keys)
        
        do {
            for selection in imageSelection {
                // Use a unique identifier for each selection
                let itemIdentifier = selection.itemIdentifier

                if let data = try await selection.loadTransferable(type: Data.self), let uiImage = UIImage(data: data), let itemIdentifier {
                    images[itemIdentifier] = Image(uiImage: uiImage) // Add or update the image in the dictionary
                }
                
                if let itemIdentifier {
                    existingKeys.remove(itemIdentifier) // Remove the id from the existing keys
                }
            }
            
            // Remove any keys that no longer exist in the selection
            for key in existingKeys {
                images.removeValue(forKey: key)
            }

        } catch {
            fatalError("Image issue")
        }
    }
}

