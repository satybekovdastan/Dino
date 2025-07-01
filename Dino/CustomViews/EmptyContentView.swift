//
//  EmptyContentView.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI

struct EmptyContentView: View {
    
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle")
                .font(.title)
            Text(title)
                .font(.headline)
            Text(description)
                .font(.callout)
        }
    }
}

#Preview {
    EmptyContentView(title: "Conttnet failure", description: "Favorilerde ürün bulunmamaktadır.")
}
