//
//  BugItViewModel.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

struct Fields {
    struct Values {
        var enable : Bool
        var value : String
    }
    var priority : Values = Values(enable: false , value: "")
    var labels : Values = Values(enable: false , value: "")
    var assignee : Values = Values(enable: false , value: "")
    var multiImages : Values = Values(enable: false , value: "")
    
}

class BugItViewModel : BaseViewModel {
    
    @Published var useCase = BugItUseCase()
    
    @Published var fields = Fields()
    
    func uploadImage (image : Data , success : @escaping (String?)->Void) {
        loading = true
        Task {
            do {
                let data = try await useCase.uploadImage( image: image)
                
                loading = false
                success(data?.data?.link)
                self.showAlert(message: "Success" )
            }catch {
                loading = false
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func updateSheet (description : String , imageLink : String , success : @escaping ()->Void) {
        
        if description.isEmpty {
            self.showAlert(message: "Please Add Description")
            return
        }
        
        if fields.priority.enable && fields.priority.value.isEmpty {
            self.showAlert(message: "Please Add Priority")
            return
        }
        
        if fields.labels.enable && fields.labels.value.isEmpty {
            self.showAlert(message: "Please Add Label")
            return
        }
        
        if fields.assignee.enable && fields.assignee.value.isEmpty {
            self.showAlert(message: "Please Add Assignee")
            return
        }
        
        loading = true
        Task {
            do {
                let data = try await useCase.updateSheet(description: description , priority: fields.priority, labels: fields.labels , assignee: fields.assignee , imageLink: imageLink)
                
                loading = false
                success()
                self.showAlert(message: "Success Sheet Update" )
            }catch {
                loading = false
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
}
