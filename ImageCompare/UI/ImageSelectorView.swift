//
//  ImageSelectorView.swift
//  ImageCompare
//
//  Created by iurii int on 07.10.2024.
//

import Foundation
import SwiftUI

struct ImageSelectorView: View {
    let title: String
    let buttonAction: () -> Void
    @Binding var image: NSImage?

    var body: some View {
        VStack {
            Button(title, action: buttonAction)

            Group {
                if let image {
                    Button(action: buttonAction) {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                } else {
                    Button(action: buttonAction) {
                        Text("No Image (drop an image here)")
                            .frame(width: 200, height: 200)
                    }
                    .border(Color.gray, width: 1)
                }
            }
            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                handleDrop(providers: providers)
            }
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (item, error) in
            if let error {
                print("Error: \(error)")
                return
            }

            if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                DispatchQueue.main.async {
                    image = NSImage(contentsOf: url)
                }
            }
        }

        return true
    }
}
