//
//  ImagePicker.swift
//  BeerAdvisor
//
//  Created by Fritz Boyle on 11/21/24.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    // Coordinator class to handle UIImagePickerController events
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Called when the user picks an image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    // Creates the coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Creates the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera // Change to .photoLibrary if you want to select from the gallery
        picker.allowsEditing = false
        return picker
    }

    // Updates the UIViewController (not needed here)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
