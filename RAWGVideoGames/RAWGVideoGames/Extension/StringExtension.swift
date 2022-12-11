//
//  StringExtension.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 12.12.2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self
        )
    }
}
