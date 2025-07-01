//
//  VerificationView.swift
//  Shopping
//
//  Created by DAS  on 27/5/25.
//

import SwiftUI
import UIKit
import Combine

import SwiftUI

struct ConfirmationCodeView: View {
    @StateObject private var viewModel = CodeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Код подтверждения")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("Пожалуйста, введите код подтверждения, который мы отправили на почту example@gmail.com")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            CodeInputView(code: $viewModel.code, length: 6)
                .padding(.vertical, 30)
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Отправить еще раз") {
                viewModel.resendCode()
            }
            .foregroundColor(.blue)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
        .onChange(of: viewModel.code) { newValue in
            if newValue.count == 6 {
                viewModel.verifyCode()
            }
        }
        .alert("Успешно", isPresented: $viewModel.isSuccess) {
            Button("OK") {}
        } message: {
            Text("Код подтвержден!")
        }
    }
}

struct CodeInputView: View {
    @Binding var code: String
    let length: Int
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // Скрытое поле для ввода
            TextField("", text: $code)
                .focused($isFocused)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 0, height: 0)
                .opacity(0)
                .onChange(of: code) { newValue in
                    if newValue.count > length {
                        code = String(newValue.prefix(length))
                    }
                }
            
            // Визуальное отображение
            HStack(spacing: 10) {
                ForEach(0..<length, id: \.self) { index in
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
}

class CodeViewModel: ObservableObject {
    @Published var code = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var isSuccess = false
    
    func verifyCode() {
        isLoading = true
        error = nil
        
        // Симуляция сетевого запроса
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            if self.code == "123456" { // Тестовый код
                self.isSuccess = true
            } else {
                self.error = "Неверный код. Попробуйте еще раз."
            }
        }
    }
    
    func resendCode() {
        code = ""
        // Реализация повторной отправки кода
    }
}

// SMS Reader helper class
class SMSReader: NSObject {
    private var cancellables = Set<AnyCancellable>()
    private var listener: ((String) -> Void)?
    
    func startListening(completion: @escaping (String) -> Void) {
        self.listener = completion
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
            .sink { _ in
                // This is a placeholder for actual SMS reading
                // In a real app, you would use:
                // 1. SMS Retriever API on Android
                // 2. For iOS, you need to request SMS permission and use the API
                // For demo purposes, we'll simulate it
            }
            .store(in: &cancellables)
    }
    
    func stopListening() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        listener = nil
    }
    
    // Simulate receiving SMS (for demo)
    func simulateReceivedSMS(code: String) {
        listener?(code)
    }
}

struct ConfirmationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationCodeView()
    }
}
