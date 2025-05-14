//
//  ContentView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tweaks: [Tweak] = [
        Tweak(name: "隐藏程序坞背景",
              description: "使程序坞背景透明。",
              longDescription: "这个调整通过清零程序坞背景材质文件来实现透明效果，适用于大多数iOS版本。修改后的程序坞将显示为完全透明，让壁纸可以完整显示。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe"
              ]),
              category: "程序坞", status: "", isProcessing: false, riskLevel: .low, compatibility: .good, tags: ["程序坞", "透明", "背景"]),
        
        Tweak(name: "修改主屏架子背景",
              description: "尝试更改主屏中的'架子'背景材质。可能影响程序坞或iPad应用程序架子。需要重启桌面。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/shelfBackground.materialrecipe"
              ]),
              category: "程序坞",
              status: "",
              isProcessing: false),
        
        Tweak(name: "移除搜索底部模糊",
              description: "尝试移除Spotlight搜索界面底部的模糊效果。需要重启桌面。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpotlightUIInternal.framework/bottomBlur.materialrecipe"
              ]),
              category: "搜索",
              status: "",
              isProcessing: false),
        
        Tweak(name: "透明界面元素",
              description: "使通知、媒体播放器背景透明。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeLight.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeDark.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/plattersDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platters.materialrecipe"
              ]),
              category: "界面元素", status: "", isProcessing: false),
        
        Tweak(name: "透明通知图标背景",
              description: "尝试使通知中应用图标背后的背景透明。影响亮/暗模式。需要重启桌面。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/avatarBackground.materialrecipe",
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/avatarBackgroundDark.materialrecipe"
              ]),
              category: "通知",
              status: "",
              isProcessing: false),
        
        Tweak(name: "隐藏文件夹背景",
              description: "使主屏幕文件夹背景透明。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe"
              ]),
              category: "界面元素", status: "", isProcessing: false),
        
        Tweak(name: "移除主屏编辑覆盖层",
              description: "尝试移除/更改编辑主屏幕时的覆盖层（如暗淡效果）（摇晃模式）。需要重启桌面。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/homeScreenOverlay.materialrecipe"
              ]),
              category: "界面元素",
              status: "",
              isProcessing: false),
        
        Tweak(name: "移除应用切换器模糊",
              description: "尝试移除应用切换器中的背景模糊效果。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-switcher.materialrecipe"
              ]),
              category: "界面元素", status: "", isProcessing: false),
        
        Tweak(name: "移除搜索模糊",
              description: "尝试移除Spotlight搜索（主屏幕）中的背景模糊效果。需要重启桌面。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightBlurBackground.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightLumSatBackground.materialrecipe"
              ]),
              category: "界面元素", 
              status: "",
              isProcessing: false),
        
        Tweak(name: "隐藏主页指示条",
              description: "尝试隐藏首页指示条。",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car"]),
              category: "界面元素", status: "", isProcessing: false),
        
        Tweak(name: "隐藏锁屏快捷键",
              description: "隐藏锁屏上的手电筒和相机按钮。",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car"]),
              category: "锁屏", status: "", isProcessing: false),
        
        Tweak(name: "Silence Charging Sound",
              description: "尝试通过定位常见和特定设备的声音文件来禁用充电连接声音。重启/SSV可能会恢复它。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/connect_power.caf",
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),
        
        Tweak(name: "Silence Lock Sound",
              description: "禁用锁定设备时的声音。",
              action: .zeroOutFiles(paths: ["/System/Library/Audio/UISounds/lock.caf"]),
              category: "Sounds",
              status: "",
              isProcessing: false),
        
        Tweak(name: "Silence Video Record Sounds",
              description: "禁用视频录制开始/结束时的声音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/begin_record.caf",
                "/System/Library/Audio/UISounds/end_record.caf"
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),
        
        Tweak(name: "Silence Photo Shutter Sounds",
              description: "禁用拍照和连拍的相机快门声音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/photoShutter.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
                "/System/Library/Audio/UISounds/nano/CameraShutter_Haptic.caf"
              ]),
              category: "Sounds",
              status: "",
              isProcessing: false),
        
        Tweak(name: "系统截图时无声音",
              description: "禁用截图时的相机快门声音。",
              longDescription: "此调整项通过清零截图声音文件来禁用iOS在截取屏幕截图时播放的相机快门声音。请注意，某些地区可能要求截图时有提示音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/screenshot.caf"
              ]),
              category: "声音", status: "", isProcessing: false, riskLevel: .low, compatibility: .good, tags: ["截图", "声音", "静音"]),
        
        Tweak(name: "隐藏控制中心显示器亮度",
              description: "从控制中心隐藏显示器亮度滑块。",
              longDescription: "此调整移除控制中心中的显示器亮度滑块模块。请注意这会影响调整屏幕亮度的便捷性。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/ControlCenterUI.framework/BrightnessModule.plist"
              ]),
              category: "控制中心", status: "", isProcessing: false, riskLevel: .medium, compatibility: .limited, tags: ["控制中心", "亮度"]),
        
        Tweak(name: "禁用充电声音和振动",
              description: "连接充电器时静音并禁用振动。",
              longDescription: "此调整通过修改系统声音文件，在连接充电器时禁用声音和触觉反馈。修改后，连接电源将不会发出任何提示。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/connect_power.caf",
                "/System/Library/Audio/UISounds/nano/Connect_Power_Haptic.caf"
              ]),
              category: "声音", status: "", isProcessing: false, riskLevel: .low, compatibility: .good, tags: ["充电", "声音", "振动", "静音"]),
        
        Tweak(name: "移除锁屏底部文字",
              description: "隐藏锁屏界面底部的\"向上轻扫解锁\"文字。",
              longDescription: "此调整通过修改系统资源文件，隐藏锁屏界面底部的提示文字，使锁屏界面看起来更加简洁。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardUI.framework/lockHint.materialrecipe"
              ]),
              category: "锁屏", status: "", isProcessing: false, riskLevel: .low, compatibility: .limited, tags: ["锁屏", "文字", "界面"]),
        
        Tweak(name: "移除相机快门声音",
              description: "拍照时静音相机快门声音。",
              longDescription: "此调整通过清零相机快门声音文件，使拍照时不再发出声音。请注意，在某些国家，静音相机快门声可能违反法律规定。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/photoShutter.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
              ]),
              category: "相机", status: "", isProcessing: false, riskLevel: .medium, compatibility: .good, tags: ["相机", "声音", "静音"]),
        
        Tweak(name: "自定义电池颜色",
              description: "更改电池图标的颜色显示。",
              longDescription: "此调整通过修改系统资源文件，自定义状态栏和控制中心电池图标的颜色样式。修改后可能需要重启才能完全生效。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/BatteryCenter.framework/Assets.car"
              ]),
              category: "电池", status: "", isProcessing: false, riskLevel: .medium, compatibility: .limited, tags: ["电池", "颜色", "状态栏"]),
    ]
    
    @StateObject private var logStore = LogStore()
    @State private var isAnyTweakProcessing: Bool = false
    @State private var isRespringProcessing: Bool = false // 重启桌面按钮的状态
    @State private var alertItem: AlertItem?
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var selectedCategory: String? = nil
    @State private var sortOrder: AppSettings.SortOrder = .category
    
    @ObservedObject private var settings = AppSettings.shared
    
    private let exploitManager = ExploitManager.shared
    
    private var filteredTweaks: [Tweak] {
        var result = tweaks
        
        // 筛选收藏夹
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        // 筛选分类
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // 搜索
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // 排序
        switch sortOrder {
        case .name:
            result.sort { $0.name < $1.name }
        case .category:
            result.sort { $0.category == $1.category ? $0.name < $1.name : $0.category < $1.category }
        case .lastUsed:
            result.sort { ($0.lastApplied ?? Date.distantPast) > ($1.lastApplied ?? Date.distantPast) }
        case .riskLevel:
            result.sort { $0.riskLevel.rawValue < $1.riskLevel.rawValue }
        }
        
        // 如果启用了，收藏项显示在前
        if settings.showFavoritesFirst && !showFavoritesOnly {
            let favorites = result.filter { $0.isFavorite }
            let nonFavorites = result.filter { !$0.isFavorite }
            result = favorites + nonFavorites
        }
        
        return result
    }
    
    private var groupedTweaks: [String: [Tweak]] {
        Dictionary(grouping: filteredTweaks, by: { $0.category })
    }
    
    private var sortedCategoryKeys: [String] {
        groupedTweaks.keys.sorted()
    }
    
    private var allCategories: [String] {
        Array(Set(tweaks.map { $0.category })).sorted()
    }
    
    private func applyTweak(id: UUID) {
        guard let tweakIndex = tweaks.firstIndex(where: { $0.id == id }) else {
            logStore.append(message: "错误：未找到ID为 \(id) 的调整。")
            return
        }
        guard !tweaks[tweakIndex].isProcessing && !isAnyTweakProcessing && !isRespringProcessing else {
            logStore.append(message: "操作已在进行中：\(tweaks[tweakIndex].name) 或其他任务。")
            return
        }
        
        // 自动备份检查
        if settings.autoBackupBeforeTweak {
            createBackupBeforeTweak(tweaks[tweakIndex])
        }
        
        // 高风险警告
        if tweaks[tweakIndex].riskLevel == .high && settings.riskLevelWarning {
            confirmHighRiskTweak(tweaks[tweakIndex])
            return
        }
        
        executeTweak(tweakIndex: tweakIndex)
    }
    
    private func createBackupBeforeTweak(_ tweak: Tweak) {
        // 实现自动备份逻辑
        if let paths = tweak.getFilePaths(), !paths.isEmpty {
            let backupName = "应用前备份_\(tweak.name)"
            let backupDescription = "在应用调整'\(tweak.name)'前自动创建的备份"
            
            BackupManager.shared.createBackup(
                name: backupName,
                files: paths,
                description: backupDescription
            ) { success, message in
                logStore.append(message: "自动备份: \(message)")
            }
        }
    }
    
    private func confirmHighRiskTweak(_ tweak: Tweak) {
        alertItem = AlertItem(
            title: Text("高风险调整"),
            message: Text("\"\(tweak.name)\"被标记为高风险调整，可能会导致系统不稳定或需要恢复设备。确定要继续吗？"),
            primaryButton: .destructive(Text("继续")) {
                if let index = tweaks.firstIndex(where: { $0.id == tweak.id }) {
                    executeTweak(tweakIndex: index)
                }
            },
            secondaryButton: .cancel()
        )
    }
    
    private func executeTweak(tweakIndex: Int) {
        tweaks[tweakIndex].isProcessing = true
        tweaks[tweakIndex].status = "处理中..."
        exploitManager.logStore = self.logStore
        
        exploitManager.applyFileZeroTweak(tweaks[tweakIndex],
                                          zeroAllFilePages: false) { successCount, totalFiles, resultsLog in
            if tweaks.indices.contains(tweakIndex) {
                tweaks[tweakIndex].status = "\(successCount)/\(totalFiles) 成功"
                tweaks[tweakIndex].lastApplied = Date()
                
                if !resultsLog.isEmpty {
                    self.logStore.append(message: "'\(tweaks[tweakIndex].name)'的结果:\n\(resultsLog)")
                }
                
                tweaks[tweakIndex].isProcessing = false
                
                // 如果需要重启桌面，提示用户
                if tweaks[tweakIndex].requiresRespring && successCount > 0 {
                    alertItem = AlertItem(
                        title: Text("需要重启桌面"),
                        message: Text("调整'\(tweaks[tweakIndex].name)'已应用，但需要重启桌面才能完全生效。是否立即重启？"),
                        primaryButton: .default(Text("立即重启")) {
                            triggerCFNotificationRespring()
                        },
                        secondaryButton: .cancel(Text("稍后"))
                    )
                }
            }
        }
    }
    
    private func applyAllTweaks() {
        guard !isAnyTweakProcessing && !isRespringProcessing && !tweaks.contains(where: { $0.isProcessing }) else {
            logStore.append(message: "操作已在进行中。")
            return
        }
        
        // 确认对话框
        alertItem = AlertItem(
            title: Text("确认批量操作"),
            message: Text("您确定要应用所有显示的\(filteredTweaks.count)个调整吗？这可能需要一段时间，并且可能影响系统稳定性。"),
            primaryButton: .destructive(Text("应用全部")) {
                executeBatchApply()
            },
            secondaryButton: .cancel()
        )
    }
    
    private func executeBatchApply() {
        logStore.append(message: "开始应用所有筛选的调整项...")
        isAnyTweakProcessing = true
        exploitManager.logStore = self.logStore
        
        let tweaksToApply = filteredTweaks
        let group = DispatchGroup()
        var summary = ""
        
        for filteredTweak in tweaksToApply {
            if let index = tweaks.firstIndex(where: { $0.id == filteredTweak.id }) {
                if tweaks[index].isProcessing { continue }
                
                tweaks[index].isProcessing = true
                tweaks[index].status = "批处理中..."
                
                group.enter()
                exploitManager.applyFileZeroTweak(tweaks[index],
                                                  zeroAllFilePages: false) { successCount, totalFiles, _ in
                    if self.tweaks.indices.contains(index) {
                        self.tweaks[index].status = "批处理: \(successCount)/\(totalFiles) 成功"
                        self.tweaks[index].lastApplied = Date()
                        summary += "\(self.tweaks[index].name): \(self.tweaks[index].status)\n"
                        self.tweaks[index].isProcessing = false
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            logStore.append(message: "所有调整批处理已完成。\n摘要:\n\(summary)")
            isAnyTweakProcessing = false
            
            // 询问是否重启
            alertItem = AlertItem(
                title: Text("批量应用完成"),
                message: Text("所有调整项已应用。为确保所有更改生效，建议重启桌面。是否立即重启？"),
                primaryButton: .default(Text("立即重启")) {
                    triggerCFNotificationRespring()
                },
                secondaryButton: .cancel(Text("稍后"))
            )
        }
    }
    
    private func triggerCFNotificationRespring() {
        guard !isRespringProcessing && !isAnyTweakProcessing && !tweaks.contains(where: {$0.isProcessing}) else {
            logStore.append(message: "另一个操作正在进行中。")
            return
        }
        isRespringProcessing = true
        logStore.append(message: "尝试通过CFNotificationCenter重启桌面...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            RespringHelper.attemptDarwinRespring()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { 
                logStore.append(message: "已发送重启桌面通知。如果设备没有重启，此方法可能在您的iOS版本上无效。")
                isRespringProcessing = false
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 主内容页面
            NavigationView {
                VStack(spacing: 0) {
                    // 分类选择器
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryButton(
                                title: "全部",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            CategoryButton(
                                title: "收藏",
                                icon: "star.fill",
                                isSelected: showFavoritesOnly,
                                action: { 
                                    showFavoritesOnly.toggle()
                                    if showFavoritesOnly {
                                        selectedCategory = nil
                                    }
                                }
                            )
                            
                            ForEach(allCategories, id: \.self) { category in
                                CategoryButton(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    action: { 
                                        if selectedCategory == category {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category
                                            showFavoritesOnly = false
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    
                    List {
                        if filteredTweaks.isEmpty {
                            Text("未找到符合条件的调整项")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(sortedCategoryKeys, id: \.self) { categoryKey in
                                Section {
                                    let tweaksForCategory = groupedTweaks[categoryKey] ?? []
                                    ForEach(tweaksForCategory) { tweak in
                                        TweakRowView(
                                            tweak: binding(for: tweak),
                                            isGloballyProcessing: $isAnyTweakProcessing,
                                            action: {
                                                self.applyTweak(id: tweak.id)
                                            }
                                        )
                                    }
                                } header: {
                                    Text(categoryKey)
                                        .font(.title3.weight(.semibold))
                                        .padding(.vertical, 5)
                                } footer: {
                                    if categoryKey == sortedCategoryKeys.last && categoryKey == "声音" {
                                        Text("注意：在某些地区，静音相机快门声可能会有法律或社会影响。请注意当地习俗。")
                                            .font(.caption2)
                                            .foregroundColor(.orange)
                                            .padding(.vertical, 5)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    if categoryKey == sortedCategoryKeys.last {
                                        Text("需要手动重启桌面/重启设备才能使更改生效。请谨慎使用。")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    LogView(logMessages: $logStore.messages, logStore: logStore)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .padding(.top, 8)
                }
                .navigationTitle("iOS文件调整工具")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Menu {
                            Picker("排序方式", selection: $sortOrder) {
                                ForEach(AppSettings.SortOrder.allCases) { order in
                                    Text(order.rawValue).tag(order)
                                }
                            }
                            
                            Divider()
                            
                            Button(action: {
                                self.alertItem = AlertItem(
                                    title: Text("确认重启桌面"),
                                    message: Text("这将尝试使用CFNotification进行重启。可能不适用于所有iOS版本。是否继续？"),
                                    primaryButton: .destructive(Text("尝试重启桌面")) {
                                        triggerCFNotificationRespring()
                                    },
                                    secondaryButton: .cancel(Text("取消"))
                                )
                            }) {
                                Label("重启桌面", systemImage: "arrow.triangle.2.circlepath.circle.fill")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            applyAllTweaks()
                        } label: {
                            Text("应用全部")
                        }
                        .buttonStyle(CustomButtonStyle(color: .green, foregroundColor: .white, isDisabledStyle: isAnyTweakProcessing || isRespringProcessing || tweaks.contains(where: {$0.isProcessing})))
                        .disabled(isAnyTweakProcessing || isRespringProcessing || tweaks.contains(where: {$0.isProcessing}) || filteredTweaks.isEmpty)
                    }
                }
                .searchable(text: $searchText, prompt: "搜索调整项...")
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty && !settings.recentSearchTerms.contains(newValue) {
                        settings.addRecentSearch(newValue)
                    }
                }
                .alert(item: $alertItem) { item in
                    Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
                }
                .onAppear {
                    exploitManager.logStore = self.logStore
                    sortOrder = settings.defaultSortOrder
                }
            }
            .tabItem {
                Label("调整", systemImage: "hammer.fill")
            }
            .tag(0)
            
            // 预设标签
            NavigationView {
                PresetView(logStore: logStore)
            }
            .tabItem {
                Label("预设", systemImage: "star.square.fill")
            }
            .tag(1)
            
            // 备份标签
            NavigationView {
                BackupView(logStore: logStore)
            }
            .tabItem {
                Label("备份", systemImage: "externaldrive.fill")
            }
            .tag(2)
            
            // 设置标签
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gear")
            }
            .tag(3)
        }
        .accentColor(settings.accentColor)
        .preferredColorScheme(settings.colorScheme)
    }
    
    // 帮助函数：获取特定调整项的绑定
    private func binding(for tweak: Tweak) -> Binding<Tweak> {
        guard let index = tweaks.firstIndex(where: { $0.id == tweak.id }) else {
            fatalError("找不到调整项的索引")
        }
        return $tweaks[index]
    }
}

struct CategoryButton: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color(UIColor.systemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ContentView()
}
