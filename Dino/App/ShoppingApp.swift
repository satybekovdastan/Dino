//
//  ShoppingApp.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI

@main
struct ShoppingApp: App {
    
    @StateObject private var coordinator: Coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(self.coordinator)
        }
    }
    
    init() {
        pageControlAppearence()
        navBarAppearance()
        alertViewButtonTintAppearance()
    }
    
    private func pageControlAppearence() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .appOrange
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private func navBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.appOrange]
        UIBarButtonItem.appearance().tintColor = UIColor.appOrange
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    private func alertViewButtonTintAppearance() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .appOrange
    }
}
