//
//  UpscaleTileLayoutTests.swift
//  AidokuTests
//

@testable import Aidoku
import Testing

struct UpscaleTileLayoutTests {
    @Test("Overlap layout covers a manga page with the expected tiles")
    func overlapLayout() {
        let layout = UpscaleTileLayout(tileSize: 256, overlap: 20)

        #expect(layout.starts(for: 1_500) == [0, 236, 472, 708, 944, 1_180, 1_416])
        #expect(layout.starts(for: 2_250) == [0, 236, 472, 708, 944, 1_180, 1_416, 1_652, 1_888, 2_124])
        #expect(layout.tiles(width: 1_500, height: 2_250).count == 70)
    }

    @Test("The final tile is cropped to the image bounds")
    func edgeTile() throws {
        let layout = UpscaleTileLayout(tileSize: 256, overlap: 20)
        let last = try #require(layout.tiles(width: 1_500, height: 2_250).last)

        #expect(last.x == 1_416)
        #expect(last.y == 2_124)
        #expect(last.width == 84)
        #expect(last.height == 126)
    }

    @Test("An image smaller than one tile produces one cropped tile")
    func smallImage() {
        let layout = UpscaleTileLayout(tileSize: 256, overlap: 20)

        #expect(layout.tiles(width: 200, height: 180) == [
            UpscaleTile(x: 0, y: 0, width: 200, height: 180)
        ])
        #expect(layout.starts(for: 256) == [0])
        #expect(layout.starts(for: 492) == [0, 236])
    }

    @Test("Cosine feather weights are complementary")
    func complementaryFeatherWeights() {
        let weights = UpscaleTileLayout.cosineRamp(length: 40)

        #expect(weights.count == 40)
        for index in weights.indices {
            #expect(abs(weights[index] + weights[39 - index] - 1) < 0.000_001)
        }
    }

    @Test("Four corner weights normalize to one")
    func cornerWeightsNormalize() {
        let weights = UpscaleTileLayout.cosineRamp(length: 40)

        for x in weights {
            for y in weights {
                let sum = (1 - x) * (1 - y) + x * (1 - y) + (1 - x) * y + x * y
                #expect(abs(sum - 1) < 0.000_001)
            }
        }
    }
}
