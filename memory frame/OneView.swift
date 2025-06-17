//
//  OneView.swift
//  memory frame
//
//  Created by feng on 2025/6/13.
//

import SwiftUI
import UIKit
import Photos

struct OneView: View {
    let selectedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero

    @State private var selectedIndex: Int = 0
    @State private var selectedIconIndex: Int = 0
    @State private var showEnterView = false
    @State private var memoryText = "我的独家记忆"
    
    // 每个元素独立的颜色状态
    @State private var frameColorIndex: Int = 0      // 边框默认白色
    @State private var textColorIndex: Int = 1       // 文字默认#1C1E22
    @State private var timeColorIndex: Int = 4       // 时间默认#F56E00
    @State private var locationColorIndex: Int = 1   // 地点默认#1C1E22
    @State private var iconColorIndex: Int = 1       // 图标默认#1C1E22
    
    // 保存相关状态
    @State private var showingSaveAlert = false
    @State private var saveMessage = ""
    
    // 根据当前选中的按钮类型获取对应的颜色索引
    private var currentColorIndex: Int {
        switch selectedIndex {
        case 0: return frameColorIndex
        case 1: return textColorIndex
        case 2: return timeColorIndex
        case 3: return locationColorIndex
        case 4: return iconColorIndex
        default: return 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(hex: "#0C0F14")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // 照片边框
                        PhotoFrameView(
                            image: selectedImage,
                            screenWidth: geometry.size.width,
                            imageScale: $imageScale,
                            imageOffset: $imageOffset,
                            showEnterView: $showEnterView,
                            memoryText: $memoryText,
                            frameColorIndex: frameColorIndex,
                            textColorIndex: textColorIndex,
                            timeColorIndex: timeColorIndex,
                            locationColorIndex: locationColorIndex,
                            iconColorIndex: iconColorIndex
                        )
                        
                        // 设置按钮栏 - 距离边框4点
                        SettingButtonsBar(
                                borderWidth: geometry.size.width - 24,
                                selectedIndex: $selectedIndex,
                                selectedColorIndex: .constant(currentColorIndex),
                                selectedIconIndex: $selectedIconIndex,
                                showEnterView: $showEnterView,
                                onSelectionChanged: { index, title in
                                    print("选择了: \(title)")
                                },
                                onColorChanged: { index, color in
                                    // 根据当前选中的按钮类型更新对应的颜色索引
                                    switch selectedIndex {
                                    case 0: frameColorIndex = index
                                    case 1: textColorIndex = index
                                    case 2: timeColorIndex = index
                                    case 3: locationColorIndex = index
                                    case 4: iconColorIndex = index
                                    default: break
                                    }
                                    print("选择了颜色: \(color)")
                                },
                                onIconChanged: { index, icon in
                                    print("选择了图标: \(icon)")
                                }
                            )
                            .padding(.top, 20)
                        
                        Spacer()
                    }
                }
            .navigationTitle("编辑")
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveImageToPhotoLibrary()
                    }) {
                        Text("保存")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 32)
                            .background(Color(hex: "#007AFF"))
                            .cornerRadius(18)
                    }
                }
            }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

        .sheet(isPresented: $showEnterView) {
            EnterView(memoryText: $memoryText)
        }
        .alert("保存结果", isPresented: $showingSaveAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(saveMessage)
        }
    }
}

struct PhotoFrameView: View {
    let image: UIImage
    let screenWidth: CGFloat
    @Binding var imageScale: CGFloat
    @Binding var imageOffset: CGSize

    @Binding var showEnterView: Bool
    @Binding var memoryText: String
    let frameColorIndex: Int
    let textColorIndex: Int
    let timeColorIndex: Int
    let locationColorIndex: Int
    let iconColorIndex: Int
    @State private var lastDragOffset: CGSize = .zero
    @State private var initialLoadSize: CGSize = .zero
    @State private var baseScale: CGFloat = 1.0
    @StateObject private var settings = SettingsManager.shared
    
    // 颜色数组，与SettingButtonsBar保持一致
    private let colors = [
        "#FFFFFF", "#1C1E22", "#F4E6E7", "#F2EEE3", "#F56E00", "#CEC3B3", "#2DB471",
        "#E5ECDB", "#C3D3DB", "#A98069", "#69733E", "#834643", "#A600FF", "#255B85"
    ]
    
    // 边框颜色
    private var frameColor: Color {
        return Color(hex: colors[frameColorIndex])
    }
    
    // 文字颜色
    private var textColor: Color {
        return Color(hex: colors[textColorIndex])
    }
    
    // 时间颜色
    private var timeColor: Color {
        return Color(hex: colors[timeColorIndex])
    }
    
    // 地点颜色
    private var locationColor: Color {
        return Color(hex: colors[locationColorIndex])
    }
    
    // 图标颜色
    private var iconColor: Color {
        return Color(hex: colors[iconColorIndex])
    }
    
    private var frameWidth: CGFloat {
        screenWidth - 24 // 左右各留12pt边距
    }
    
    private var frameHeight: CGFloat {
        frameWidth / 0.8 // 保持0.8:1比例
    }
    
    private var imageDisplaySize: CGFloat {
        frameWidth * 0.92 // 边框宽度减去上下左右各0.04×边框宽度的边距
    }
    
    // 计算初始缩放比例，确保图片完全显示在显示区域内
    private var initialScale: CGFloat {
        let imageSize = image.size
        let scaleX = imageDisplaySize / imageSize.width
        let scaleY = imageDisplaySize / imageSize.height
        return min(scaleX, scaleY)
    }
    
    private var imageMargin: CGFloat {
        frameWidth * 0.04
    }
    
    // 限制图片偏移量，确保不超出显示区域
    private func limitOffset(_ offset: CGSize, scale: CGFloat, displaySize: CGFloat) -> CGSize {
        // 获取图片的原始尺寸
        let imageSize = image.size
        
        // 计算图片在显示区域内的实际显示尺寸
        let aspectRatio = imageSize.width / imageSize.height
        let scaledWidth = displaySize * scale
        let scaledHeight = displaySize * scale
        
        // 计算实际的图片显示尺寸（考虑aspectRatio: .fill）
        let actualImageWidth: CGFloat
        let actualImageHeight: CGFloat
        
        if aspectRatio > 1 {
            // 宽图片：高度填满显示区域，宽度按比例缩放
            actualImageHeight = scaledHeight
            actualImageWidth = actualImageHeight * aspectRatio
        } else {
            // 高图片或正方形：宽度填满显示区域，高度按比例缩放
            actualImageWidth = scaledWidth
            actualImageHeight = actualImageWidth / aspectRatio
        }
        
        // 计算最大允许的偏移量
        let maxOffsetX = max(0, (actualImageWidth - displaySize) / 2)
        let maxOffsetY = max(0, (actualImageHeight - displaySize) / 2)
        
        // 限制偏移量在允许范围内
        let limitedX = max(-maxOffsetX, min(maxOffsetX, offset.width))
        let limitedY = max(-maxOffsetY, min(maxOffsetY, offset.height))
        
        return CGSize(width: limitedX, height: limitedY)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 边框
            ZStack {
                Rectangle()
                    .fill(frameColor)
                    .frame(width: frameWidth, height: frameHeight)
                
                VStack {
                    HStack {
                        // 图片显示区域容器
                        ZStack {
                            // 显示区域背景
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: imageDisplaySize, height: imageDisplaySize)
                            
                            // 图片容器 - 限制图片在此区域内
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .scaleEffect(imageScale)
                                    .offset(imageOffset)
                                    .gesture(
                                        SimultaneousGesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    imageOffset = CGSize(
                                                        width: lastDragOffset.width + value.translation.width,
                                                        height: lastDragOffset.height + value.translation.height
                                                    )
                                                }
                                                .onEnded { value in
                                                    let newOffset = CGSize(
                                                        width: lastDragOffset.width + value.translation.width,
                                                        height: lastDragOffset.height + value.translation.height
                                                    )
                                                    withAnimation(.easeOut(duration: 0.3)) {
                                                        imageOffset = limitOffset(newOffset, scale: imageScale, displaySize: imageDisplaySize)
                                                        lastDragOffset = imageOffset
                                                    }
                                                },
                                            MagnificationGesture()
                                                .onChanged { value in
                                    // 计算新的缩放值
                                    let newScale = baseScale * value
                                    
                                    // 计算当前缩放下的图片实际尺寸
                                    let imageSize = image.size
                                    let aspectRatio = imageSize.width / imageSize.height
                                    let scaledWidth = imageDisplaySize * newScale
                                    let scaledHeight = imageDisplaySize * newScale
                                    
                                    let currentImageWidth: CGFloat
                                    let currentImageHeight: CGFloat
                                    
                                    if aspectRatio > 1 {
                                        currentImageHeight = scaledHeight
                                        currentImageWidth = currentImageHeight * aspectRatio
                                    } else {
                                        currentImageWidth = scaledWidth
                                        currentImageHeight = currentImageWidth / aspectRatio
                                    }
                                    
                                    // 确保当前尺寸不小于初次加载时的尺寸
                                    if currentImageWidth >= initialLoadSize.width && currentImageHeight >= initialLoadSize.height {
                                        imageScale = min(3.0, newScale)
                                    }
                                    
                                    imageOffset = limitOffset(imageOffset, scale: imageScale, displaySize: imageDisplaySize)
                                }
                                                .onEnded { value in
                                                    // 更新基准缩放值
                                                    baseScale = imageScale
                                                }
                                        )
                                    )
                            }
                            .frame(width: imageDisplaySize, height: imageDisplaySize)
                            .clipShape(Rectangle())
                            .onAppear {
                                // 记录图片初次加载时的实际显示尺寸
                                let imageSize = image.size
                                let aspectRatio = imageSize.width / imageSize.height
                                
                                if aspectRatio > 1 {
                                    // 宽图片：高度填满显示区域，宽度按比例缩放
                                    initialLoadSize = CGSize(
                                        width: imageDisplaySize * aspectRatio,
                                        height: imageDisplaySize
                                    )
                                } else {
                                    // 高图片或正方形：宽度填满显示区域，高度按比例缩放
                                    initialLoadSize = CGSize(
                                        width: imageDisplaySize,
                                        height: imageDisplaySize / aspectRatio
                                    )
                                }
                            }
                            
                            // 时间显示 - 图片右下角
                            if settings.showDate {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(settings.getFormattedDate())
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(timeColor)
                                            .padding(.trailing, 12)
                                            .padding(.bottom, 12)
                                    }
                                }
                            }
                        }
                        .frame(width: imageDisplaySize, height: imageDisplaySize)
                        
                        Spacer()
                    }
                    .padding(.leading, imageMargin)
                    .padding(.top, imageMargin)
                    
                    // 图片下方的空白区域，上下居中显示文字和地点
                    VStack {
                        Spacer()
                        
                        // 文字和地点显示区域，与图片左对齐
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                // 文字显示
                                Text(formatText(memoryText))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(textColor)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                
                                // 地点显示
                                if settings.showLocation {
                                    HStack(spacing: 4) {
                                        Image("map_s")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(iconColor)
                                        Text(settings.getFormattedLocation())
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(locationColor)
                                    }
                                }
                            }
                            .padding(.leading, imageMargin)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
            .frame(width: frameWidth, height: frameHeight)
        }
    }
    

    
    // 格式化文字，确保第一行最多15字，第二行最多10字
    private func formatText(_ text: String) -> String {
        let maxFirstLine = 15
        let maxSecondLine = 10
        let maxTotal = 25
        
        let trimmedText = String(text.prefix(maxTotal))
        
        if trimmedText.count <= maxFirstLine {
            return trimmedText
        } else {
            let firstLine = String(trimmedText.prefix(maxFirstLine))
            let remaining = String(trimmedText.dropFirst(maxFirstLine))
            
            if remaining.count <= maxSecondLine {
                return firstLine + "\n" + remaining
            } else {
                let secondLine = String(remaining.prefix(maxSecondLine - 3)) + "···"
                return firstLine + "\n" + secondLine
            }
        }
    }
    
}

// MARK: - OneView Extension
extension OneView {
    // 保存图片到相册
    private func saveImageToPhotoLibrary() {
        print("开始保存图片到相册流程")
        
        // 获取屏幕宽度
        let currentScreenWidth = UIScreen.main.bounds.width
        
        // 使用ImageExporter保存图片
        ImageExporter.savePhotoFrame(
            image: selectedImage,
            screenWidth: currentScreenWidth,
            imageScale: imageScale,
            imageOffset: imageOffset,
            memoryText: memoryText,
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        ) { success, message in
            DispatchQueue.main.async {
                self.saveMessage = message
                self.showingSaveAlert = true
                
                if success {
                    print("保存成功: \(message)")
                } else {
                    print("保存失败: \(message)")
                }
            }
        }
    }
}



#Preview {
    OneView(selectedImage: UIImage(systemName: "photo") ?? UIImage())
}
