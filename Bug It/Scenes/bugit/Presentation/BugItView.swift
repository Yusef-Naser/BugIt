//
//  BugItView.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import SwiftUI


struct BugItView : View {
    
    @EnvironmentObject var appRouter : AppRouter
  
    @State private var strDescription = ""
    @StateObject var viewModel = BugItViewModel()
    @State var imageUrls : [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                
                HStack {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    .padding()
                    
                    Spacer()
                    
                    Text("BUG IT")
                        .padding()
                    
                    Spacer()
                    
                    setupMenu
                        .padding()
                }
                
                
                Spacer()
                
                Form {
                  
                    if !imageUrls.isEmpty {
                        ForEach (imageUrls.indices , id:\.self ){ index in
                            Link("Link Image", destination: URL(string: imageUrls[index])!)
                                .padding()
                        }
                        
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

                }
                
               
                
               
                Button(action: {
                    viewModel.updateSheet(description: strDescription , imageLinks: imageUrls) {
                         presentationMode.wrappedValue.dismiss()
                    } completionError: {
                        appRouter.rebaseTo(.loginScreen)
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

    
    func logOut () {
        KeychainManger.shared.clear()
        appRouter.rebaseTo(.loginScreen )
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
            
        } label: {
            
            Image(systemName: "ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
            
        }
    }
    
}
