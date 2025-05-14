import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    // 应用程序设置
    @Published var showStatusInTweakRow: Bool = true {
        didSet { saveSettings() }
    }
    
    @Published var autoBackupBeforeTweak: Bool = true {
        didSet { saveSettings() }
    }
    
    @Published var defaultSortOrder: SortOrder = .category {
        didSet { saveSettings() }
    }
    
    @Published var showFavoritesFirst: Bool = true {
        didSet { saveSettings() }
    }
    
    @Published var riskLevelWarning: Bool = true {
        didSet { saveSettings() }
    }
    
    @Published var maxLogEntries: Int = 100 {
        didSet { saveSettings() }
    }
    
    @Published var theme: AppTheme = .system {
        didSet { 
            saveSettings()
            applyTheme()
        }
    }
    
    @Published var accentColor: Color = .purple {
        didSet { saveSettings() }
    }
    
    @Published var colorScheme: ColorScheme? = nil
    
    @Published var debugMode: Bool = false {
        didSet { saveSettings() }
    }
    
    @Published var recentSearchTerms: [String] = [] {
        didSet { saveSettings() }
    }
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case name = "名称"
        case category = "分类"
        case lastUsed = "最近使用"
        case riskLevel = "风险级别"
        
        var id: String { self.rawValue }
    }
    
    enum AppTheme: String, CaseIterable, Identifiable {
        case light = "浅色"
        case dark = "深色"
        case system = "跟随系统"
        
        var id: String { self.rawValue }
    }
    
    private let defaults = UserDefaults.standard
    private let settingsKey = "com.speedy67.mdcX.appSettings"
    
    private init() {
        loadSettings()
    }
    
    func addRecentSearch(_ term: String) {
        // 移除相同的搜索词（如果存在）
        recentSearchTerms.removeAll { $0 == term }
        
        // 添加到最前面
        recentSearchTerms.insert(term, at: 0)
        
        // 限制数量
        if recentSearchTerms.count > 10 {
            recentSearchTerms = Array(recentSearchTerms.prefix(10))
        }
    }
    
    func clearRecentSearches() {
        recentSearchTerms = []
    }
    
    private func loadSettings() {
        if let data = defaults.data(forKey: settingsKey) {
            if let decoded = try? JSONDecoder().decode(SettingsData.self, from: data) {
                self.showStatusInTweakRow = decoded.showStatusInTweakRow
                self.autoBackupBeforeTweak = decoded.autoBackupBeforeTweak
                self.defaultSortOrder = SortOrder(rawValue: decoded.defaultSortOrder) ?? .category
                self.showFavoritesFirst = decoded.showFavoritesFirst
                self.riskLevelWarning = decoded.riskLevelWarning
                self.maxLogEntries = decoded.maxLogEntries
                self.theme = AppTheme(rawValue: decoded.theme) ?? .system
                self.debugMode = decoded.debugMode
                self.recentSearchTerms = decoded.recentSearchTerms
                
                // 应用主题
                applyTheme()
            }
        }
    }
    
    private func saveSettings() {
        let data = SettingsData(
            showStatusInTweakRow: showStatusInTweakRow,
            autoBackupBeforeTweak: autoBackupBeforeTweak,
            defaultSortOrder: defaultSortOrder.rawValue,
            showFavoritesFirst: showFavoritesFirst,
            riskLevelWarning: riskLevelWarning,
            maxLogEntries: maxLogEntries,
            theme: theme.rawValue,
            debugMode: debugMode,
            recentSearchTerms: recentSearchTerms
        )
        
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: settingsKey)
        }
    }
    
    private func applyTheme() {
        switch theme {
        case .light:
            colorScheme = .light
        case .dark:
            colorScheme = .dark
        case .system:
            colorScheme = nil
        }
    }
    
    // 内部结构，用于编码/解码
    private struct SettingsData: Codable {
        var showStatusInTweakRow: Bool
        var autoBackupBeforeTweak: Bool
        var defaultSortOrder: String
        var showFavoritesFirst: Bool
        var riskLevelWarning: Bool
        var maxLogEntries: Int
        var theme: String
        var debugMode: Bool
        var recentSearchTerms: [String]
    }
}
