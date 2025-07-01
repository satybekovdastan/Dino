//
//  CodeTextField.swift
//  Shopping
//
//  Created by DAS  on 27/5/25.
//
import SwiftUI

struct CodeTextField: View {
    @State var code: String = ""
    @FocusState private var isFocused: Bool
    private let codeLength = 6
    
    var body: some View {
        VStack {
            ZStack {
                // Скрытое текстовое поле для ввода
                TextField("", text: $code)
                    .focused($isFocused)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 0, height: 0)
                    .opacity(0)
                    .onChange(of: code) { newValue in
                        if newValue.count > codeLength {
                            code = String(newValue.prefix(codeLength))
                        }
                    }
                
                // Визуальное отображение кода
                HStack(spacing: 10) {
                    ForEach(0..<codeLength, id: \.self) { index in
                        let digit = code.count > index ? String(code[code.index(code.startIndex, offsetBy: index)]) : ""
                        
                        Text(digit)
                            .frame(width: 40, height: 50)
                            .font(.system(size: 24, weight: .bold))
                            .background(
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(isFocused && code.count == index ? .blue : .gray)
                                }
                            )
                            .onTapGesture {
                                isFocused = true
                            }
                    }
                }
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
            
            Text("Введите \(codeLength)-значный код из SMS")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct WhatsAppLikeCodeInput_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextField()
    }
}
