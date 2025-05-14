//
//  mdcXUITests.swift
//  mdcXUITests
//
//  Created by 이지안 on 5/9/25.
//

import XCTest

final class mdcXUITests: XCTestCase {

    override func setUpWithError() throws {
        // 在这里放置设置代码。这个方法在类中每个测试方法调用之前被调用。

        // 在UI测试中，当失败发生时立即停止通常是最好的。
        continueAfterFailure = false

        // 在UI测试中，在测试运行之前设置所需的初始状态（如界面方向）是很重要的。setUp方法是做这个的好地方。
    }

    override func tearDownWithError() throws {
        // 在这里放置清理代码。这个方法在类中每个测试方法调用之后被调用。
    }

    @MainActor
    func testExample() throws {
        // UI测试必须启动它们测试的应用程序。
        let app = XCUIApplication()
        app.launch()

        // 使用XCTAssert和相关函数来验证你的测试产生正确的结果。
    }
    
    @MainActor
    func testMainNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 测试主导航功能
        XCTAssertTrue(app.navigationBars["iOS文件调整工具"].exists, "主标题应显示")
        
        // 测试分类区域存在
        XCTAssertTrue(app.staticTexts["程序坞"].exists, "程序坞分类应存在")
        XCTAssertTrue(app.staticTexts["界面元素"].exists, "界面元素分类应存在")
        
        // 测试调整项显示
        XCTAssertTrue(app.staticTexts["隐藏程序坞背景"].exists, "应显示隐藏程序坞背景调整项")
    }
    
    @MainActor
    func testTweakInteraction() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 找到一个调整项并点击其操作按钮
        if let tweakButton = app.buttons["hammer.circle.fill"].firstMatch {
            tweakButton.tap()
            // 验证状态变化（注意：这里只能检查UI变化，而非实际文件操作）
            let statusExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '成功' OR label CONTAINS '失败'")).firstMatch.waitForExistence(timeout: 5)
            XCTAssertTrue(statusExists, "应显示操作状态")
        } else {
            XCTFail("未找到调整操作按钮")
        }
    }
    
    @MainActor
    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 假设我们有顶部导航栏和标签切换功能
        if let tabBar = app.tabBars.firstMatch {
            // 测试切换到预设视图
            if let presetTab = tabBar.buttons["调整预设"] {
                presetTab.tap()
                XCTAssertTrue(app.navigationBars["调整预设"].waitForExistence(timeout: 2), "应切换到预设视图")
            }
            
            // 测试切换到备份视图
            if let backupTab = tabBar.buttons["备份管理"] {
                backupTab.tap()
                XCTAssertTrue(app.navigationBars["备份管理"].waitForExistence(timeout: 2), "应切换到备份视图")
            }
            
            // 返回主视图
            if let mainTab = tabBar.buttons["调整"] {
                mainTab.tap()
                XCTAssertTrue(app.navigationBars["iOS文件调整工具"].waitForExistence(timeout: 2), "应返回主视图")
            }
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        // 这测量启动应用程序需要多长时间。
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
