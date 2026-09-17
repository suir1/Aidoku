//
//  UpscaleTileLayout.swift
//  Aidoku
//

import Foundation

struct UpscaleTile: Equatable {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

struct UpscaleTileLayout {
    let tileSize: Int
    let overlap: Int

    private var stride: Int {
        max(1, tileSize - overlap)
    }

    func starts(for length: Int) -> [Int] {
        guard length > 0 else { return [] }

        var result = [0]
        while let last = result.last, last + tileSize < length {
            result.append(last + stride)
        }
        return result
    }

    func tiles(width: Int, height: Int) -> [UpscaleTile] {
        starts(for: height).flatMap { y in
            starts(for: width).map { x in
                UpscaleTile(
                    x: x,
                    y: y,
                    width: min(tileSize, width - x),
                    height: min(tileSize, height - y)
                )
            }
        }
    }

    static func cosineRamp(length: Int) -> [Float] {
        guard length > 0 else { return [] }
        return (0..<length).map { index in
            let position = Double(index * 2 + 1) / Double(length * 2)
            return Float(0.5 - 0.5 * cos(.pi * position))
        }
    }
}
