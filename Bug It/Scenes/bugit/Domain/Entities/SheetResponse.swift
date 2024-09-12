//
//  EmptyResponse.swift
//  Bug It
//
//  Created by yusef naser on 11/09/2024.
//

struct SheetResponse : Codable {
    let updates: Updates?
    let spreadsheetID, tableRange: String?
    let error: SheetError?
    
    enum CodingKeys: String, CodingKey {
        case updates
        case spreadsheetID = "spreadsheetId"
        case tableRange , error
    }
}

struct Updates: Codable {
    let spreadsheetID: String?
    let updatedRows, updatedCells, updatedColumns: Int?
    let updatedRange: String?

    enum CodingKeys: String, CodingKey {
        case spreadsheetID = "spreadsheetId"
        case updatedRows, updatedCells, updatedColumns, updatedRange
    }
}


struct SheetError: Codable {
    let code: Int?
    let message, status: String?
}
