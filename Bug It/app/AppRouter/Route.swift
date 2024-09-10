//
//  Route.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import SwiftUI

enum Route  {
    case loginScreen
    case bugItScreen
    
}

extension Route: View {
    
    var body: some View {
        switch self {
        case .loginScreen:
            LoginView()
                .debug("LoginView")
        case .bugItScreen:
            BugItView()
                .debug("bugItScreen")
        
        }
    }
}

extension Route: Hashable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.loginScreen, .loginScreen),
            (.bugItScreen, .bugItScreen):
            return true
        default :
            return false
        }
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }

}
