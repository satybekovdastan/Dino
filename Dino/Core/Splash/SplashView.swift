//
//  SplashView.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI
import Swinject

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundStyle(.appOrange)
                        .frame(width: 300)
                    
                    Image(systemName: "cart")
                        .foregroundStyle(.white)
                        .font(.system(size: 100))
                }
                Spacer()
                Text("© Das 2025 ©")
                    .font(.callout)
            }
            .onAppear {
                viewModel.manageSplashAction { isAuth in
                    if isAuth {
                        coordinator.push(.tabBar)
                    } else {
                        coordinator.push(.login)
                    }
                }
            }
            .alert(isPresented: $viewModel.presentConnectionAlert) {
                Alert(
                    title: Text("No internet connection."),
                    message: Text("Try again."),
                    dismissButton: .cancel(Text("Done"), action: {  viewModel.manageSplashAction { isAuth in
                        if isAuth {
                            coordinator.push(.tabBar)
                        } else {
                            coordinator.push(.login)
                        }
                    } }))
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    Assembler.shared.resolver.resolve(LoginView.self).navigationBarBackButtonHidden()
                case .signup:
                    SignUpView()
                        .navigationBarBackButtonHidden()
                case .productDetail(let product):
                    ProductDetailView(product: product)
                case .tabBar:
                    MainTabbarView()
                        .navigationBarBackButtonHidden()
                case .cart:
                    CartView()
                case .completeOrder(let order):
                    CompleteOrderView(order: order)
                case .confimationCode(let phone):
                    ConfirmationCodeView().navigationBarBackButtonHidden()
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(Coordinator())
}
