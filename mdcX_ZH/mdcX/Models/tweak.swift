//
//  tweak.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

enum TweakActionType {
    case zeroOutFiles(paths: [String])
    case modifyPlist(path: String, key: String, value: Any)
    case executeCommand(command: String, args: [String])
}

enum TweakRiskLevel: String, Codable {
    case low = "低"
    case medium = "中"
    case high = "高"
    
    var localizedDescription: String {
        switch self {
        case .low:
            return "低 (安全)"
        case .medium:
            return "中 (小心使用)"
        case .high:
            return "高 (可能导致问题)"
        }
    }
}

enum TweakCompatibility: String, Codable {
    case good = "广泛兼容"
    case limited = "部分兼容"
    case unknown = "未知"
    case poor = "兼容性差"
}

struct Tweak: Identifiable {
    let id = UUID()
    var name: String
    var description: String?
    var longDescription: String?
    var action: TweakActionType
    var category: String
    var status: String = ""
    var isProcessing: Bool = false
    var isFavorite: Bool = false
    var riskLevel: TweakRiskLevel = .low
    var compatibility: TweakCompatibility = .unknown
    var tags: [String] = []
    var requiresRespring: Bool = true
    var lastApplied: Date?
    
    // 获取此调整影响的文件路径
    func getFilePaths() -> [String]? {
        switch action {
        case .zeroOutFiles(let paths):
            return paths
        case .modifyPlist(let path, _, _):
            return [path]
        case .executeCommand:
            return nil
        }
    }
    
    // 生成调整的唯一标识符，用于备份和还原
    func generateIdentifier() -> String {
        return "\(category)_\(name.replacingOccurrences(of: " ", with: "_"))"
    }
}

// 分类名称统一使用中文:
// "Dock" -> "程序坞"
// "UI Elements" -> "界面元素"
// "Lockscreen" -> "锁屏"
// "Sounds" -> "声音"
// "Control Center" -> "控制中心"
// "Spotlight" -> "搜索"
// "Notifications" -> "通知"
// "Home Screen" -> "主屏幕"
// "Security" -> "安全"
// "Battery" -> "电池"
// "Network" -> "网络"
// "Camera" -> "相机"
// "Keyboard" -> "键盘"

// 图标函数示例，支持中英文双重匹配
private func iconForCategory(_ category: String) -> String {
    switch category {
    case "程序坞", "Dock": return "menubar.dock.rectangle.badge.record"
    case "界面元素", "UI Elements": return "photo.on.rectangle.angled"
    case "锁屏", "Lockscreen": return "lock.display"
    case "声音", "Sounds": return "speaker.wave.2.fill"
    case "控制中心", "Control Center": return "switch.2"
    case "搜索", "Spotlight": return "magnifyingglass"
    case "通知", "Notifications": return "bell.badge.fill"
    case "主屏幕", "Home Screen": return "house.fill"
    case "安全", "Security": return "lock.shield.fill"
    case "电池", "Battery": return "battery.100.fill"
    case "网络", "Network": return "network"
    case "相机", "Camera": return "camera.fill"  
    case "键盘", "Keyboard": return "keyboard.fill"
    default: return "gearshape.fill"
    }
}
