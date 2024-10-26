import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - View
struct ContentView: View {
    @State var viewModel = ImageComparisonViewModel()

    // Private UI values
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0

    @State private var imageOffset: CGSize = .zero
    @State private var lastImageOffset: CGSize = .zero

    var body: some View {
        VStack {
            HStack {
                ImageSelectorView(
                    title: "Select First Image",
                    buttonAction: {
                        viewModel.imageSelectionTapped(side: .left)
                    },
                    image: $viewModel.image1
                )

                ImageSelectorView(
                    title: "Select Second Image",
                    buttonAction: {
                        viewModel.imageSelectionTapped(side: .right)
                    },
                    image: $viewModel.image2
                )
            }

            Button("Compare Images") {
                viewModel.compareImages()
            }
            .padding(.top, 20)

            diffModePicker

            diffSection
        }
        .fileImporter(isPresented: $viewModel.showingImporter, allowedContentTypes: ImageComparisonViewModel.allowedContentTypes) { result in
            viewModel.handleFileImport(result: result)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.onAppear()
        }
        .padding()
    }

    @ViewBuilder
    var diffSection: some View {
        switch viewModel.diffMode {

        case .difference:
            if let differenceImage = viewModel.differenceImage {
                diffView(differenceImage: differenceImage)
                    .frame(minHeight: 400)
            } else {
                Text("No Difference Image Available")
                    .padding(.top, 20)
            }

        case .hSlider:
            if let image1 = viewModel.image1, let image2 = viewModel.image2 {
                ImageCompareSlider(
                    image1: image1,
                    image2: image2
                )
            } else {
                Text("Please drop or select both images")
            }
        }
    }

    var diffModePicker: some View {
        Picker("Diff Mode", selection: $viewModel.diffMode) {
            Text("Difference").tag(ImageComparisonViewModel.DiffMode.difference)
            Text("Slider").tag(ImageComparisonViewModel.DiffMode.hSlider)
        }
    }

    func diffView(differenceImage: NSImage) -> some View {
        VStack {
            Text(viewModel.isImagesIdentical == true ? "Images are identical" : "Difference Image")
                .font(.headline)
                .padding(.top, 20)

            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    Image(nsImage: differenceImage)
                        .resizable()
                        .scaledToFit()
                        .offset(imageOffset)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        zoomScale = max(min(lastZoomScale * value, 5.0), 1.0)
                                    }
                                    .onEnded { _ in
                                        lastZoomScale = zoomScale
                                    },
                                DragGesture()
                                    .onChanged { value in
                                        imageOffset = CGSize(
                                            width: lastImageOffset.width + value.translation.width,
                                            height: lastImageOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastImageOffset = imageOffset
                                    }
                            )
                        )
                        .frame(height: max(geometry.size.height, geometry.size.height * zoomScale))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .border(Color.green, width: 2)
            }
        }
    }
}

#Preview {
    ContentView(
        viewModel: .init(
            image1: NSImage(named: "1")!,
            image2: NSImage(named: "2")!
        )
    )
    .frame(height: 1000)
}
