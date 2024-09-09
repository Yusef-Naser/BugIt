//
//  AlertModifier.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    var alertTitle: String
    var alertMessage: String
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                //Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
}

extension View {
    func centralizedAlert(showAlert: Binding<Bool> , title : String , message: String  ) -> some View {
        self.modifier(AlertModifier(showAlert: showAlert, alertTitle: title, alertMessage: message ))
    }
}
