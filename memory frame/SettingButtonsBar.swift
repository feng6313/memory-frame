//
//  SettingButtonsBar.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI
import Foundation

struct SettingButtonsBar: View {
    let borderWidth: CGFloat
    @Binding var selectedIndex: Int
    @Binding var selectedColorIndex: Int
    @Binding var selectedIconIndex: Int
    @Binding var showEnterView: Bool
    @State private var showDmuView = false
    let onSelectionChanged: ((Int, String) -> Void)?
    let onColorChanged: ((Int, String) -> Void)?
    let onIconChanged: ((Int, String) -> Void)?
    
    private let buttonTitles = ["边框", "文字", "时间", "地点", "图标"]
    private let colors = [
        "#FFFFFF", "#1C1E22", "#F4E6E7", "#F2EEE3", "#F56E00", "#CEC3B3", "#2DB471",
        "#E5ECDB", "#C3D3DB", "#C3D3DB", "#69733E", "#834643", "#A600FF", "#255B85"
    ]
    
    init(borderWidth: CGFloat, selectedIndex: Binding<Int>, selectedColorIndex: Binding<Int>, selectedIconIndex: Binding<Int>, showEnterView: Binding<Bool>, onSelectionChanged: ((Int, String) -> Void)? = nil, onColorChanged: ((Int, String) -> Void)? = nil, onIconChanged: ((Int, String) -> Void)? = nil) {
        self.borderWidth = borderWidth
        self._selectedIndex = selectedIndex
        self._selectedColorIndex = selectedColorIndex
        self._selectedIconIndex = selectedIconIndex
        self._showEnterView = showEnterView
        self.onSelectionChanged = onSelectionChanged
        self.onColorChanged = onColorChanged
        self.onIconChanged = onIconChanged
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // 按钮栏 - 当选中文字或更多时隐藏
            if selectedIconIndex != 1 && selectedIconIndex != 2 {
                HStack(spacing: 0) {
                    ForEach(0..<buttonTitles.count, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedIndex = index
                            }
                            onSelectionChanged?(index, buttonTitles[index])
                        }) {
                            Text(buttonTitles[index])
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: selectedIndex == index ? 28 : 32)
                                .background(
                                    RoundedRectangle(cornerRadius: selectedIndex == index ? 8 : 10)
                                        .fill(selectedIndex == index ? Color(hex: "6B6C70") : Color.clear)
                                )
                                .padding(.horizontal, (index == 0 || index == buttonTitles.count - 1) && selectedIndex == index ? 2 : 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(width: borderWidth - 12, height: 32) // 左右各6点边距
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "2C2C2E"))
                )
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let buttonWidth = (borderWidth - 24) / CGFloat(buttonTitles.count)
                            let newIndex = min(max(0, Int(value.location.x / buttonWidth)), buttonTitles.count - 1)
                            
                            if newIndex != selectedIndex {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedIndex = newIndex
                                }
                                onSelectionChanged?(newIndex, buttonTitles[newIndex])
                            }
                        }
                )
                .opacity(selectedIconIndex == 0 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: selectedIconIndex)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
            
            // 颜色选择器 - 当选中文字或更多时隐藏
            if selectedIconIndex != 1 && selectedIconIndex != 2 {
                VStack(spacing: 12) {
                    // 第一行
                    HStack(spacing: calculateColorSpacing()) {
                        ForEach(0..<7, id: \.self) { index in
                            colorCircle(index: index)
                        }
                    }
                    
                    // 第二行
                    HStack(spacing: calculateColorSpacing()) {
                        ForEach(7..<14, id: \.self) { index in
                            colorCircle(index: index)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(width: borderWidth)
                .opacity(selectedIconIndex == 0 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: selectedIconIndex)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
            
            // 当选中文字时显示添加内容按钮
            if selectedIconIndex == 1 {
                VStack {
                    Spacer(minLength: 30)
                    
                    Button(action: {
                        showEnterView = true
                    }) {
                        Text("+点击添加回忆内容")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "838383"))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .opacity(selectedIconIndex == 1 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: selectedIconIndex)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
            
            // 当选中更多时显示三个图标
            if selectedIconIndex == 2 {
                VStack {
                    Spacer(minLength: 30)
                    
                    HStack(spacing: calculateMoreIconSpacing()) {
                        moreIconButton(iconName: "date")
                        moreIconButton(iconName: "map_b")
                        moreIconButton(iconName: "user")
                    }
                    
                    Spacer()
                }
                .opacity(selectedIconIndex == 2 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: selectedIconIndex)
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
            
            // 图标按钮区域
            HStack(spacing: calculateIconSpacing()) {
                iconButton(index: 0, iconName: "color", title: "颜色")
                iconButton(index: 1, iconName: "word", title: "文字")
                iconButton(index: 2, iconName: "more", title: "更多")
            }
            .padding(.horizontal, 12)
            .frame(width: borderWidth)
        }
        .frame(height: 222)
        .sheet(isPresented: $showDmuView) {
            DmuView()
        }
    }
    
    private func calculateColorSpacing() -> CGFloat {
        let totalCircleWidth: CGFloat = 7 * 30
        let horizontalPadding: CGFloat = 12 * 2 // 左右各12点
        let availableSpace = borderWidth - totalCircleWidth - horizontalPadding
        return availableSpace / 6
    }
    
    private func colorCircle(index: Int) -> some View {
        Button(action: {
            // 添加震动反馈
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedColorIndex = index
            }
            onColorChanged?(index, colors[index])
        }) {
            Circle()
                .fill(Color(hex: colors[index]))
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: selectedColorIndex == index ? 3 : 0)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func calculateIconSpacing() -> CGFloat {
        let totalIconWidth: CGFloat = 3 * 105
        let horizontalPadding: CGFloat = 12 * 2 // 左右各12点
        let availableSpace = borderWidth - totalIconWidth - horizontalPadding
        return availableSpace / 2
    }
    
    private func calculateMoreIconSpacing() -> CGFloat {
        return 50 // 图标间距固定为50点
    }
    
    private func moreIconButton(iconName: String) -> some View {
        Button(action: {
            showDmuView = true
        }) {
            Image(iconName)
                .resizable()
                .frame(width: 50, height: 50)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconButton(index: Int, iconName: String, title: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIconIndex = index
            }
            onIconChanged?(index, title)
        }) {
            VStack(spacing: 8) {
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            .frame(width: 105, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "1C1E22"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedIconIndex == index ? Color.white : Color(hex: "3E3E3E"), lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 预览
struct SettingButtonsBar_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    @State static var selectedColorIndex = 0
    @State static var selectedIconIndex = 0
    @State static var showEnterView = false
    
    static var previews: some View {
        VStack(spacing: 20) {
            SettingButtonsBar(
                borderWidth: 371,
                selectedIndex: $selectedIndex,
                selectedColorIndex: $selectedColorIndex,
                selectedIconIndex: $selectedIconIndex,
                showEnterView: $showEnterView
            ) { index, title in
                print("Selected: \(title) at index \(index)")
            } onColorChanged: { index, color in
                print("Selected color: \(color) at index \(index)")
            } onIconChanged: { index, title in
                print("Selected icon: \(title) at index \(index)")
            }
            
            SettingButtonsBar(
                borderWidth: 400,
                selectedIndex: $selectedIndex,
                selectedColorIndex: $selectedColorIndex,
                selectedIconIndex: $selectedIconIndex,
                showEnterView: $showEnterView
            )
        }
        .padding()
        .background(Color.black)
    }
}
