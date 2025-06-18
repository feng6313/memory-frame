//
//  DmuView.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI
import PhotosUI
import UIKit



// 全局设置管理类
class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var selectedDate = Date()
    @Published var showDate = true
    @Published var countryProvince = ""
    @Published var provinceCity = ""
    @Published var showLocation = true
    @Published var userName = "独家记忆"
    @Published var userAvatar: UIImage? = nil
    
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
    let showAvatarSettings: Bool
    
    init(showAvatarSettings: Bool = false) {
        self.showAvatarSettings = showAvatarSettings
    }
    
    @State private var showingImagePicker = false
    @State private var showingCropView = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景纯色
                Color(hex: "#0C0F14")
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // 日期设置部分
                        VStack(alignment: .leading, spacing: 0) {
                            // 标题
                            HStack {
                                Text("日期设置")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            // 日期选择卡片
                            VStack(spacing: 0) {
                                // 日历部分
                                VStack(spacing: 16) {
                                    DatePicker(
                                        "",
                                        selection: $settings.selectedDate,
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .colorScheme(.dark)
                                    .accentColor(Color(hex: "#007AFF"))

                                }
                                .padding(20)
                                
                                // 分割线
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                
                                // 不显示日期开关
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("不显示日期")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.white)
                                        Text("隐藏照片上的日期信息")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { !settings.showDate },
                                        set: { settings.showDate = !$0 }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#007AFF")))
                                    .scaleEffect(0.9)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2C2C2E"))
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        // 地理位置设置部分
                        VStack(alignment: .leading, spacing: 0) {
                            // 标题
                            HStack {
                                Text("地理位置设置")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            // 位置输入卡片
                            VStack(spacing: 0) {
                                // 第一个输入框
                                VStack(spacing: 0) {
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("国家/省")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("如：中国", text: Binding(
                                get: { settings.countryProvince },
                                set: { newValue in
                                    if newValue.count <= 8 {
                                        settings.countryProvince = newValue
                                    }
                                }
                            ))
                            .foregroundStyle(.white, Color(hex: "#5C5C5C"))
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .font(.system(size: 17))
                                            .foregroundColor(.white)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                                
                                // 分割线
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                    .padding(.leading, 20)
                                
                                // 第二个输入框
                                VStack(spacing: 0) {
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("省/市")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("如：北京", text: Binding(
                                get: { settings.provinceCity },
                                set: { newValue in
                                    if newValue.count <= 8 {
                                        settings.provinceCity = newValue
                                    }
                                }
                            ))
                            .foregroundStyle(.white, Color(hex: "#5C5C5C"))
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .font(.system(size: 17))
                                            .foregroundColor(.white)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                                
                                // 分割线
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                
                                // 不显示位置开关
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("不显示位置")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.white)
                                        Text("隐藏照片上的位置信息")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { !settings.showLocation },
                                        set: { settings.showLocation = !$0 }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#007AFF")))
                                    .scaleEffect(0.9)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2C2C2E"))
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                            
                            // 示例文字
                        HStack {
                            Text("示例：中国·北京、河南·洛阳、我的·记忆")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.5))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 12)
                    }
                    
                    // 头像、用户名设置部分 - 只在从SevenView调起时显示
                    if showAvatarSettings {
                        VStack(alignment: .leading, spacing: 0) {
                            // 标题
                            HStack {
                                Text("头像、用户名设置")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            
                            // 头像和用户名卡片
                            VStack(spacing: 0) {
                                // 头像设置
                                HStack(spacing: 16) {
                                    Text("头像")
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        selectedImage = nil // 重置选中的图片
                                        showingImagePicker = true
                                    }) {
                                        if let avatar = settings.userAvatar {
                                            Image(uiImage: avatar)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            Image("user_ss")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .frame(height: 70)
                                
                                // 分割线
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                    .padding(.leading, 20)
                                
                                // 用户名设置
                                VStack(spacing: 0) {
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("用户名")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.gray)
                                            TextField("独家记忆", text: Binding(
                                                get: { settings.userName },
                                                set: { newValue in
                                                    if newValue.count <= 10 {
                                                        settings.userName = newValue
                                                    }
                                                }
                                            ))
                                            .foregroundStyle(.white, Color(hex: "#767676"))
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .font(.system(size: 17))
                                            .foregroundColor(.white)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2C2C2E"))
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 60)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("更多设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("取消")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("保存")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(hex: "#007AFF"))
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
        }
        .fullScreenCover(isPresented: $showingCropView) {
            if let image = selectedImage {
                CropImageView(
                    image: image,
                    onCropComplete: { croppedImage in
                        settings.userAvatar = croppedImage
                        showingCropView = false
                        selectedImage = nil
                    },
                    onCancel: {
                        showingCropView = false
                        selectedImage = nil
                    }
                )
            }
        }
        .onChange(of: selectedImage) { _, newImage in
            if newImage != nil {
                showingCropView = true
            }
        }
    }
}

// 使用外部定义的ImagePicker

// 圆形裁切视图
struct CircularCropView: View {
    let image: UIImage
    let onCropComplete: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero
    @State private var baseScale: CGFloat = 1.0
    @State private var initialScale: CGFloat = 1.0
    
    private let cropSize: CGFloat = 280 // 增大圆形裁切区域
    
    // 计算最小缩放比例，确保图片能完全覆盖圆形区域
    private var minScale: CGFloat {
        let imageSize = image.size
        let imageAspectRatio = imageSize.width / imageSize.height
        
        // 计算最小缩放比例，确保图片能覆盖圆形区域
        let minScaleForCrop: CGFloat
        if imageAspectRatio > 1 {
            // 横图：以高度为准，需要更大的缩放
            minScaleForCrop = cropSize / UIScreen.main.bounds.width * imageAspectRatio
        } else {
            // 竖图：以宽度为准
            minScaleForCrop = cropSize / UIScreen.main.bounds.width / imageAspectRatio
        }
        
        // 设置一个合理的下限
        return max(minScaleForCrop, 0.5)
    }
    
    // 限制图片偏移，确保不超出圆形边界
    private func limitOffset(_ offset: CGSize) -> CGSize {
        let imageSize = image.size
        let scaledWidth = imageSize.width * imageScale
        let scaledHeight = imageSize.height * imageScale
        
        // 计算图片中心到圆形边界的最大距离
        let maxOffsetX = max(0, (scaledWidth - cropSize) / 2)
        let maxOffsetY = max(0, (scaledHeight - cropSize) / 2)
        
        let limitedX = max(-maxOffsetX, min(maxOffsetX, offset.width))
        let limitedY = max(-maxOffsetY, min(maxOffsetY, offset.height))
        
        return CGSize(width: limitedX, height: limitedY)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // 裁切区域
                    ZStack {
                        // 背景图片
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            .scaleEffect(imageScale)
                            .offset(imageOffset)
                            .onAppear {
                                // 设置初始缩放，确保图片能覆盖圆形区域
                                let imageSize = image.size
                                let imageAspectRatio = imageSize.width / imageSize.height
                                
                                // 计算最小缩放比例，确保图片能完全覆盖圆形区域
                                let minScaleForCrop: CGFloat
                                if imageAspectRatio > 1 {
                                    // 横图：以高度为准，需要更大的缩放
                                    minScaleForCrop = cropSize / UIScreen.main.bounds.width * imageAspectRatio
                                } else {
                                    // 竖图：以宽度为准
                                    minScaleForCrop = cropSize / UIScreen.main.bounds.width / imageAspectRatio
                                }
                                
                                initialScale = max(minScaleForCrop, 1.0)
                                imageScale = initialScale
                                baseScale = initialScale
                            }
                            .gesture(
                                SimultaneousGesture(
                                    DragGesture()
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
                                        },
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let newScale = baseScale * value
                                            imageScale = max(minScale, min(5.0, newScale))
                                            // 缩放时重新计算偏移限制
                                            imageOffset = limitOffset(imageOffset)
                                        }
                                        .onEnded { _ in
                                            baseScale = imageScale
                                            imageOffset = limitOffset(imageOffset)
                                            lastDragOffset = imageOffset
                                        }
                                )
                            )
                            .clipped()
                        
                        // 遮罩层
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                            .mask(
                                Rectangle()
                                    .overlay(
                                        Circle()
                                            .frame(width: cropSize, height: cropSize)
                                            .blendMode(.destinationOut)
                                    )
                            )
                        
                        // 裁切圆圈边框
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: cropSize, height: cropSize)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipped()
                    
                    Spacer()
                }
            }
            .navigationTitle("选择头像")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        cropImage()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func cropImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: cropSize, height: cropSize))
        let croppedImage = renderer.image { context in
            let containerSize = UIScreen.main.bounds.width
            let imageSize = image.size
            
            // 计算图片在fill模式下的显示尺寸
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
            if let cgImage = image.cgImage?.cropping(to: clampedRect) {
                let croppedUIImage = UIImage(cgImage: cgImage)
                // 将裁切后的图片绘制到输出尺寸
                croppedUIImage.draw(in: CGRect(origin: .zero, size: CGSize(width: cropSize, height: cropSize)))
            }
        }
        
        onCropComplete(croppedImage)
    }
}

#Preview {
    DmuView()
}
