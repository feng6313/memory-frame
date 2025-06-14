//
//  OneView.swift
//  memory frame
//
//  Created by feng on 2025/6/13.
//

import SwiftUI

struct OneView: View {
    let selectedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var showSettingView = false
    @State private var selectedIndex: Int = 0
    @State private var selectedColorIndex: Int = 0
    @State private var selectedIconIndex: Int = 0
    @State private var showEnterView = false
    
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
                            showSettingView: $showSettingView
                        )
                        
                        // 设置按钮栏 - 距离边框4点
                        SettingButtonsBar(
                                borderWidth: geometry.size.width - 24,
                                selectedIndex: $selectedIndex,
                                selectedColorIndex: $selectedColorIndex,
                                selectedIconIndex: $selectedIconIndex,
                                showEnterView: $showEnterView,
                                onSelectionChanged: { index, title in
                                    print("选择了: \(title)")
                                },
                                onColorChanged: { index, color in
                                    print("选择了颜色: \(color)")
                                },
                                onIconChanged: { index, icon in
                                    print("选择了图标: \(icon)")
                                }
                            )
                            .padding(.top, 12)
                        
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
                        // 保存逻辑
                        dismiss()
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
        .sheet(isPresented: $showSettingView) {
            SettingView()
        }
        .sheet(isPresented: $showEnterView) {
            EnterView()
        }
    }
}

struct PhotoFrameView: View {
    let image: UIImage
    let screenWidth: CGFloat
    @Binding var imageScale: CGFloat
    @Binding var imageOffset: CGSize
    @Binding var showSettingView: Bool
    @State private var lastDragOffset: CGSize = .zero
    @State private var initialLoadSize: CGSize = .zero
    
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
            // 白色边框
            ZStack {
                Rectangle()
                    .fill(Color.white)
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
                                    // 计算当前缩放下的图片实际尺寸
                                    let imageSize = image.size
                                    let aspectRatio = imageSize.width / imageSize.height
                                    let scaledWidth = imageDisplaySize * value
                                    let scaledHeight = imageDisplaySize * value
                                    
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
                                        imageScale = min(3.0, value)
                                    }
                                    
                                    imageOffset = limitOffset(imageOffset, scale: imageScale, displaySize: imageDisplaySize)
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
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(getCurrentDate())
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(Color(hex: "F56E00"))
                                        .padding(.trailing, 12)
                                        .padding(.bottom, 12)
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
                                Button(action: {
                                    showSettingView = true
                                }) {
                                    Text(formatText("我的独家记忆"))
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "1C1E22"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // 地点显示
                                HStack(spacing: 4) {
                                    Image("map_s")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("中国·北京")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(Color(hex: "1C1E22"))
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
    
    // 获取当前日期的格式化字符串
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
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

#Preview {
    OneView(selectedImage: UIImage(systemName: "photo") ?? UIImage())
}
