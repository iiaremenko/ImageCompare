//
//  ClampTests.swift
//  ImageCompareTests
//
//  Created by iurii int on 25.10.2024.
//

import Testing
@testable import ImageCompare

struct ClampTests {

    @Test func testClampWithinRange() {
        // Test a value within the range; it should return the value itself
        #expect(clamp(minValue: 0, maxValue: 10, value: 5) == 5, "Value within range should return the value itself")
    }

    @Test func testClampBelowRange() {
        // Test a value below the minimum; it should return the minimum
        #expect(clamp(minValue: 0, maxValue: 10, value: -5) == 0, "Value below range should return the minimum")
    }

    @Test func testClampAboveRange() {
        // Test a value above the maximum; it should return the maximum
        #expect(clamp(minValue: 0, maxValue: 10, value: 15) == 10, "Value above range should return the maximum")
    }

    @Test func testClampWithEqualMinAndMax() {
        // Test when min and max are the same; it should return the same value (equal to min and max)
        #expect(clamp(minValue: 5, maxValue: 5, value: 3) == 5, "When min and max are the same, it should return that value")
        #expect(clamp(minValue: 5, maxValue: 5, value: 7) == 5, "When min and max are the same, it should return that value")
    }

    @Test func testClampWithNegativeRange() {
        // Test with negative boundaries and values
        #expect(clamp(minValue: -10, maxValue: -5, value: -7) == -7, "Value within negative range should return the value itself")
        #expect(clamp(minValue: -10, maxValue: -5, value: -11) == -10, "Value below negative range should return the minimum")
        #expect(clamp(minValue: -10, maxValue: -5, value: -3) == -5, "Value above negative range should return the maximum")
    }

    @Test func testClampWithFloatingPointValues() {
        // Test with floating point values
        #expect(clamp(minValue: 0.0, maxValue: 10.0, value: 5.5) == 5.5, "Float value within range should return the value itself")
        #expect(clamp(minValue: 0.0, maxValue: 10.0, value: -1.0) == 0.0, "Float value below range should return the minimum")
        #expect(clamp(minValue: 0.0, maxValue: 10.0, value: 15.0) == 10.0, "Float value above range should return the maximum")
    }

}
