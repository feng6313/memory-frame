//
//  EnterView.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI

struct EnterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var memoryText: String
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    
    // 内置回忆内容
    private let presetMemories = [
        "我的独家记忆",
        "所有的美好都值得记录",
        "当你无聊的时候，就看看照片",
        "生日快乐",
        "年轻真好"
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#0C0F14")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // 主要输入区域
                        VStack {
                            Spacer()
                            
                            // 输入框
                            TextField("", text: $memoryText, axis: .vertical)
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2...10)
                                .focused($isTextFieldFocused)
                                .onAppear {
                                    // 页面出现后自动聚焦并将光标移到文字末尾
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isTextFieldFocused = true
                                    }
                                }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 20)
                        
                        // 内置回忆内容区域
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(presetMemories, id: \.self) { memory in
                                    Button(action: {
                                        memoryText = memory
                                        // 点击后重新聚焦输入框
                                        isTextFieldFocused = true
                                    }) {
                                        Text(memory)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color(hex: "#2C2C2E"))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, keyboardHeight > 0 ? 20 : max(20, geometry.safeAreaInsets.bottom))
                    }
                }
            }
            .navigationTitle("输入回忆")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
                        // 数据已通过Binding自动同步到OneView
                        dismiss()
                    }) {
                        Text("确定")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
            }
        }
    }
}

#Preview {
    EnterView(memoryText: .constant("我的独家记忆"))
}
