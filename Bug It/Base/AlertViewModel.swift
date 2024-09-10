//
//  AlertViewModel.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Combine

class AlertViewModel: ObservableObject {
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    func showAlert(title : String = "Alert" ,message: String ) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
