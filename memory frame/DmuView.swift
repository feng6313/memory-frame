//
//  DmuView.swift
//  memory frame
//
//  Created on 2025-06-14.
//

import SwiftUI

struct DmuView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0C0F14")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("更多功能")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("此页面待开发")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .navigationTitle("更多")
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DmuView()
}