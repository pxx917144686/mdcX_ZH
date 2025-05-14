//
//  TweakRowView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct TweakRowView: View {
    @Binding var tweak: Tweak
    @Binding var isGloballyProcessing: Bool
    @ObservedObject private var settings = AppSettings.shared
    
    @State private var showDetails = false

    let action: () -> Void
    
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
    
    var warningBadge: some View {
        Group {
            if tweak.riskLevel == .high {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.caption)
            } else if tweak.riskLevel == .medium {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconForCategory(tweak.category))
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 30, alignment: .center)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(tweak.name)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        warningBadge
                        
                        if tweak.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }

                    if let description = tweak.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }

                    if !tweak.status.isEmpty && settings.showStatusInTweakRow {
                        HStack(spacing: 4) {
                            Text("状态:")
                            Text(tweak.status)
                                .fontWeight(.medium)
                                .foregroundColor(tweak.status.contains("成功") || tweak.status.contains("已完成") ? .green : (tweak.status.contains("失败") ? .red : .orange))
                        }
                        .font(.caption)
                    }
                    
                    // 添加标签显示
                    if !tweak.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(tweak.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 9))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(height: 20)
                    }
                }

                Spacer()

                // 操作按钮区域
                HStack(spacing: 8) {
                    // 收藏按钮
                    Button(action: {
                        tweak.isFavorite.toggle()
                    }) {
                        Image(systemName: tweak.isFavorite ? "star.fill" : "star")
                            .foregroundColor(tweak.isFavorite ? .yellow : .gray)
                    }
                    .disabled(tweak.isProcessing || isGloballyProcessing)
                    .buttonStyle(.borderless)
                    
                    // 详情按钮
                    Button(action: {
                        showDetails.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.borderless)
                    
                    // 主操作按钮
                    Button(action: action) {
                        if tweak.isProcessing {
                            ProgressView()
                                .scaleEffect(0.7)
                                .frame(width: 44, height: 30) // 与按钮保持一致的大小
                        } else {
                            Image(systemName: "hammer.circle.fill") // "wand.and.stars" 或 "gearshape.fill"
                                .imageScale(.large)
                        }
                    }
                    .frame(width: 44, height: 30) // 给按钮一个确定的可点击区域
                    .disabled(tweak.isProcessing || isGloballyProcessing)
                    .buttonStyle(.borderless) // 在列表中的图标按钮使用无边框样式
                    .contentShape(Rectangle()) // 确保整个区域可点击
                }
            }
            .padding(.vertical, 8)
            
            // 详情展开区域
            if showDetails {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("调整详情")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    DetailRow(title: "风险级别", value: tweak.riskLevel.localizedDescription)
                    
                    if let description = tweak.longDescription {
                        Text("详细说明:")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let paths = tweak.getFilePaths(), !paths.isEmpty {
                        Text("影响文件:")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        ForEach(paths.prefix(3), id: \.self) { path in
                            Text(path)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        if paths.count > 3 {
                            Text("...及其他\(paths.count - 3)个文件")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Text("兼容性: \(tweak.compatibility.rawValue)")
                            .font(.caption)
                            .foregroundColor(tweak.compatibility == .good ? .green : (tweak.compatibility == .unknown ? .orange : .red))
                        
                        Spacer()
                        
                        Button("隐藏详情") {
                            showDetails = false
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
                .background(Color(UIColor.systemBackground).opacity(0.6))
                .transition(.opacity)
            }
        }
        .background(Color(UIColor.secondarySystemBackground).opacity(0.3))
        .cornerRadius(showDetails ? 10 : 0)
        .animation(.easeInOut(duration: 0.2), value: showDetails)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title + ":")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}
