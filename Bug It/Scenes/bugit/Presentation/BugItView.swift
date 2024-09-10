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
    @State private var imageUrl = ""
    @StateObject var viewModel = BugItViewModel()
    
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
                
                if !imageUrl.isEmpty {
                    Link("Link Image", destination: URL(string: imageUrl)!)
                        .padding()
                }
                
               
                createHorizontalButtons
                
                Spacer()
                
                Button(action: logOut) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
            }
            viewModel.loadingView()
        }
        .centralizedAlert(showAlert: $viewModel.showAlert, title: viewModel.alertTitle, message: viewModel.alertMessage)
    }
    
    var createHorizontalButtons : some View {
        HStack {
            Button(action: {
                if let image = selectedImage , let actualImage = image.jpegData(compressionQuality: 1){
                    viewModel.uploadImage(description: strDescription, image: actualImage) { url in
                        if let url = url {
                            self.imageUrl = url
                            strDescription = ""
                            selectedItems = []
                            selectedImage = nil
                        }
                    }
                }
            }) {
                Text("Upload Image")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
            
            if !imageUrl.isEmpty {
                Button(action: {
                    viewModel.updateSheet(description: strDescription , imageLink: imageUrl) {
                        
                    }
                }) {
                    Text("Update Sheet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
            
        }
        .padding()
    }
    
    func logOut () {
        appRouter.rebaseTo(.loginScreen )
    }
    
    
    
}
