//
//  LeaksTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet
import UIKit

@Suite("Leaks Tests")
struct LeaksTests {

  @Test @MainActor
  func memoryLeak() async throws {
    var bottomSheet: DynamicBottomSheet? = DynamicBottomSheet()
    weak var weakBottomSheet: DynamicBottomSheet? = bottomSheet

    let view = UIView()
    view.addSubview(bottomSheet!)

    bottomSheet = nil
    weakBottomSheet!.detents.initialPosition = .bottom()

    weakBottomSheet!.removeFromSuperview()

    try await Task.sleep(nanoseconds: 100_000_000)

    #expect(weakBottomSheet == nil)
  }

  @Test @MainActor
  func detentsLeak() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.detents.bottomSheet === bottomSheet)
  }

  @Test @MainActor
  func scrollViewIntegrationTests() {
    let bottomSheet: DynamicBottomSheet? = DynamicBottomSheet()
    var scrollView: TestScrollContent? = TestScrollContent()

    bottomSheet!.scrollingContent = scrollView!

    scrollView = nil
    #expect(bottomSheet!.scrollingContent == nil)
  }

  private final class TestScrollContent: DynamicBottomSheet.ScrollingContent {
    var contentOffset: CGPoint = .zero
    func stopScrolling() {}
  }

}

