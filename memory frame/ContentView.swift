//
//  ContentView.swift
//  memory frame
//
//  Created by feng on 2025/6/13.
//

import SwiftUI
import PhotosUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showingOneView = false
    @State private var showingTwoView = false
    @State private var showingThreeView = false
    @State private var showingFourView = false
    @State private var showingFiveView = false
    @State private var showingSixView = false
    @State private var showingSevenView = false
    @State private var showingEightView = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingPhotoPicker = false
    @State private var selectedFrameIndex: Int = 0
    
    // 计算矩形尺寸
    private func calculateFrameSize(screenWidth: CGFloat) -> CGSize {
        let totalHorizontalPadding: CGFloat = 24 * 3 // 左右边距各24pt + 中间间距24pt
        let frameWidth = (screenWidth - totalHorizontalPadding) / 2
        let frameHeight = frameWidth / 0.8
        return CGSize(width: frameWidth, height: frameHeight)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 24),
                        GridItem(.flexible(), spacing: 24)
                    ], spacing: 24) {
                        ForEach(0..<8, id: \.self) { index in
                            FrameItemView(
                                index: index, 
                                frameSize: calculateFrameSize(screenWidth: geometry.size.width)
                            ) {
                                selectedFrameIndex = index
                                showingPhotoPicker = true
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
                .background(Color(hex: "#0C0F14"))
                .navigationTitle("选择相框")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(hex: "#0C0F14"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedItem) { oldValue, newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            await MainActor.run {
                                selectedImage = image
                                selectedItem = nil // 重置选择项避免重复触发
                                showingPhotoPicker = false
                                // 根据选择的相框索引进入不同视图
                                if selectedFrameIndex == 0 {
                                    showingOneView = true
                                } else if selectedFrameIndex == 1 {
                                    showingTwoView = true
                                } else if selectedFrameIndex == 2 {
                                    showingThreeView = true
                                } else if selectedFrameIndex == 3 {
                                    showingFourView = true
                                } else if selectedFrameIndex == 4 {
                                    showingFiveView = true
                                } else if selectedFrameIndex == 5 {
                                    showingSixView = true
                                } else if selectedFrameIndex == 6 {
                                    showingSevenView = true
                                } else if selectedFrameIndex == 7 {
                                    showingEightView = true
                                } else {
                                    showingOneView = true // 其他索引默认进入OneView
                                }
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingOneView) {
            if let image = selectedImage {
                OneView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingTwoView) {
            if let image = selectedImage {
                TwoView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingThreeView) {
            if let image = selectedImage {
                ThreeView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingFourView) {
            if let image = selectedImage {
                FourView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingFiveView) {
            if let image = selectedImage {
                FiveView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingSixView) {
            if let image = selectedImage {
                SixView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingSevenView) {
            if let image = selectedImage {
                SevenView(selectedImage: image)
            }
        }
        .fullScreenCover(isPresented: $showingEightView) {
            if let image = selectedImage {
                EightView(selectedImage: image)
            }
        }
    }
}

struct FrameItemView: View {
    let index: Int
    let frameSize: CGSize
    let onTap: () -> Void
    
    var body: some View {
        if index == 0 {
            Image("one")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 1 {
            Image("two")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 2 {
            Image("three")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 3 {
            Image("four")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 4 {
            Image("five")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 5 {
            Image("six")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 6 {
            Image("seven")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else if index == 7 {
            Image("eight")
                .resizable()
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    onTap()
                }
        } else {
            Rectangle()
                .fill(Color.white)
                .frame(width: frameSize.width, height: frameSize.height)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                        Text("相框 \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
                .onTapGesture {
                    onTap()
                }
        }
    }
}

#Preview {
    ContentView()
}

#Preview("FrameItemView") {
    FrameItemView(index: 0, frameSize: CGSize(width: 150, height: 187.5)) {
        print("Frame tapped")
    }
}
