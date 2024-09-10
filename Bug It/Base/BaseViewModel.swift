//
//  BaseViewModel.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//
import SwiftUI

class BaseViewModel : AlertViewModel {
    
    @Published var loading = false
        
    @ViewBuilder
    func loadingView () -> some View{
        if loading {
            CustomProgress()
        }else {
            EmptyView()
        }
        
    }

    
}
