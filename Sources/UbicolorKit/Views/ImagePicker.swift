//
//  ImagePicker.swift
//  flower
//
//  Created by Romain on 02/02/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import SwiftUI
import Photos

public struct ImagePicker : UIViewControllerRepresentable {
	
	@Environment(\.presentationMode) var presentationMode
	@Binding var selectedImage : UIImage
	
	public init(image: Binding<UIImage>) {
		self._selectedImage = image
	}
		
	public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		
		let parent : ImagePicker
		public init(_ parent : ImagePicker) {
			self.parent = parent
		}
		
		public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			
			let status = PHPhotoLibrary.authorizationStatus()
			if status == .notDetermined  {
				PHPhotoLibrary.requestAuthorization({status in })
			}
			
			if let uiImage = info[.originalImage] as? UIImage {
								
				parent.selectedImage = uiImage
				
				
			}
					
			parent.presentationMode.wrappedValue.dismiss()
		}
		public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
	
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
	}
}
