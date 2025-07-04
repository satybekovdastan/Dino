//
//  CustomStepperView.swift
//  Shopping
//
//  Created by Das
//

import SwiftUI

struct CustomStepperView: View {
    
    @State var count: Int
    var changedValue: ((Int) -> Void)?
    
    private func plus() {
        self.count += 1
        changedValue?(count)
    }
    
    private func minus() {
        self.count = count - 1
        changedValue?(count)
    }
    
    var body: some View {
        VStack {
            Button {
                self.plus()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.all, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.appOrange)
                    }
            }
            .frame(width: 36, height: 36)
            
            Text("\(count)")
                .font(.title3)
                .foregroundStyle(.black)
            
            Button {
                self.minus()
            } label: {
                Image(systemName: "minus")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.appOrange)
                    }
            }
            .frame(width: 36, height: 36)
        }
    }
}

#Preview {
    CustomStepperView(count: 0, changedValue: nil)
}
