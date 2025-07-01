//
//  ContentView.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    static func create(with viewModel: LoginViewModel) -> LoginView {
        return LoginView(viewModel: viewModel)
    }
    
    var body: some View {
        ZStack {
            TopView()
            InputView().frame(maxHeight: .infinity, alignment: .bottom)
            CustomProgressView(isVisible: $viewModel.showActivity)
        }
        .background(Color.appGrayBackground)
        .alert(isPresented: $viewModel.isPresentAlert) {
            Alert(title: Text(viewModel.errorMessage))
        }
    }
}

//MARK: - TopView
extension LoginView {
    @ViewBuilder
    private func TopView() -> some View {
        GeometryReader { proxy in
            VStack(alignment: .trailing) {
                Text("Продолжить как гость")
                    .font(.system(size: 18))
                    .padding(.top, 16)
                    .foregroundStyle(.gray)
                
            }.padding(16)
        }
    }
    
    //MARK: - InputView
    @ViewBuilder
    private func InputView() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Создайте аккаунт")
                    .font(.title.bold())
                    .foregroundStyle(.gray)
                
                Text("Добро пожаловать быструю регистрацию")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                
                Button {
                    coordinator.push(.signup)
                } label: {
                    HStack {
                        Text("У вас есть уже аккаунт?")
                        Text("Войдите").bold()
                    }
                    .font(.callout)
                    .foregroundStyle(.red)
                }
                
                HStack {
                    CustomButton(
                        imageName: nil,
                        buttonText: "Войти с Apple",
                        action: {
                            viewModel.loginTapped { isSuccess in
                                if isSuccess {
                                    coordinator.push(.tabBar)
                                }
                            }
                        },
                        imageTint: nil,
                        width: nil
                    )
                    
                    Spacer().frame(width: 16)
                    
                    CustomButton(
                        imageName: nil,
                        buttonText: "Войти с Google",
                        action: {
                            viewModel.loginTapped { isSuccess in
                                if isSuccess {
                                    coordinator.push(.tabBar)
                                }
                            }
                        },
                        imageTint: nil,
                        width: nil
                    )
                }
            }
            
            Text("или")
                .font(.system(size: 18))
                .foregroundStyle(.gray)
            
            TextField("",
                      text: $viewModel.username,
                      prompt: Text("введите почту/номер телефона"))
            .modifier(AppTextFieldModifier())
            
//            SecureField("",
//                        text: $viewModel.password,
//                        prompt: Text("Password"))
//            .modifier(AppTextFieldModifier())
            
//            CustomButton(
//                imageName: nil,
//                buttonText: "Продолжить",
//                action: {
//                    viewModel.loginTapped { isSuccess in
//                        if isSuccess {
//                            coordinator.push(.tabBar)
//                        }
//                    }
//                },
//                imageTint: nil,
//                width: 200
//            )
//            .padding(.top)
            
            CustomButton(
                imageName: nil,
                buttonText: "Продолжить",
                action: {
                    viewModel.loginTapped { isSuccess in
                        if isSuccess {
                            coordinator.push(.tabBar)
                        }
                    }
                },
                imageTint: nil,
                width: nil // или вообще не передавать
            )
            
            Button {
                coordinator.push(.confimationCode("2222"))
            } label: {
                HStack {
                    Text("Нажимая на кнопку")
                    Text("Продолжить")
                        .bold()
                    
//                Text("вы соглашаетесь на обработку персональных данных")
                }
                .font(.callout)
                .foregroundStyle(.gray)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(.background)
        
    }
}

#Preview {
    LoginView.create(with: LoginViewModel.mock)
        .environmentObject(Coordinator())
}
