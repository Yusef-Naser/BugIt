//
//  UploadView.swift
//  Bug It
//
//  Created by yusef naser on 12/09/2024.
//

import SwiftUI
import PhotosUI

struct UploadView : View {
    
    @EnvironmentObject var appRouter : AppRouter
    @State var multipleImages = false
    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @StateObject var viewModel = UploadViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                navigationView
                
                Form {
                    Section {
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: (multipleImages) ? 2 : 1, matching: .images) {

                                ZStack {
                                    
                                    if  selectedImages.count > 0 {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .frame( height: 150)
                                        
                                        HStack {
                                            ForEach (selectedImages.indices , id:\.self ) { index in
                                                Image(uiImage: selectedImages[index])
                                                    .resizable()
                                                    .foregroundColor(.white)
                                            }
                                        }
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
                                    selectedImages = []
                                    for item in newItems {
                                        if let data = try? await item.loadTransferable(type: Data.self),
                                           let image = UIImage(data: data) {
                                            selectedImages.append(image)
                                        }
                                    }
                                }
                            }
                    } header: {
                            Text("Attach Image")
                                .foregroundStyle(.black)
                                .textCase(nil)
                                .listRowInsets(EdgeInsets())
                    }
                }

                
                
                Button(action: {
                    if selectedImages.count > 0 {
                        
                        let imagesData = selectedImages
                            //.compactMap { $0 }
                            .map { image in
                                
                            image.jpegData(compressionQuality: 1)!
                        }
                        viewModel.uploadImage(images : (multipleImages) ? imagesData : [imagesData[0]]) { url in
                            if url.count > 0 {
                                appRouter.pushTo(.bugItScreen(imageLinks: url))
                                self.selectedImages = []
                                self.selectedItems = []
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
                
                Button(action: logOut) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    getImageFromShare()
                }
            }
            viewModel.loadingView()
        }
        
        .centralizedAlert(showAlert: $viewModel.showAlert, title: viewModel.alertTitle, message: viewModel.alertMessage)
    }
    
    
    var navigationView : some View {
        HStack {
            
            Button(action: {}, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            .padding()
            .disabled(true )
            .opacity(0)
            
            
            Spacer()
            
            Text("Upload Image")
                .padding()
            
            Spacer()
            
            Button(action: {
                multipleImages.toggle()
                if selectedItems.count > 1 && selectedImages.count > 1 {
                    selectedItems = [selectedItems[0]]
                    selectedImages = [selectedImages[0]]
                }
            }, label: {
                Text( ( multipleImages ) ? "Single Image" : "Multiple Images" )
            })
            .padding()
        }
    }
    
    func logOut () {
        KeychainManger.shared.clear()
        appRouter.rebaseTo(.loginScreen )
    }
    
    
    func appWillEnterForeground() {
        
    }
    
    func getImageFromShare () {
        if let sharedImage = retrieveSharedImage() {
            // Use the image (display it, process it, etc.)
            print("Shared image retrieved successfully!")
            // Example: Set it to an imageView
            let imageView = UIImageView(image: sharedImage)
            if let image = imageView.image {
                selectedImages.append(image)
            }
            
        } else {
            print("No shared image found.")
        }
    }
    
    func retrieveSharedImage() -> UIImage? {
        let fileURL = getSharedContainerURL().appendingPathComponent("sharedImage.png")
        if let imageData = try? Data(contentsOf: fileURL) {
            deleteFile(at: fileURL)
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
    
    
    func deleteFile(at fileURL: URL) {
        let fileManager = FileManager.default
        
        // Check if the file exists at the given URL
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                // Attempt to delete the file
                try fileManager.removeItem(at: fileURL)
                print("File successfully deleted.")
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }
}
