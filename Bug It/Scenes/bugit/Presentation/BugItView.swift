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
                
                HStack {
                    
                    Spacer()
                    
                    Text("BUG IT")
                        .padding()
                    
                    Spacer()
                    
                    setupMenu
                        .padding()
                }
                
                
                Spacer()
                
                Form {
                    
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
                    
                    Section {
                        TextEditor(text: $strDescription)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            .frame( height: 100)
                    } header: {
                        Text ("Description")
                            .foregroundStyle(.black)
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                    }
                    
                    if viewModel.fields.priority.enable {
                        Section {
                            TextField("Priority",text: $viewModel.fields.priority.value )
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        } header: {
                            Text ("Priority")
                                .foregroundStyle(.black)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                        }
                    }

                    if viewModel.fields.labels.enable {
                        Section {
                            TextField("Labels", text: $viewModel.fields.labels.value )
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        } header: {
                            Text ("Labels")
                                .foregroundStyle(.black)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                        }
                    }

                    if viewModel.fields.assignee.enable {
                        Section {
                            TextField("Assignee",text: $viewModel.fields.assignee.value )
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        } header: {
                            Text ("Assignee")
                                .foregroundStyle(.black)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    
                    if viewModel.fields.multiImages.enable {
                        
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
        .onAppear(perform: {
            getImageFromShare()
        })
        .centralizedAlert(showAlert: $viewModel.showAlert, title: viewModel.alertTitle, message: viewModel.alertMessage)
    }
    
    var createHorizontalButtons : some View {
        HStack {
            Button(action: {
                if let image = selectedImage , let actualImage = image.jpegData(compressionQuality: 1){
                    viewModel.uploadImage( image: actualImage) { url in
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
    
    var setupMenu : some View {
        Menu  {
            
            Button("Priority", action: {
                viewModel.fields.priority.enable.toggle()
            })
            Button("Labels", action: {
                viewModel.fields.labels.enable.toggle()
            })
            
            Button("Assignee", action: {
                viewModel.fields.assignee.enable.toggle()
            })
            
            Button("Multi Images", action: {
                viewModel.fields.multiImages.enable.toggle()
            })
            
        } label: {
            
            Image(systemName: "ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
            
        }
    }
    
    func logOut () {
        appRouter.rebaseTo(.loginScreen )
    }
    
    func getImageFromShare () {
        if let sharedImage = retrieveSharedImage() {
            // Use the image (display it, process it, etc.)
            print("Shared image retrieved successfully!")
            // Example: Set it to an imageView
            let imageView = UIImageView(image: sharedImage)
            selectedImage = imageView.image
        } else {
            print("No shared image found.")
        }
    }
    
    func retrieveSharedImage() -> UIImage? {
        let fileURL = getSharedContainerURL().appendingPathComponent("sharedImage.png")
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func getSharedContainerURL() -> URL {
        let appGroupName = "group.com.bugit.Bug-It"
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) else {
            fatalError("Shared container not found")
        }
        return containerURL
    }
    
}
