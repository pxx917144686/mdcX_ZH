import Foundation
import SwiftUI

class PresetManager: ObservableObject {
    static let shared = PresetManager()
    
    @Published var presets: [TweakPreset] = []
    
    struct TweakPreset: Identifiable, Codable {
        var id = UUID()
        var name: String
        var description: String
        var tweakIds: [UUID]
        var color: String // 存储颜色的字符串表示
        var icon: String
        var dateCreated: Date
        var lastUsed: Date?
    }
    
    private let presetStorageKey = "com.speedy67.mdcX.savedPresets"
    
    private init() {
        loadPresets()
    }
    
    func loadPresets() {
        if let data = UserDefaults.standard.data(forKey: presetStorageKey) {
            do {
                presets = try JSONDecoder().decode([TweakPreset].self, from: data)
            } catch {
                print("加载预设失败: \(error)")
            }
        }
    }
    
    func savePresets() {
        do {
            let data = try JSONEncoder().encode(presets)
            UserDefaults.standard.set(data, forKey: presetStorageKey)
        } catch {
            print("保存预设失败: \(error)")
        }
    }
    
    func createPreset(name: String, description: String, tweakIds: [UUID], color: Color, icon: String) -> TweakPreset {
        // 将Color转换为可存储的字符串
        let colorString = colorToString(color)
        
        let newPreset = TweakPreset(
            name: name,
            description: description,
            tweakIds: tweakIds,
            color: colorString,
            icon: icon,
            dateCreated: Date(),
            lastUsed: nil
        )
        
        presets.append(newPreset)
        savePresets()
        return newPreset
    }
    
    func updatePreset(_ preset: TweakPreset) {
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            savePresets()
        }
    }
    
    func deletePreset(_ preset: TweakPreset) {
        presets.removeAll { $0.id == preset.id }
        savePresets()
    }
    
    func markPresetAsUsed(_ preset: TweakPreset) {
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            var updatedPreset = preset
            updatedPreset.lastUsed = Date()
            presets[index] = updatedPreset
            savePresets()
        }
    }
    
    // 辅助方法，将Color转换为可存储的字符串
    private func colorToString(_ color: Color) -> String {
        // 简化实现，使用预定义颜色名称
        if color == .red { return "red" }
        if color == .blue { return "blue" }
        if color == .green { return "green" }
        if color == .orange { return "orange" }
        if color == .purple { return "purple" }
        if color == .pink { return "pink" }
        if color == .yellow { return "yellow" }
        if color == .gray { return "gray" }
        return "blue" // 默认
    }
    
    // 将存储的字符串转换回Color
    func stringToColor(_ string: String) -> Color {
        switch string {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        case "gray": return .gray
        default: return .blue
        }
    }
}