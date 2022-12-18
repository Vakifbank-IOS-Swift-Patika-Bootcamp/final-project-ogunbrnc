//
//  DateExtension.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 17.12.2022.
//

import Foundation
extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: self)
    }
}
