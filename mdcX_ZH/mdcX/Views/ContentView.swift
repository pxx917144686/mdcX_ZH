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
              isProcessing: false)
        
        /*Tweak(name: "☢️ 危险UIKitCore ☢️",
              description: "很危险！尝试清零核心UIKitCore材质资产目录。预计会出现广泛的UI破坏、视觉故障和潜在的应用/系统不稳定。很可能需要DFU恢复。仅适用于高级实验。",
              action: .zeroOutFiles(paths: [
                "/System/Library/PrivateFrameworks/UIKitCore.framework/Artwork/composited_Materials.car"
              ]),
              category: "☢️ 系统关键（危险）☢️", 
              status: "",
              isProcessing: false)*/
    ]
    @StateObject private var logStore = LogStore()
    @State private var isAnyTweakProcessing: Bool = false
    @State private var isRespringProcessing: Bool = false // 重启按钮的状态
    @State private var alertItem: AlertItem?
    
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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(sortedCategoryKeys, id: \.self) { categoryKey in
                        Section {
                            let indicesForCategory = tweaks.indices.filter { tweaks[$0].category == categoryKey }
                            ForEach(indicesForCategory, id: \.self) { indexInMainArray in
                                TweakRowView(
                                    tweak: $tweaks[indexInMainArray],
                                    isGloballyProcessing: $isAnyTweakProcessing,
                                    action: {
                                        self.applyTweak(id: tweaks[indexInMainArray].id)
                                    }
                                )
                            }
                        } header: {
                            Text(categoryKey)
                                .font(.title3.weight(.semibold))
                                .padding(.vertical, 5)
                        } footer: {
                            if categoryKey == sortedCategoryKeys.last && categoryKey == "声音" { // 示例：声音的特殊页脚
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
            .navigationTitle("iOS文件调整器")
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
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        applyAllTweaks()
                    } label: {
                        Text("应用全部")
                    }
                    .buttonStyle(CustomButtonStyle(color: .green, foregroundColor: .white, isDisabledStyle: isAnyTweakProcessing || isRespringProcessing || tweaks.contains(where: {$0.isProcessing})))
                    .disabled(isAnyTweakProcessing || isRespringProcessing || tweaks.contains(where: {$0.isProcessing}))
                }
            }
            .alert(item: $alertItem) { item in
                Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
            }
            .onAppear {
                exploitManager.logStore = self.logStore
            }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
