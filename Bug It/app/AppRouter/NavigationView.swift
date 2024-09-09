//
//  NavigationView.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import SwiftUI

struct NavigationView : View {
    
    @EnvironmentObject var appRouter : AppRouter
    
    var body: some View {
        
        VStack {
            
        }
        .debug("NavigationView")
        .onAppear(perform: {
            if let _ = LoginUserCase().getUserObject() {
                appRouter.pushTo(.bugItScreen)
            }else {
                appRouter.pushTo(.loginScreen)
            }
        })
        
        
    }
}
