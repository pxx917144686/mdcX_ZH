//
//  mdcXUITestsLaunchTests.swift
//  mdcXUITests
//
//  由 이지안 创建于 5/9/25.
//

import XCTest

final class mdcXUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // 在此处插入应用启动后但截图前要执行的步骤，
        // 例如登录测试账户或在应用中导航到某处

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
