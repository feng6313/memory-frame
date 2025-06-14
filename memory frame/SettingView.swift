//
//  SettingView.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex = 0
    @State private var selectedColorIndex = 0
    @State private var selectedIconIndex = 0
    @State private var showEnterView = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(hex: "#0C0F14")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        // 示例：显示SettingButtonsBar组件
                        VStack(spacing: 20) {
                            Text("设置按钮栏演示")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                            
                            SettingButtonsBar(
                                borderWidth: 371,
                                selectedIndex: $selectedIndex,
                                selectedColorIndex: $selectedColorIndex,
                                selectedIconIndex: $selectedIconIndex,
                                showEnterView: $showEnterView
                            ) { index, title in
                                print("选中了：\(title) at index \(index)")
                            } onColorChanged: { index, color in
                                print("选中颜色：\(color) at index \(index)")
                            } onIconChanged: { index, title in
                                print("选中图标：\(title) at index \(index)")
                            }
                            
                            VStack(spacing: 8) {
                                Text("当前选中：\(getButtonTitle(selectedIndex))")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("当前颜色：\(getColorTitle(selectedColorIndex))")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("当前图标：\(getIconTitle(selectedIconIndex))")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .navigationTitle("设置")
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
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 17, weight: .medium))
                                Text("返回")
                                    .font(.system(size: 17))
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showEnterView) {
            EnterView()
        }
    }
    
    private func getButtonTitle(_ index: Int) -> String {
        let titles = ["边框", "文字", "时间", "地点", "图标"]
        return titles[safe: index] ?? "未知"
    }
    
    private func getColorTitle(_ index: Int) -> String {
        let colors = [
            "#FFFFFF", "#1C1E22", "#F4E6E7", "#F2EEE3", "#F56E00", "#CEC3B3", "#2DB471",
            "#E5ECDB", "#C3D3DB", "#C3D3DB", "#69733E", "#834643", "#A600FF", "#255B85"
        ]
        return colors[safe: index] ?? "未知"
    }
    
    private func getIconTitle(_ index: Int) -> String {
        let icons = ["颜色", "文字", "更多"]
        return icons[safe: index] ?? "未知"
    }
}

// 安全数组访问扩展
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    SettingView()
}