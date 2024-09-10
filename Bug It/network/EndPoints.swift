//
//  EndPoints.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

enum EndPoints  {
    
    case uploadImage
    case updateSheet(sheetID : String , tabName : String)
   

    var path : String {
        switch self {
        case .uploadImage:
            return "https://api.imgur.com/3/image"
        case .updateSheet(let sheetID , let tabName):
            return "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(tabName):append?valueInputOption=USER_ENTERED"
        }
    }
}
