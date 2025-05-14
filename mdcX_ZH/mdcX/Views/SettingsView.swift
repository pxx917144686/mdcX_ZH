import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared
    @State private var showResetAlert = false
    @State private var showClearSearchesAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("显示选项")) {
                Toggle("在调整项中显示状态", isOn: $settings.showStatusInTweakRow)
                
                Toggle("收藏项显示在前", isOn: $settings.showFavoritesFirst)
                
                Picker("默认排序方式", selection: $settings.defaultSortOrder) {
                    ForEach(AppSettings.SortOrder.allCases) { order in
                        Text(order.rawValue).tag(order)
                    }
                }
                
                Toggle("显示风险等级警告", isOn: $settings.riskLevelWarning)
            }
            
            Section(header: Text("备份设置")) {
                Toggle("调整前自动备份", isOn: $settings.autoBackupBeforeTweak)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            Section(header: Text("外观")) {
                Picker("应用主题", selection: $settings.theme) {
                    ForEach(AppSettings.AppTheme.allCases) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                
                ColorPicker("强调色", selection: $settings.accentColor)
            }
            
            Section(header: Text("日志设置")) {
                Stepper("最大日志条目数: \(settings.maxLogEntries)", value: $settings.maxLogEntries, in: 50...500, step: 50)
            }
            
            Section(header: Text("搜索历史")) {
                ForEach(settings.recentSearchTerms, id: \.self) { term in
                    Text(term)
                        .font(.caption)
                }
                
                Button(action: {
                    showClearSearchesAlert = true
                }) {
                    Text("清除搜索历史")
                        .foregroundColor(.red)
                }
                .disabled(settings.recentSearchTerms.isEmpty)
            }
            
            Section(header: Text("高级选项")) {
                Toggle("开发者调试模式", isOn: $settings.debugMode)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                
                if settings.debugMode {
                    Text("警告：启用调试模式可能会显示敏感的系统信息和详细的操作日志。")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Button(action: {
                    showResetAlert = true
                }) {
                    Text("重置所有设置")
                        .foregroundColor(.red)
                }
            }
            
            Section(header: Text("关于")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("mdcX")
                        .font(.headline)
                    
                    Text("版本 1.0")
                        .font(.caption)
                    
                    Text("此应用用于iOS系统UI定制，请谨慎使用。非官方调整可能影响设备安全性和稳定性。")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("设置")
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("重置设置"),
                message: Text("确定要将所有设置恢复为默认值吗？此操作无法撤销。"),
                primaryButton: .destructive(Text("重置")) {
                    resetAllSettings()
                },
                secondaryButton: .cancel(Text("取消"))
            )
        }
        .alert(isPresented: $showClearSearchesAlert) {
            Alert(
                title: Text("清除搜索历史"),
                message: Text("确定要清除所有搜索历史记录吗？"),
                primaryButton: .destructive(Text("清除")) {
                    settings.clearRecentSearches()
                },
                secondaryButton: .cancel(Text("取消"))
            )
        }
    }
    
    private func resetAllSettings() {
        settings.showStatusInTweakRow = true
        settings.autoBackupBeforeTweak = true
        settings.defaultSortOrder = .category
        settings.showFavoritesFirst = true
        settings.riskLevelWarning = true
        settings.maxLogEntries = 100
        settings.theme = .system
        settings.accentColor = .purple
        settings.debugMode = false
        settings.recentSearchTerms = []
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
