//
//  ImageCompareTests.swift
//  ImageCompareTests
//
//  Created by iurii int on 03.10.2024.
//

import Testing
@testable import ImageCompare
import class AppKit.NSImage

struct ImageCompareTests {

    @Test func identicalImages() async throws {
        let image1 = try #require(NSImage(named: "1"))

        let model = ImageComparisonViewModel(
            image1: image1,
            image2: image1
        )

        model.compareImages()

        #expect(model.isImagesIdentical == true)
        #expect(model.differenceImage != nil)
    }

    @Test func differentImages() async throws {
        let image1 = try #require(NSImage(named: "1"))
        let image2 = try #require(NSImage(named: "2"))

        let model = ImageComparisonViewModel(
            image1: image1,
            image2: image2
        )

        model.compareImages()

        #expect(model.isImagesIdentical == false)
        #expect(model.differenceImage != nil)
    }

}
