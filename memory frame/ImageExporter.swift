//
//  ImageExporter.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI
import Photos
import UIKit

/// 图片导出工具类
/// 提供统一的图片保存到相册功能，支持权限检查、高分辨率渲染和图片压缩
class ImageExporter {
    
    /// 保存结果回调
    typealias SaveCompletion = (Bool, String) -> Void
    
    /// 保存任意SwiftUI视图为图片到相册
    /// - Parameters:
    ///   - content: 要保存的SwiftUI视图
    ///   - size: 导出尺寸，默认为1464x1830（0.8:1比例）
    ///   - scale: 渲染比例，默认为5.0（高分辨率）
    ///   - maxSize: 最大尺寸限制，超过会压缩，默认2048
    ///   - completion: 完成回调，返回(成功状态, 消息)
    static func saveToPhotoLibrary<Content: View>(
        content: Content,
        size: CGSize = CGSize(width: 1464, height: 1830),
        scale: CGFloat = 5.0,
        maxSize: CGFloat = 2048,
        completion: @escaping SaveCompletion
    ) {
        print("开始保存图片到相册流程")
        
        // 检查相册访问权限
        checkPhotoLibraryPermission { hasPermission in
            if hasPermission {
                // 有权限，开始渲染和保存
                renderAndSave(
                    content: content,
                    size: size,
                    scale: scale,
                    maxSize: maxSize,
                    completion: completion
                )
            } else {
                // 没有权限
                DispatchQueue.main.async {
                    completion(false, "需要相册访问权限才能保存图片")
                }
            }
        }
    }
    
    /// 检查相册访问权限
    private static func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        print("当前相册权限状态: \(status.rawValue)")
        
        switch status {
        case .authorized, .limited:
            print("已有相册权限")
            completion(true)
            
        case .denied:
            print("相册权限被拒绝")
            completion(false)
            
        case .notDetermined:
            print("相册权限未确定，请求权限")
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                print("权限请求结果: \(newStatus.rawValue)")
                switch newStatus {
                case .authorized, .limited:
                    completion(true)
                case .denied:
                    completion(false)
                default:
                    completion(false)
                }
            }
            
        case .restricted:
            print("相册权限受限")
            completion(false)
            
        @unknown default:
            print("未知权限状态")
            completion(false)
        }
    }
    
    /// 渲染视图并保存到相册
    private static func renderAndSave<Content: View>(
        content: Content,
        size: CGSize,
        scale: CGFloat,
        maxSize: CGFloat,
        completion: @escaping SaveCompletion
    ) {
        print("开始渲染视图")
        
        // 确保在主线程上执行渲染操作
        DispatchQueue.main.async {
            // 使用SwiftUI的ImageRenderer来渲染视图
            let renderer = ImageRenderer(content: content)
            
            // 设置渲染尺寸
            renderer.proposedSize = ProposedViewSize(width: size.width, height: size.height)
            
            // 设置高分辨率渲染
            renderer.scale = scale
            
            // 渲染图片
            guard let renderedImage = renderer.uiImage else {
                print("视图渲染失败")
                completion(false, "截图失败，无法保存")
                return
            }
            
            print("视图渲染成功，尺寸: \(renderedImage.size)")
            
            // 检查图片大小，如果太大则压缩
            let imageToSave = compressImageIfNeeded(renderedImage, maxSize: maxSize)
            
            // 保存到相册
            saveImageToPhotoLibrary(imageToSave, completion: completion)
        }
    }
    
    /// 压缩图片（如果需要）
    private static func compressImageIfNeeded(_ image: UIImage, maxSize: CGFloat) -> UIImage {
        if image.size.width > maxSize || image.size.height > maxSize {
            print("图片过大，开始压缩")
            let scale = min(maxSize / image.size.width, maxSize / image.size.height)
            let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let compressedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
            print("图片压缩完成，新尺寸: \(compressedImage.size)")
            return compressedImage
        } else {
            print("图片尺寸合适，无需压缩")
            return image
        }
    }
    
    /// 保存图片到相册
    private static func saveImageToPhotoLibrary(_ image: UIImage, completion: @escaping SaveCompletion) {
        print("开始执行PHPhotoLibrary.performChanges")
        PHPhotoLibrary.shared().performChanges({
            print("在performChanges闭包中")
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            print("创建保存请求成功: \(request)")
        }) { success, error in
            print("PHPhotoLibrary.performChanges 完成回调: success=\(success), error=\(String(describing: error))")
            
            DispatchQueue.main.async {
                if success {
                    print("图片保存成功")
                    completion(true, "图片已保存到相册")
                } else if let error = error {
                    print("图片保存失败: \(error)")
                    completion(false, "保存失败: \(error.localizedDescription)")
                } else {
                    print("图片保存失败: 未知错误")
                    completion(false, "保存失败: 未知错误")
                }
            }
        }
        print("PHPhotoLibrary.performChanges 调用完成")
    }
}

// MARK: - 便捷扩展
extension ImageExporter {
    
    /// 保存PhotoFrameView到相册的便捷方法
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrame(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameView
        let photoFrameView = PhotoFrameView(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameView, completion: completion)
    }
    
    /// 保存PhotoFrameViewTwo到相册的便捷方法（TwoView专用）
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrameTwo(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameViewTwo
        let photoFrameViewTwo = PhotoFrameViewTwo(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameViewTwo, completion: completion)
    }
    
    /// 保存PhotoFrameViewThree到相册的便捷方法（ThreeView专用）
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrameThree(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameViewThree
        let photoFrameViewThree = PhotoFrameViewThree(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameViewThree, completion: completion)
    }
    
    /// 保存PhotoFrameViewFour到相册的便捷方法（FourView专用）
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrameFour(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameViewFour
        let photoFrameViewFour = PhotoFrameViewFour(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameViewFour, completion: completion)
    }
    
    /// 保存PhotoFrameViewFive到相册的便捷方法（FiveView专用）
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrameFive(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameViewFive
        let photoFrameViewFive = PhotoFrameViewFive(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameViewFive, completion: completion)
    }
    
    /// 保存PhotoFrameViewSix到相册的便捷方法（SixView专用）
    /// - Parameters:
    ///   - image: 原始图片
    ///   - screenWidth: 屏幕宽度
    ///   - imageScale: 图片缩放比例
    ///   - imageOffset: 图片偏移量
    ///   - memoryText: 回忆文字
    ///   - frameColorIndex: 边框颜色索引
    ///   - textColorIndex: 文字颜色索引
    ///   - timeColorIndex: 时间颜色索引
    ///   - locationColorIndex: 地点颜色索引
    ///   - iconColorIndex: 图标颜色索引
    ///   - completion: 完成回调
    static func savePhotoFrameSix(
        image: UIImage,
        screenWidth: CGFloat,
        imageScale: CGFloat,
        imageOffset: CGSize,
        memoryText: String,
        frameColorIndex: Int,
        textColorIndex: Int,
        timeColorIndex: Int,
        locationColorIndex: Int,
        iconColorIndex: Int,
        completion: @escaping SaveCompletion
    ) {
        // 验证图片有效性
        guard image.size.width > 0 && image.size.height > 0 else {
            print("图片验证失败: 尺寸无效")
            DispatchQueue.main.async {
                completion(false, "图片无效，无法保存")
            }
            return
        }
        
        print("图片验证通过，尺寸: \(image.size)")
        
        // 创建PhotoFrameViewSix
        let photoFrameViewSix = PhotoFrameViewSix(
            image: image,
            screenWidth: screenWidth,
            imageScale: .constant(imageScale),
            imageOffset: .constant(imageOffset),
            showEnterView: .constant(false),
            memoryText: .constant(memoryText),
            frameColorIndex: frameColorIndex,
            textColorIndex: textColorIndex,
            timeColorIndex: timeColorIndex,
            locationColorIndex: locationColorIndex,
            iconColorIndex: iconColorIndex
        )
        
        // 保存到相册
        saveToPhotoLibrary(content: photoFrameViewSix, completion: completion)
    }
}