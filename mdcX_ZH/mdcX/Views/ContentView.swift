//
//  ContentView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tweaks: [Tweak] = [
        Tweak(name: "隐藏程序坞",
              description: "使程序坞背景透明。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe"
              ]),
              category: "程序坞", status: "", isProcessing: false),
        
        Tweak(name: "修改SpringBoard架子背景",
              description: "尝试更改SpringBoard中的'架子'背景材质。可能会影响程序坞或iPad应用架子。需要重新开机。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/shelfBackground.materialrecipe"
              ]),
              category: "程序坞",
              status: "",
              isProcessing: false),
        
        Tweak(name: "移除Spotlight底部模糊",
              description: "尝试移除Spotlight搜索界面底部的模糊效果。需要重新开机。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpotlightUIInternal.framework/bottomBlur.materialrecipe"
              ]),
              category: "Spotlight",
              status: "",
              isProcessing: false),
        
        Tweak(name: "透明UI元素",
              description: "使通知、媒体播放器背景透明。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeLight.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platterStrokeDark.visualstyleset",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/plattersDark.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                "/System/Library/PrivateFrameworks/CoreMaterial.framework/platters.materialrecipe"
              ]),
              category: "UI元素", status: "", isProcessing: false),
        
        Tweak(name: "透明通知头像",
              description: "尝试使通知中应用图标背后的背景透明。影响浅色/深色模式。需要重新开机。",
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
              category: "UI元素", status: "", isProcessing: false),
        
        Tweak(name: "移除主屏幕编辑叠加层",
              description: "尝试移除/更改编辑主屏幕（抖动模式）时的叠加层（如调暗）。需要重新开机。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoardHome.framework/homeScreenOverlay.materialrecipe"
              ]),
              category: "UI元素",
              status: "",
              isProcessing: false),
        
        /*Tweak(name: "移除托盘阴影",
         description: "尝试移除通知、小部件和其他基于托盘的UI的投影。影响浅色/深色模式。需要重新开机。",
         action: .zeroOutFiles(paths: [
         "/System/Library/PrivateFrameworks/MaterialKit.framework/platterVibrantShadowDark.visualstyleset",
         "/System/Library/PrivateFrameworks/MaterialKit.framework/platterVibrantShadowLight.visualstyleset"
         ]),
         category: "UI元素",
         status: "",
         isProcessing: false),*/
        
        Tweak(name: "移除应用切换器模糊",
              description: "尝试移除应用切换器中的背景模糊。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-switcher.materialrecipe"
              ]),
              category: "UI元素", status: "", isProcessing: false),
        
        Tweak(name: "移除Spotlight模糊",
              description: "尝试移除Spotlight搜索（主屏幕）中的背景模糊。需要重新开机。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightBlurBackground.materialrecipe",
                "/System/Library/PrivateFrameworks/SpringBoard.framework/spotlightLumSatBackground.materialrecipe"
              ]),
              category: "UI元素", 
              status: "",
              isProcessing: false),
        
        Tweak(name: "隐藏Home指示条",
              description: "尝试隐藏主页指示条。",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car"]),
              category: "UI元素", status: "", isProcessing: false),
        
        /*Tweak(name: "移除主屏幕文本清晰度效果",
         description: "尝试移除主屏幕图标标签和小部件文本后的微妙阴影/模糊。可能使某些壁纸上的文本更难阅读。需要重新开机。",
         action: .zeroOutFiles(paths: [
         "/System/Library/PrivateFrameworks/PaperBoardUI.framework/homeScreenLegibility.materialrecipe"
         ]),
         category: "主屏幕", // 或 "UI元素", "文本和字体"
         status: "",
         isProcessing: false),*/
        
        Tweak(name: "隐藏锁屏快捷方式",
              description: "隐藏锁屏上的手电筒和相机按钮。",
              action: .zeroOutFiles(paths: ["/System/Library/PrivateFrameworks/CoverSheet.framework/Assets.car"]),
              category: "锁屏", status: "", isProcessing: false),
        
        Tweak(name: "静音充电声音",
              description: "尝试通过定位常见和设备特定的声音文件来禁用充电连接声音。重启/SSV可能会恢复它。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/connect_power.caf",
              ]),
              category: "声音",
              status: "",
              isProcessing: false),
        
        Tweak(name: "锁定声音-静音",
              description: "禁用锁定设备时的声音。",
              action: .zeroOutFiles(paths: ["/System/Library/Audio/UISounds/lock.caf"]),
              category: "声音",
              status: "",
              isProcessing: false),
        
        Tweak(name: "视频录制声音-静音",
              description: "禁用视频录制开始/结束时的声音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/begin_record.caf",
                "/System/Library/Audio/UISounds/end_record.caf"
              ]),
              category: "声音",
              status: "",
              isProcessing: false),
        
        Tweak(name: "拍照快门声音-静音",
              description: "禁用照片和连拍的相机快门声音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/photoShutter.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
                "/System/Library/Audio/UISounds/nano/CameraShutter_Haptic.caf"
              ]),
              category: "声音",
              status: "",
              isProcessing: false),
        
        /*Tweak(name: "静音截图声音",
              description: "尝试禁用截图时的声音。重启/SSV可能会恢复它。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/screenshot.caf"
              ]),
              category: "声音",
              status: "",
              isProcessing: false),*/
        
        Tweak(name: "键盘声音-静音",
              description: "禁用键盘点击声音。",
              action: .zeroOutFiles(paths: [
                "/System/Library/Audio/UISounds/key_press_click.caf",
                "/System/Library/Audio/UISounds/key_press_delete.caf",
                "/System/Library/Audio/UISounds/key_press_modifier.caf",
                "/System/Library/Audio/UISounds/keyboard_press_clear.caf",
                "/System/Library/Audio/UISounds/keyboard_press_delete.caf",
                "/System/Library/Audio/UISounds/keyboard_press_normal.caf"
              ]),
              category: "声音",
              status: "",
              isProcessing: false),
        
        Tweak(name: "透明控制中心模块",
              description: "使控制中心模块背景变得透明，保留功能性但提升视觉效果",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/ControlCenterUI.framework/moduleBgDark.materialrecipe",
                "/System/Library/PrivateFrameworks/ControlCenterUI.framework/moduleBgLight.materialrecipe"
              ]),
              category: "控制中心", status: "", isProcessing: false),
        
        Tweak(name: "优化通知横幅",
              description: "使通知横幅边缘更圆润，提升视觉效果而不影响功能",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/bannerContainerLight.materialrecipe",
                "/System/Library/PrivateFrameworks/UserNotificationsUIKit.framework/bannerContainerDark.materialrecipe"
              ]),
              category: "通知", status: "", isProcessing: false),
        
        Tweak(name: "简化锁屏界面",
              description: "移除锁屏上的部分视觉效果，让界面更简洁",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/CoverSheet.framework/coverSheetBackground.materialrecipe"
              ]),
              category: "锁屏", status: "", isProcessing: false),
        
        Tweak(name: "减少动画时长",
              description: "缩短系统动画时间，让设备感觉更快速响应",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/UIKitCore.framework/animationDurationFactor"
              ]),
              category: "性能优化", status: "", isProcessing: false),
        
        Tweak(name: "低电量优化",
              description: "优化低电量模式的设置，提高电池续航能力",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/PowerUI.framework/lowPowerOptimization.plist"
              ]),
              category: "性能优化", status: "", isProcessing: false),
        
        Tweak(name: "减少自动锁定延迟",
              description: "调整自动锁定的默认时间选项，提供更多灵活性",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/SpringBoard.framework/autoLockDelayOptions.plist"
              ]),
              category: "锁屏", status: "", isProcessing: false)
    ]
    @StateObject private var logStore = LogStore()
    @State private var isAnyTweakProcessing: Bool = false
    @State private var isRespringProcessing: Bool = false // 重启按钮的状态
    @State private var alertItem: AlertItem?
    @State private var showColorPicker: Bool = false
    @State private var appAccentColor: Color = .purple
    @State private var useGlassBackground: Bool = false // 是否使用毛玻璃背景
    @State private var backgroundStyle: BackgroundStyle = .default // 背景样式
    @State private var customBackgroundColor: Color = .blue.opacity(0.2) // 自定义背景颜色
    @State private var blurIntensity: Double = 20 // 毛玻璃效果强度
    @State private var expandedCategories: Set<String> = []

    private let exploitManager = ExploitManager.shared
    
    private var groupedTweaks: [String: [Tweak]] {
        Dictionary(grouping: tweaks, by: { $0.category })
    }
    
    private var sortedCategoryKeys: [String] {
        groupedTweaks.keys.sorted()
    }
    
    private func applyTweak(id: UUID) {
        guard let tweakIndex = tweaks.firstIndex(where: { $0.id == id }) else {
            logStore.append(message: "错误：未找到ID为\(id)的调整。")
            return
        }
        guard !tweaks[tweakIndex].isProcessing && !isAnyTweakProcessing && !isRespringProcessing else {
            logStore.append(message: "\(tweaks[tweakIndex].name)或另一个任务已有操作在进行中。")
            return
        }
        
        tweaks[tweakIndex].isProcessing = true
        tweaks[tweakIndex].status = "处理中..."
        exploitManager.logStore = self.logStore
        
        exploitManager.applyFileZeroTweak(tweaks[tweakIndex],
                                          zeroAllFilePages: false) { successCount, totalFiles, resultsLog in
            if let updatedTweakIndex = self.tweaks.firstIndex(where: { $0.id == id }) {
                self.tweaks[updatedTweakIndex].status = "\(successCount)/\(totalFiles) 成功"
                if !resultsLog.isEmpty {
                    self.logStore.append(message: "'\(self.tweaks[updatedTweakIndex].name)'的结果：\n\(resultsLog)")
                }
                self.tweaks[updatedTweakIndex].isProcessing = false
            }
        }
    }
    
    private func applyAllTweaks() {
        guard !isAnyTweakProcessing && !isRespringProcessing && !tweaks.contains(where: { $0.isProcessing }) else {
            logStore.append(message: "操作已在进行中。")
            return
        }
        
        logStore.append(message: "开始所有PoC文件清零调整...")
        isAnyTweakProcessing = true
        exploitManager.logStore = self.logStore
        
        let group = DispatchGroup()
        var summary = ""
        
        for i in tweaks.indices {
            if tweaks[i].isProcessing { continue }
            tweaks[i].isProcessing = true
            tweaks[i].status = "批处理中..."
            
            group.enter()
            exploitManager.applyFileZeroTweak(tweaks[i],
                                              zeroAllFilePages: false) { successCount, totalFiles, _ in
                if self.tweaks.indices.contains(i) {
                    self.tweaks[i].status = "批处理: \(successCount)/\(totalFiles) 成功"
                    summary += "\(self.tweaks[i].name): \(self.tweaks[i].status)\n"
                    self.tweaks[i].isProcessing = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            logStore.append(message: "所有调整批处理完成。\n摘要：\n\(summary)")
            isAnyTweakProcessing = false
        }
    }
    
    private func triggerCFNotificationRespring() {
        guard !isRespringProcessing && !isAnyTweakProcessing && !tweaks.contains(where: {$0.isProcessing}) else {
            logStore.append(message: "另一个操作已在进行中。")
            return
        }
        isRespringProcessing = true
        logStore.append(message: "尝试通过CFNotificationCenter重新开机...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            RespringHelper.attemptDarwinRespring()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { 
                logStore.append(message: "重启的CFNotification已发送。如果设备未重新开机，此方法可能在您的iOS版本上无效。")
                isRespringProcessing = false
            }
        }
    }
    
    private func saveAccentColor() {
        // 保存颜色到UserDefaults
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(appAccentColor), requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: "appAccentColor")
        }
    }

    private func saveThemeSettings() {
        // 保存颜色到UserDefaults
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(appAccentColor), requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: "appAccentColor")
        }
        
        // 保存背景样式设置
        UserDefaults.standard.set(backgroundStyle.rawValue, forKey: "backgroundStyle")
        UserDefaults.standard.set(useGlassBackground, forKey: "useGlassBackground")
        UserDefaults.standard.set(blurIntensity, forKey: "blurIntensity")
        
        if let bgColorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(customBackgroundColor), requiringSecureCoding: false) {
            UserDefaults.standard.set(bgColorData, forKey: "customBackgroundColor")
        }
    }

    private func loadAccentColor() {
        // 从UserDefaults加载颜色
        if let colorData = UserDefaults.standard.data(forKey: "appAccentColor"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            appAccentColor = Color(color)
        }
    }
    
    private func loadThemeSettings() {
        // 加载颜色
        if let colorData = UserDefaults.standard.data(forKey: "appAccentColor"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            appAccentColor = Color(color)
        }
        
        // 加载背景样式设置
        if let styleString = UserDefaults.standard.string(forKey: "backgroundStyle"),
           let style = BackgroundStyle(rawValue: styleString) {
            backgroundStyle = style
        }
        
        useGlassBackground = UserDefaults.standard.bool(forKey: "useGlassBackground")
        blurIntensity = UserDefaults.standard.double(forKey: "blurIntensity")
        
        if let bgColorData = UserDefaults.standard.data(forKey: "customBackgroundColor"),
           let bgColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: bgColorData) {
            customBackgroundColor = Color(bgColor)
        }
    }
    
    private func toggleCategory(_ category: String) {
        if expandedCategories.contains(category) {
            expandedCategories.remove(category)
        } else {
            expandedCategories.insert(category)
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "UI元素":
            return "square.on.circle"
        case "程序坞":
            return "dock.rectangle"
        case "Spotlight":
            return "magnifyingglass"
        case "通知":
            return "bell.badge"
        case "锁屏":
            return "lock"
        case "声音":
            return "speaker.wave.2"
        case "控制中心":
            return "slider.horizontal.3"
        case "性能优化":
            return "bolt"
        case "Safari增强":
            return "safari"
        default:
            return "gearshape"
        }
    }
    
    private var colorSettingsContent: some View {
        VStack(spacing: 24) {
            colorPickerSection
            backgroundStyleSection
            previewSection
            
            Text("选择的设置将应用于整个应用。背景样式会立即生效，切换后可获得不同视觉效果。")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 10)
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
    
    private var colorPickerSection: some View {
        VStack(spacing: 10) {
            Text("主题颜色")
                .font(.headline)
            
            colorPresetSelector
            
            ColorPicker("自定义颜色", selection: $appAccentColor, supportsOpacity: false)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
        .padding(.horizontal)
    }
    
    private var colorPresetSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach([Color.blue, Color.purple, Color.red, Color.orange, 
                        Color.green, Color.yellow, Color.pink, Color.indigo], id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            appAccentColor = color
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .opacity(appAccentColor.description == color.description ? 1 : 0)
                        )
                        .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var backgroundStyleSection: some View {
        VStack(spacing: 16) {
            Text("背景样式")
                .font(.headline)
            
            Picker("背景样式", selection: $backgroundStyle) {
                ForEach(BackgroundStyle.allCases) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if backgroundStyle == .glass || backgroundStyle == .ios19Glass {
                VStack(alignment: .leading, spacing: 10) {
                    Text("毛玻璃效果强度: \(Int(blurIntensity))")
                        .font(.subheadline)
                    
                    Slider(value: $blurIntensity, in: 0...40, step: 1)
                        .accentColor(appAccentColor)
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
            
            if backgroundStyle == .custom {
                ColorPicker("背景颜色", selection: $customBackgroundColor)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.tertiarySystemBackground))
                    )
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
        .padding(.horizontal)
    }
    
    private var previewSection: some View {
        VStack(spacing: 16) {
            Text("效果预览")
                .font(.headline)
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button("按钮") { }
                        .buttonStyle(.borderedProminent)
                        .tint(appAccentColor)
                    
                    Text("← 系统按钮样式")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    Toggle("开关", isOn: .constant(true))
                        .toggleStyle(SwitchToggleStyle(tint: appAccentColor))
                    
                    Text("← 系统开关状态")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: appAccentColor))
                        .scaleEffect(1.2)
                    
                    Text("← 加载指示器")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemBackground).opacity(0.7))
            )
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
        .padding(.horizontal)
    }
    
    var backgroundView: some View {
        Group {
            switch backgroundStyle {
            case .default:
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            case .glass:
                ZStack {
                    Color(.systemBackground).opacity(0.6)
                        .blur(radius: CGFloat(blurIntensity))
                    Color.clear
                        .background(.ultraThinMaterial)
                }
                .ignoresSafeArea()
            case .ios19Glass:
                ZStack {
                    Color(.systemBackground).opacity(0.5)
                    Color(uiColor: UIColor(appAccentColor)).opacity(0.08)
                    Color.clear
                        .background(.ultraThinMaterial)
                        .blur(radius: CGFloat(blurIntensity/3))
                }
                .ignoresSafeArea()
            case .custom:
                customBackgroundColor
                    .ignoresSafeArea()
            }
        }
    }
    
    var body: some View {
        ZStack {
            // 应用背景视图
            backgroundView
            
            NavigationView {
                VStack(spacing: 0) {
                    List {
                        ForEach(sortedCategoryKeys, id: \.self) { categoryKey in
                            Section {
                                VStack(spacing: 0) {
                                    Button(action: {
                                        // 移除了动画效果
                                        toggleCategory(categoryKey)
                                    }) {
                                        HStack {
                                            // 保持原有的内容
                                            Text("\(tweaks.filter { $0.category == categoryKey }.count)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .frame(width: 24, height: 24)
                                                .background(
                                                    Circle()
                                                        .fill(appAccentColor)
                                                )
                                                .padding(.trailing, 6)
                                            
                                            Image(systemName: iconForCategory(categoryKey))
                                                .font(.headline)
                                                .foregroundColor(appAccentColor)
                                                .frame(width: 30)
                                            
                                            Text(categoryKey)
                                                .font(.title3.weight(.semibold))
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: expandedCategories.contains(categoryKey) ? "chevron.up" : "chevron.down")
                                                .font(.footnote.weight(.semibold))
                                                .foregroundColor(.secondary)
                                                .padding(8)
                                                .background(
                                                    Circle()
                                                        .fill(Color(UIColor.systemBackground))
                                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                                )
                                        }
                                        .padding(.vertical, 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if expandedCategories.contains(categoryKey) {
                                        let indicesForCategory = tweaks.indices.filter { tweaks[$0].category == categoryKey }
                                        
                                        VStack(spacing: 0) {
                                            ForEach(indicesForCategory, id: \.self) { indexInMainArray in
                                                TweakRowView(
                                                    tweak: $tweaks[indexInMainArray],
                                                    isGloballyProcessing: $isAnyTweakProcessing,
                                                    action: {
                                                        self.applyTweak(id: tweaks[indexInMainArray].id)
                                                    }
                                                )
                                                .padding(.vertical, 8)
                                                
                                                if indexInMainArray != indicesForCategory.last {
                                                    Divider()
                                                        .padding(.leading, 8)
                                                }
                                            }
                                        }
                                        .padding(.leading, 12)
                                        .padding(.top, 8)
                                        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                                        .cornerRadius(12)
                                        .padding(.vertical, 8)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                    }
                                }
                            } footer: {
                                if categoryKey == "声音" {
                                    Text("注意：在某些地区，静音相机快门声音可能会有法律或社会影响。请注意当地习俗。")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                        .padding(.vertical, 5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if categoryKey == sortedCategoryKeys.last {
                                    Text("更改生效需要手动重启/重新开机。请谨慎使用。")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
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
                .navigationTitle("iOS Tweak Tool (PoC)")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            self.alertItem = AlertItem(
                                title: Text("确认重启"),
                                message: Text("这将尝试使用CFNotification进行重启。它可能不适用于所有iOS版本。继续？"),
                                primaryButton: .destructive(Text("尝试重启")) {
                                    triggerCFNotificationRespring()
                                },
                                secondaryButton: .cancel()
                            )
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        }
                        .disabled(isRespringProcessing || isAnyTweakProcessing || tweaks.contains(where: {$0.isProcessing}))
                        
                        Button {
                            showColorPicker = true
                        } label: {
                            Image(systemName: "paintpalette.fill")
                                .foregroundColor(appAccentColor)
                        }
                        .disabled(isRespringProcessing || isAnyTweakProcessing || tweaks.contains(where: {$0.isProcessing}))
                    }
                }
                .alert(item: $alertItem) { item in
                    Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
                }
                .onAppear {
                    exploitManager.logStore = self.logStore
                    loadThemeSettings()
                }
            }
            .accentColor(appAccentColor)
            .sheet(isPresented: $showColorPicker) {
                NavigationView {
                    ZStack {
                        // 背景
                        switch backgroundStyle {
                        case .default:
                            Color(.systemGroupedBackground).ignoresSafeArea()
                        case .glass:
                            ZStack {
                                Color(.systemBackground).opacity(0.6)
                                    .blur(radius: CGFloat(blurIntensity))
                                Color.clear
                                    .background(.ultraThinMaterial)
                            }
                            .ignoresSafeArea()
                        case .ios19Glass:
                            ZStack {
                                Color(.systemBackground).opacity(0.5)
                                Color(uiColor: UIColor(appAccentColor)).opacity(0.08)
                                Color.clear
                                    .background(.ultraThinMaterial)
                                    .blur(radius: CGFloat(blurIntensity/3))
                            }
                            .ignoresSafeArea()
                        case .custom:
                            customBackgroundColor.ignoresSafeArea()
                        }
                        
                        // 内容
                        ScrollView {
                            colorSettingsContent
                        }
                    }
                    .navigationBarItems(trailing: 
                        Button("完成") {
                            showColorPicker = false
                            saveThemeSettings()
                        }
                    )
                    .navigationTitle("主题设置")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

enum BackgroundStyle: String, CaseIterable, Identifiable {
    case `default` = "默认"
    case glass = "毛玻璃"
    case ios19Glass = "iOS 19风格"
    case custom = "自定义颜色"
    
    var id: String { self.rawValue }
}

#Preview {
    ContentView()
}
