//
//  extensions.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

extension Dictionary {

    func toJSONString() -> String? {
        do {
            let options: JSONSerialization.WritingOptions =  .prettyPrinted
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
