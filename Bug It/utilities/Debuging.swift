//
//  Debuging.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import SwiftUI

struct DebugViewModifier: ViewModifier {
    let viewName: String

    func body(content: Content) -> some View {
        content
            .navigationBarHidden(true)
            .onAppear {
                print("\(viewName) appeared")
            }
            .onDisappear {
                print("\(viewName) disappeared")
            }
    }
}

extension View {
    func debug(_ name: String) -> some View {
        self.modifier(DebugViewModifier(viewName: name))
    }
}
