//
//  CropImageView.swift
//  memory frame
//
//  Created on 2025-01-14.
//

import SwiftUI
import UIKit

// 全屏图片裁切视图
struct CropImageView: View {
    let image: UIImage
    let onCropComplete: (UIImage) -> Void
    let onCancel: () -> Void
    
    @State private var imageScale: CGFloat = 1.0
    @State private var baseScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero
    
    private let cropSize: CGFloat = 280
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // 黑色背景
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // 裁切区域 - 居中显示
                        Spacer()
                        
                        ZStack {
                            // 修正图片方向并显示
                            Image(uiImage: correctedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: cropSize * 1.5, height: cropSize * 1.5)
                                .scaleEffect(imageScale)
                                .offset(imageOffset)
                                .onAppear {
                                    setupInitialScale()
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let newOffset = CGSize(
                                                width: lastDragOffset.width + value.translation.width,
                                                height: lastDragOffset.height + value.translation.height
                                            )
                                            imageOffset = limitOffset(newOffset)
                                        }
                                        .onEnded { _ in
                                            imageOffset = limitOffset(imageOffset)
                                            lastDragOffset = imageOffset
                                        }
                                )
                                .gesture(
                                    MagnificationGesture(minimumScaleDelta: 0)
                                        .onChanged { value in
                                            let newScale = baseScale * value
                                            imageScale = max(minScale, min(5.0, newScale))
                                            imageOffset = limitOffset(imageOffset)
                                        }
                                        .onEnded { _ in
                                            baseScale = imageScale
                                            imageOffset = limitOffset(imageOffset)
                                            lastDragOffset = imageOffset
                                        }
                                )
                                .clipped()
                            
                            // 遮罩层
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: cropSize * 1.5, height: cropSize * 1.5)
                                .overlay(
                                    Circle()
                                        .frame(width: cropSize, height: cropSize)
                                        .blendMode(.destinationOut)
                                )
                                .compositingGroup()
                                .allowsHitTesting(false)
                            
                            // 裁切边框
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: cropSize, height: cropSize)
                                .allowsHitTesting(false)
                        }
                        .frame(width: cropSize * 1.5, height: cropSize * 1.5)
                        .clipped()
                        
                        Spacer()
                        
                        // 底部提示
                        Text("拖动和缩放图片以调整裁切区域")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                    }
                }
            }
            .navigationTitle("设置头像")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        onCancel()
                    }) {
                        Text("取消")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        cropImage()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // 修正图片方向
    private var correctedImage: UIImage {
        // 如果图片方向已经是正确的，直接返回
        if image.imageOrientation == .up {
            return image
        }
        
        // 创建正确方向的图片
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let corrected = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        
        return corrected
    }
    
    // 设置初始缩放
    private func setupInitialScale() {
        let imageSize = correctedImage.size
        let imageAspectRatio = imageSize.width / imageSize.height
        let containerSize = cropSize * 1.5
        
        // 计算图片在容器中的显示尺寸
        let displayWidth: CGFloat
        let displayHeight: CGFloat
        
        if imageAspectRatio > 1 {
            // 横图：以容器高度为准
            displayHeight = containerSize
            displayWidth = displayHeight * imageAspectRatio
        } else {
            // 竖图：以容器宽度为准
            displayWidth = containerSize
            displayHeight = displayWidth / imageAspectRatio
        }
        
        // 计算最小缩放比例，确保图片能完全覆盖圆形区域
        let minScaleForCrop = cropSize / min(displayWidth, displayHeight)
        
        // 设置合理的初始缩放，允许用户缩小
        let initialScale = max(minScaleForCrop, 0.8)
        imageScale = initialScale
        baseScale = initialScale
    }
    
    // 计算最小缩放比例
    private var minScale: CGFloat {
        let imageSize = correctedImage.size
        let imageAspectRatio = imageSize.width / imageSize.height
        let containerSize = cropSize * 1.5
        
        // 计算图片在容器中的显示尺寸
        let displayWidth: CGFloat
        let displayHeight: CGFloat
        
        if imageAspectRatio > 1 {
            // 横图：以容器高度为准
            displayHeight = containerSize
            displayWidth = displayHeight * imageAspectRatio
        } else {
            // 竖图：以容器宽度为准
            displayWidth = containerSize
            displayHeight = displayWidth / imageAspectRatio
        }
        
        // 计算最小缩放比例，确保图片能覆盖圆形区域
        let minScaleForCrop = cropSize / min(displayWidth, displayHeight)
        
        // 允许用户缩小到合理范围
        return max(minScaleForCrop, 0.3)
    }
    
    // 限制偏移范围
    private func limitOffset(_ offset: CGSize) -> CGSize {
        let containerSize = cropSize * 1.5
        let imageSize = correctedImage.size
        let imageAspectRatio = imageSize.width / imageSize.height
        
        // 计算图片在容器中的显示尺寸
        let displayWidth: CGFloat
        let displayHeight: CGFloat
        
        if imageAspectRatio > 1 {
            displayHeight = containerSize
            displayWidth = displayHeight * imageAspectRatio
        } else {
            displayWidth = containerSize
            displayHeight = displayWidth / imageAspectRatio
        }
        
        // 计算缩放后的图片尺寸
        let scaledWidth = displayWidth * imageScale
        let scaledHeight = displayHeight * imageScale
        
        // 计算允许的最大偏移，使用裁切区域大小而不是容器大小来计算限制
        // 这样用户可以将图片移动到更边缘的位置
        let maxOffsetX = max(0, (scaledWidth - cropSize) / 2)
        let maxOffsetY = max(0, (scaledHeight - cropSize) / 2)
        
        return CGSize(
            width: max(-maxOffsetX, min(maxOffsetX, offset.width)),
            height: max(-maxOffsetY, min(maxOffsetY, offset.height))
        )
    }
    
    // 裁切图片
    private func cropImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: cropSize, height: cropSize))
        let croppedImage = renderer.image { context in
            let containerSize = cropSize * 1.5
            let imageSize = correctedImage.size
            
            // 计算图片在容器中的显示尺寸
            let imageAspectRatio = imageSize.width / imageSize.height
            let displayWidth: CGFloat
            let displayHeight: CGFloat
            
            if imageAspectRatio > 1 {
                // 横图：以容器高度为准
                displayHeight = containerSize
                displayWidth = displayHeight * imageAspectRatio
            } else {
                // 竖图：以容器宽度为准
                displayWidth = containerSize
                displayHeight = displayWidth / imageAspectRatio
            }
            
            // 计算缩放后的图片尺寸
            let scaledWidth = displayWidth * imageScale
            let scaledHeight = displayHeight * imageScale
            
            // 计算图片在容器中的位置（包含用户偏移）
            let imageX = (containerSize - scaledWidth) / 2 + imageOffset.width
            let imageY = (containerSize - scaledHeight) / 2 + imageOffset.height
            
            // 计算裁切区域相对于图片的位置
            let cropCenterX = containerSize / 2
            let cropCenterY = containerSize / 2
            let cropX = (cropCenterX - cropSize / 2 - imageX) / imageScale
            let cropY = (cropCenterY - cropSize / 2 - imageY) / imageScale
            
            // 转换为原始图片坐标系
            let scaleToOriginal = imageSize.width / displayWidth
            let cropRect = CGRect(
                x: cropX * scaleToOriginal,
                y: cropY * scaleToOriginal,
                width: (cropSize / imageScale) * scaleToOriginal,
                height: (cropSize / imageScale) * scaleToOriginal
            )
            
            // 确保裁切区域在图片范围内
            let clampedRect = CGRect(
                x: max(0, min(cropRect.origin.x, imageSize.width - cropRect.width)),
                y: max(0, min(cropRect.origin.y, imageSize.height - cropRect.height)),
                width: min(cropRect.width, imageSize.width),
                height: min(cropRect.height, imageSize.height)
            )
            
            // 裁切图片
            if let cgImage = correctedImage.cgImage?.cropping(to: clampedRect) {
                let croppedUIImage = UIImage(cgImage: cgImage)
                // 将裁切后的图片绘制到输出尺寸
                croppedUIImage.draw(in: CGRect(origin: .zero, size: CGSize(width: cropSize, height: cropSize)))
            }
        }
        
        onCropComplete(croppedImage)
    }
}