//
//  CustomProgress.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import SwiftUI

struct CustomProgress: View {

    var body: some View {
        ZStack {
            // Background view
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()

            // Progress view in the center
            VStack {
                Spacer()
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5) // Increase size of the progress view
                    .padding()
                Spacer()
            }
            
        }
    }
}
