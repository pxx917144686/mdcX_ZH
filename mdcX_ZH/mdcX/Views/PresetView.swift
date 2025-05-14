import SwiftUI

struct PresetView: View {
    @ObservedObject var presetManager = PresetManager.shared
    @ObservedObject var logStore: LogStore
    
    @State private var tweakStore: [UUID: Tweak] = [:]
    @State private var showingCreateSheet = false
    @State private var selectedTweakIds: [UUID] = []
    @State private var presetName = ""
    @State private var presetDescription = ""
    @State private var presetColor = Color.blue
    @State private var presetIcon = "star.fill"
    @State private var alertItem: AlertItem?
    @State private var isApplyingPreset = false
    @State private var presetBeingEdited: PresetManager.TweakPreset?
    
    private let iconOptions = [
        "star.fill", "bolt.fill", "wand.and.stars", "sparkles", "gearshape.fill",
        "hammer.fill", "wrench.fill", "paintbrush.fill", "pencil", "slider.horizontal.3",
        "heart.fill", "leaf.fill", "crown.fill", "flame.fill", "bolt.horizontal.fill"
    ]
    
    private let colorOptions: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .gray
    ]
    
    var body: some View {
        List {
            if presetManager.presets.isEmpty {
                Section {
                    VStack(spacing: 20) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("还没有创建预设")
                            .font(.headline)
                        
                        Text("预设可以让您保存和快速应用多个调整")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingCreateSheet = true
                        }) {
                            Text("创建第一个预设")
                        }
                        .buttonStyle(CustomButtonStyle(color: .blue))
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            } else {
                ForEach(presetManager.presets.sorted(by: { $0.lastUsed ?? $0.dateCreated > $1.lastUsed ?? $1.dateCreated })) { preset in
                    PresetItemView(
                        preset: preset,
                        tweakStore: $tweakStore,
                        color: presetManager.stringToColor(preset.color),
                        onApply: { applyPreset(preset) },
                        onEdit: { editPreset(preset) },
                        onDelete: { confirmDeletePreset(preset) }
                    )
                }
            }
            
            Section {
                Button(action: {
                    showingCreateSheet = true
                }) {
                    Label("创建新预设", systemImage: "plus.circle.fill")
                }
                .disabled(isApplyingPreset)
            }
        }
        .navigationTitle("调整预设")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        sortPresetsByName()
                    }) {
                        Label("按名称排序", systemImage: "textformat.size")
                    }
                    
                    Button(action: {
                        sortPresetsByDate()
                    }) {
                        Label("按创建日期排序", systemImage: "calendar")
                    }
                    
                    Button(action: {
                        sortPresetsByLastUsed()
                    }) {
                        Label("按最近使用排序", systemImage: "clock")
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .disabled(presetManager.presets.isEmpty)
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            NavigationView {
                CreatePresetView(
                    tweakStore: $tweakStore,
                    selectedTweakIds: $selectedTweakIds,
                    presetName: $presetName,
                    presetDescription: $presetDescription,
                    presetColor: $presetColor,
                    presetIcon: $presetIcon,
                    iconOptions: iconOptions,
                    colorOptions: colorOptions,
                    presetBeingEdited: $presetBeingEdited,
                    onSave: savePreset
                )
                .navigationTitle(presetBeingEdited == nil ? "创建预设" : "编辑预设")
                .navigationBarItems(
                    leading: Button("取消") {
                        showingCreateSheet = false
                        resetForm()
                    },
                    trailing: Button(presetBeingEdited == nil ? "创建" : "保存") {
                        savePreset()
                    }
                    .disabled(presetName.isEmpty || selectedTweakIds.isEmpty)
                )
            }
        }
        .alert(item: $alertItem) { item in
            Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
        }
        .onAppear {
            loadAvailableTweaks()
        }
    }
    
    private func loadAvailableTweaks() {
        // 在实际应用中，这会从ContentView或主数据存储中加载所有可用的调整
        // 此处仅为演示，实际使用时需替换为真实数据源
        
        // 示例加载逻辑
        let allTweaks = ContentView().publicGetTweaks() // 修改为调用公共方法
        
        for tweak in allTweaks {
            tweakStore[tweak.id] = tweak
        }
    }
    
    private func savePreset() {
        if presetName.isEmpty {
            alertItem = AlertItem(
                title: Text("错误"),
                message: Text("请输入预设名称"),
                primaryButton: .default(Text("确定"))
            )
            return
        }
        
        if selectedTweakIds.isEmpty {
            alertItem = AlertItem(
                title: Text("错误"),
                message: Text("请选择至少一个调整"),
                primaryButton: .default(Text("确定"))
            )
            return
        }
        
        if let preset = presetBeingEdited {
            // 更新现有预设
            var updatedPreset = preset
            updatedPreset.name = presetName
            updatedPreset.description = presetDescription
            updatedPreset.tweakIds = selectedTweakIds
            updatedPreset.color = presetManager.publicColorToString(presetColor) // 修改为调用公共方法
            updatedPreset.icon = presetIcon
            
            presetManager.updatePreset(updatedPreset)
            logStore.append(message: "已更新预设: \(presetName)")
        } else {
            // 创建新预设
            let newPreset = presetManager.createPreset(
                name: presetName,
                description: presetDescription,
                tweakIds: selectedTweakIds,
                color: presetColor,
                icon: presetIcon
            )
            
            logStore.append(message: "已创建新预设: \(newPreset.name) (\(selectedTweakIds.count)个调整)")
        }
        
        showingCreateSheet = false
        resetForm()
    }
    
    private func resetForm() {
        presetName = ""
        presetDescription = ""
        selectedTweakIds = []
        presetColor = .blue
        presetIcon = "star.fill"
        presetBeingEdited = nil
    }
    
    private func applyPreset(_ preset: PresetManager.TweakPreset) {
        guard !isApplyingPreset else { return }
        
        isApplyingPreset = true
        logStore.append(message: "正在应用预设: \(preset.name)")
        
        // 实际应用中需要调用ExploitManager来应用每个调整
        // 这里只是模拟过程
        
        let tweaksToApply = preset.tweakIds.compactMap { tweakStore[$0] }
        
        if tweaksToApply.isEmpty {
            logStore.append(message: "预设中没有找到有效的调整")
            isApplyingPreset = false
            return
        }
        
        // 模拟应用调整的过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            logStore.append(message: "应用了预设 \(preset.name) 中的 \(tweaksToApply.count) 项调整")
            presetManager.markPresetAsUsed(preset)
            isApplyingPreset = false
        }
    }
    
    private func editPreset(_ preset: PresetManager.TweakPreset) {
        presetBeingEdited = preset
        presetName = preset.name
        presetDescription = preset.description
        selectedTweakIds = preset.tweakIds
        presetColor = presetManager.stringToColor(preset.color)
        presetIcon = preset.icon
        
        showingCreateSheet = true
    }
    
    private func confirmDeletePreset(_ preset: PresetManager.TweakPreset) {
        alertItem = AlertItem(
            title: Text("确认删除"),
            message: Text("您确定要删除预设\"\(preset.name)\"吗？"),
            primaryButton: .destructive(Text("删除")) {
                presetManager.deletePreset(preset)
                logStore.append(message: "已删除预设: \(preset.name)")
            },
            secondaryButton: .cancel()
        )
    }
    
    // 排序方法
    private func sortPresetsByName() {
        // 预设已由view直接排序
        logStore.append(message: "按名称排序预设")
    }
    
    private func sortPresetsByDate() {
        // 预设已由view直接排序
        logStore.append(message: "按创建日期排序预设")
    }
    
    private func sortPresetsByLastUsed() {
        // 预设已由view直接排序
        logStore.append(message: "按最近使用排序预设")
    }
}

struct PresetItemView: View {
    let preset: PresetManager.TweakPreset
    @Binding var tweakStore: [UUID: Tweak]
    let color: Color
    let onApply: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: preset.icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                VStack(alignment: .leading) {
                    Text(preset.name)
                        .font(.headline)
                    
                    if !preset.description.isEmpty {
                        Text(preset.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Text("\(preset.tweakIds.count)项调整")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(color.opacity(0.2))
                    .cornerRadius(10)
            }
            
            // 显示预设中包含的调整列表
            if !preset.tweakIds.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preset.tweakIds, id: \.self) { tweakId in
                            if let tweak = tweakStore[tweakId] {
                                Text(tweak.name)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            
            HStack {
                Button(action: onApply) {
                    Label("应用", systemImage: "play.fill")
                        .font(.callout)
                        .foregroundColor(color)
                }
                
                Spacer()
                
                Button(action: onEdit) {
                    Label("编辑", systemImage: "pencil")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
                
                Button(action: onDelete) {
                    Label("删除", systemImage: "trash")
                        .font(.callout)
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 8)
    }
}

struct CreatePresetView: View {
    @Binding var tweakStore: [UUID: Tweak]
    @Binding var selectedTweakIds: [UUID]
    @Binding var presetName: String
    @Binding var presetDescription: String
    @Binding var presetColor: Color
    @Binding var presetIcon: String
    let iconOptions: [String]
    let colorOptions: [Color]
    @Binding var presetBeingEdited: PresetManager.TweakPreset?
    
    let onSave: () -> Void
    
    @State private var searchText = ""
    
    var filteredTweaks: [Tweak] {
        let allTweaks = Array(tweakStore.values)
        if searchText.isEmpty {
            return allTweaks
        } else {
            return allTweaks.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) || 
                    ($0.description ?? "").localizedCaseInsensitiveContains(searchText) ||
                    $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("预设信息")) {
                TextField("预设名称", text: $presetName)
                TextField("描述（可选）", text: $presetDescription)
            }
            
            Section(header: Text("选择图标")) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                    ForEach(iconOptions, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(icon == presetIcon ? presetColor : .gray)
                            .frame(width: 44, height: 44)
                            .background(icon == presetIcon ? presetColor.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                presetIcon = icon
                            }
                    }
                }
                .padding(.vertical, 5)
            }
            
            Section(header: Text("选择颜色")) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                    ForEach(colorOptions, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .opacity(color == presetColor ? 1 : 0)
                            )
                            .shadow(color: color.opacity(0.5), radius: 3, x: 0, y: 2)
                            .padding(5)
                            .onTapGesture {
                                presetColor = color
                            }
                    }
                }
                .padding(.vertical, 5)
            }
            
            Section(header: Text("选择调整")) {
                SearchBar(text: $searchText, placeholder: "搜索调整...")
                
                Text("已选择 \(selectedTweakIds.count) 项调整")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 5)
                
                ForEach(filteredTweaks) { tweak in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(tweak.name)
                                .font(.subheadline)
                            
                            if let description = tweak.description, !description.isEmpty {
                                Text(description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Text(tweak.category)
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        if selectedTweakIds.contains(tweak.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedTweakIds.contains(tweak.id) {
                            selectedTweakIds.removeAll { $0 == tweak.id }
                        } else {
                            selectedTweakIds.append(tweak.id)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            
            Section {
                Button(action: onSave) {
                    Text(presetBeingEdited == nil ? "创建预设" : "保存更改")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .background(presetColor)
                        .cornerRadius(10)
                }
                .disabled(presetName.isEmpty || selectedTweakIds.isEmpty)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}
