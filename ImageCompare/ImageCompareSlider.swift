//
//  ImageCompareSlider.swift
//  ImageCompare
//
//  Created by iurii int on 18.10.2024.

import SwiftUI

struct ImageCompareSlider: View {
    let image1: NSImage
    let image2: NSImage

    @State private var sliderPosition: Double = 100
    @State private var imageWidth: Double = 100 {
        didSet {
            sliderPosition = clamp(minValue: 0, maxValue: imageWidth, value: sliderPosition)
        }
    }

    private let sliderSpace = "sliderSpace"

    var body: some View {
        ZStack(alignment: .leading) {
            Image(nsImage: image1)
                .resizable()
                .aspectRatio(contentMode: .fit)

            Image(nsImage: image2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(
                    GeometryReader { imageGeometry in
                        Color.clear
                            .onAppear {
                                imageWidth = imageGeometry.size.width
                            }
                            .onChange(of: imageGeometry.size) { _, newValue in
                                if newValue.width != imageWidth {
                                    imageWidth = newValue.width
                                }
                            }
                    }
                )
                .mask {
                    mask
                }
                .coordinateSpace(.named(sliderSpace))
        }
        .background(Color.gray)
        .overlay(alignment: .leading) {
            sliderView
        }
        .padding()
    }

    private var mask: some View {
        GeometryReader { innerGeometry in
            Rectangle()
                .offset(x: sliderPosition)
        }
    }

    private var sliderView: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 4)
            .overlay(
                Circle()
                    .fill(Color.white)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: 30)
            )
            .gesture(
                DragGesture(coordinateSpace: .named(sliderSpace))
                    .onChanged { value in
                        sliderPosition = clamp(minValue: 0, maxValue: imageWidth, value: sliderPosition + value.translation.width)
                    }
            )
            .offset(x: sliderPosition)
    }
}

#Preview {
    ImageCompareSlider(
        image1: NSImage(named: "1")!,
        image2: NSImage(named: "2")!
    )
}
