//
//  ImagePicker.swift
//  memory frame
//
//  Created by feng on 2025/6/13.
//

import SwiftUI
import UIKit
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// 现代化的PhotosPicker替代方案
struct ModernImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            EmptyView()
        }
        .onChange(of: selectedItem) { oldValue, newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            await MainActor.run {
                                selectedImage = image
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}