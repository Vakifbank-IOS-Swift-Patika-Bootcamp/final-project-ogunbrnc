//
//  StringExtension.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 12.12.2022.
//

import Foundation

extension String {
    func localized(tableName: String = "Localizable", bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
        NSLocalizedString(
            self,
            tableName: tableName,
            bundle: bundle,
            value: self,
            comment: comment
        )
    }
}


