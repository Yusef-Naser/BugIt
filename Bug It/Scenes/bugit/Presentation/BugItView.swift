//
//  BugItView.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import SwiftUI
import PhotosUI

struct BugItView : View {
    
    @EnvironmentObject var appRouter : AppRouter
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var strDescription = ""
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("BUG IT")
                    .padding()
                
                Spacer()
                
                Form {
                    Section {
                        TextEditor(text: $strDescription)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            .frame( height: 150)
                    } header: {
                        Text ("Description")
                            .foregroundStyle(.black)
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                    }
                    
                    Section {
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {

                                ZStack {
                                    
                                    if let image = selectedImage {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .frame( height: 150)
                                        
                                        Image(uiImage: image)
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame( height: 140)
                                            .padding()
                                    }else {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .frame( height: 150)
                                        Image(systemName: "plus")
                                    }
                                    
                                }
                            }
                            .onChange(of: selectedItems) { newItems in
                                Task {
                                    selectedImage = nil
                                    for item in newItems {
                                        if let data = try? await item.loadTransferable(type: Data.self),
                                           let image = UIImage(data: data) {
                                            selectedImage = image
                                        }
                                    }
                                }
                            }
                    } header: {
                            Text("Attach File")
                                .foregroundStyle(.black)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                    }
                }
                
                Button(action: {
                    
                }, label: {
                    Text("Upload Image")
                    
                })
                
                
                Spacer()
                
                Button(action: logOut) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
            }
        }
        .centralizedAlert(showAlert: <#T##Binding<Bool>#>, title: <#T##String#>, message: <#T##String#>)
    }
    
    func logOut () {
        appRouter.rebaseTo(.loginScreen )
    }
    
}
