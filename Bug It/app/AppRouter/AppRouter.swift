//
//  AppRouter.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import SwiftUI

@MainActor
final class AppRouter : ObservableObject {
    
    @Published var rootPath: [Route] = []
    
    func rootPop() {
        if !rootPath.isEmpty {
            rootPath.removeLast()
        }
    }
    
    func popTo (route : Route) {
        if rootPath.contains(route){
            
            while !rootPath.isEmpty &&  rootPath.last != route {
                rootPath.removeLast()
            }
            
        }
    }
    
    func pushTo(_ screen: Route) {
        rootPath.append(screen)
    }
    
    func reset() { rootPath = [] }
    
    func rebaseTo(_ screen: Route) {
        withAnimation(.easeInOut) {
            rootPath = [screen]
        }
        
    }
}
    
