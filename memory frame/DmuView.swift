//
//  DmuView.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI

// 全局设置管理类
class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var selectedDate = Date()
    @Published var showDate = true
    @Published var countryProvince = ""
    @Published var provinceCity = ""
    @Published var showLocation = true
    
    private init() {}
    
    // 获取格式化的日期字符串
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    // 获取格式化的地点字符串
    func getFormattedLocation() -> String {
        if countryProvince.isEmpty && provinceCity.isEmpty {
            return "未知地点"
        } else if countryProvince.isEmpty {
            return provinceCity
        } else if provinceCity.isEmpty {
            return countryProvince
        } else {
            return "\(countryProvince)·\(provinceCity)"
        }
    }
}

struct DmuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var settings = SettingsManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0C0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // 日期设置部分
                        VStack(alignment: .leading, spacing: 16) {
                            Text("日期设置")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            // 日历选择器和不显示日期开关
                            VStack(spacing: 0) {
                                DatePicker(
                                    "",
                                    selection: $settings.selectedDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(.bottom, 16)
                                
                                // 分割线
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.leading, 16)
                                
                                // 不显示日期开关
                                HStack {
                                    Text("不显示日期")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { !settings.showDate },
                                        set: { settings.showDate = !$0 }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#007AFF")))
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2C2C2E"))
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                        

                        
                        // 地理位置设置部分
                        VStack(alignment: .leading, spacing: 16) {
                            Text("地理位置设置")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                            
                            // 地理位置输入框和开关容器
                            VStack(spacing: 0) {
                                // 第一个输入框
                                TextField("输入国家/省（8字以内）", text: Binding(
                                    get: { settings.countryProvince },
                                    set: { newValue in
                                        if newValue.count <= 8 {
                                            settings.countryProvince = newValue
                                        }
                                    }
                                ))
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                
                                // 分割线
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.leading, 16)
                                
                                // 第二个输入框
                                TextField("输入省/市（8字以内）", text: Binding(
                                    get: { settings.provinceCity },
                                    set: { newValue in
                                        if newValue.count <= 8 {
                                            settings.provinceCity = newValue
                                        }
                                    }
                                ))
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                
                                // 分割线
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.leading, 16)
                                
                                // 不显示位置开关
                                HStack {
                                    Text("不显示位置")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { !settings.showLocation },
                                        set: { settings.showLocation = !$0 }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#007AFF")))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2C2C2E"))
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            // 示例文字
                            HStack {
                                Text("示例：中国·北京、河南·洛阳、我的·记忆")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.leading, 36)
                            .padding(.bottom, 30)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("更多设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarBackground(Color(hex: "#0C0F14"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("取消")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("保存")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DmuView()
}
