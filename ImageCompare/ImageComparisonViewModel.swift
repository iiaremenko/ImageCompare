//
//  ImageComparisonViewModel.swift
//  ImageCompare
//
//  Created by iurii int on 07.10.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - ViewModel
@Observable class ImageComparisonViewModel {
    enum DiffMode: CaseIterable, Identifiable {
        case difference
        case hSlider

        var id: Self { self }
    }

    enum Side: CaseIterable, Identifiable {
        case left
        case right

        var id: Self { self }
    }

    let path1: String?
    let path2: String?

    var image1: NSImage? {
        didSet {
            compareImages()
        }
    }
    var image2: NSImage? {
        didSet {
            compareImages()
        }
    }

    var differenceImage: NSImage?
    var isImagesIdentical: Bool?

    var showingImporter = false
    var currentImportSide: Side = .left

    var showAlert = false
    var alertMessage = ""

    var diffMode: DiffMode = .difference
    static let allowedContentTypes = [
        UTType.png,
        .jpeg,
        .tiff,
        .heic,
        .gif,
        .heif,
        .webP
    ]

    init() {
        self.path1 = nil
        self.path2 = nil
    }

    init(path1: String, path2: String) {
        self.path1 = path1
        self.path2 = path2
    }

    init(image1: NSImage?, image2: NSImage?) {
        self.image1 = image1
        self.image2 = image2
        self.path1 = nil
        self.path2 = nil
        compareImages()
    }

    func onAppear() {
        if let path1, let path2 {
            loadImages(path1: path1, path2: path2)
        }
    }

    func imageSelectionTapped(side: Side) {
        currentImportSide = side
        showingImporter = true
    }

    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            if let image = try? url.getNSImage() {
                switch currentImportSide {
                case .left:
                    image1 = image
                case .right:
                    image2 = image
                }
            } else {
                showAlertWithMessage("Failed to load image from URL: \(url.absoluteString)")
            }
        case .failure(let error):
            showAlertWithMessage("Failed to import file: \(error.localizedDescription)")
        }
    }

    func compareImages() {
        guard let image1, let image2 else {
            return
        }

        (differenceImage, isImagesIdentical) = createDifferenceImage(first: image1, second: image2)
    }
}

private extension ImageComparisonViewModel {
    private func loadImages(path1: String, path2: String) {
        let expandedPath1 = (path1 as NSString).expandingTildeInPath
        let expandedPath2 = (path2 as NSString).expandingTildeInPath
        let url1 = URL(fileURLWithPath: expandedPath1)
        let url2 = URL(fileURLWithPath: expandedPath2)

        do {
            image1 = loadImageFrom(path1)
            image2 = loadImageFrom(path2)

            if image1 == nil {
                image1 = try url1.getNSImage()
            }

            if image2 == nil {
                image2 = try url2.getNSImage()
            }
        } catch {
            showAlertWithMessage("Failed to load image from path: \(error)")
        }
    }

    private func createDifferenceImage(first: NSImage, second: NSImage) -> (NSImage?, Bool) {
        guard let firstCIImage = CIImage(data: first.tiffRepresentation ?? Data()),
              let secondCIImage = CIImage(data: second.tiffRepresentation ?? Data()) else {
            return (nil, false)
        }

        // Create the difference filter
        let differenceFilter = CIFilter.differenceBlendMode()
        differenceFilter.inputImage = firstCIImage
        differenceFilter.backgroundImage = secondCIImage

        guard let outputImage = differenceFilter.outputImage else {
            return (nil, false)
        }

        // Render the difference output to a bitmap
        let context = CIContext()
        guard let outputBitmap = context.createCGImage(outputImage, from: outputImage.extent) else {
            return (nil, false)
        }

        // Calculate the sum of differences in pixel values
        let width = outputBitmap.width
        let height = outputBitmap.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = bytesPerRow * height
        var pixelBuffer = [UInt8](repeating: 0, count: totalBytes)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapContext = CGContext(
            data: &pixelBuffer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        bitmapContext?.draw(outputBitmap, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Sum up the pixel differences
        var totalDifference: Int = 0
        for i in stride(from: 0, to: totalBytes, by: bytesPerPixel) {
            let r = Int(pixelBuffer[i])
            let g = Int(pixelBuffer[i + 1])
            let b = Int(pixelBuffer[i + 2])
            totalDifference += r + g + b
        }

        // If the total difference is zero, images are identical
        let areIdentical = (totalDifference == 0)

        // Create the output difference image if not identical
        if !areIdentical {
            let rep = NSCIImageRep(ciImage: outputImage)
            let nsImage = NSImage(size: rep.size)
            nsImage.addRepresentation(rep)
            return (nsImage, areIdentical)
        }

        return (first, true)
    }

    private func showAlertWithMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }

    private func loadImageFrom(_ fileURLString: String) -> NSImage? {
        guard let fileURL = URL(string: fileURLString) else {
            print("Invalid file URL string")
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            if let image = NSImage(data: data) {
                print("Image loaded successfully")
                return image
            } else {
                print("Failed to create image from data")
            }
        } catch {
            print("Error reading data from file: \(error)")
        }

        return nil
    }
}

private extension URL {
    enum AccessError: Error {
        case noAccessToResource(String)
    }

    func getNSImage() throws -> NSImage? {
        guard startAccessingSecurityScopedResource() else {
            throw AccessError.noAccessToResource(absoluteString)
        }
        defer {
            stopAccessingSecurityScopedResource()
        }

        let decodedPath = path.removingPercentEncoding
        let fileURL = URL(fileURLWithPath: decodedPath ?? path)

        return NSImage(contentsOf: fileURL)
    }
}
