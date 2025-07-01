//
//  CustomButton.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI

import SwiftUI

struct CustomButton: View {
    let imageName: String?
    let buttonText: String
    let action: () -> Void
    let imageTint: Color?
    let width: CGFloat?

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let imageName,
                   let imageTint {
                    Image(systemName: imageName)
                        .foregroundStyle(imageTint)
                }

                Text(buttonText)
                    .fontWeight(.semibold)
            }
            .frame(
                maxWidth: width ?? .infinity,
                minHeight: 52
            )
            .padding(.horizontal)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appOrange)
            )
        }
    }
}

//struct CustomButton: View {
//    let imageName: String?
//    let buttonText: String
//    let action: () -> Void
//    let imageTint: Color?
//    let width: CGFloat
//    
//    var body: some View {
//        HStack(spacing: 4) {
//            if let imageName,
//               let imageTint{
//                Image(systemName: imageName)
//                    .foregroundStyle(imageTint)
//            }
//            Button(buttonText, action: action)
//        }
//        .frame(minWidth: width)
//        .foregroundStyle(.white)
//        .padding(.vertical, 16)
//        .padding(.horizontal, 10)
//        .background(RoundedRectangle(cornerRadius: 16)
//            .foregroundStyle(.appOrange))
//    }
//}
