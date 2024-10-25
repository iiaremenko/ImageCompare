//
//  Clamp.swift
//  ImageCompare
//
//  Created by iurii int on 25.10.2024.
//

import Foundation

func clamp<T>(minValue: T, maxValue: T, value: T) -> T where T : Comparable {
    max(minValue, min(maxValue, value))
}
