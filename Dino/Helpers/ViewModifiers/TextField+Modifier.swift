//
//  TextField+Modifier.swift
//  Shopping
//
//  Created by Das
//

import Foundation
import SwiftUI

struct AppTextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.all, 8)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.appPrimaryColor)
            }
    }
}
