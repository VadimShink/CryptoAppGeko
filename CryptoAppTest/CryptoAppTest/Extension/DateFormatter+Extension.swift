//
//  DateFormatter+Extension.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 30.05.2023.
//

import Foundation

extension DateFormatter {
    
    /// Конвертирует строковое значение даты в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" в строку с форматом "dd.MM.yyyy".
    ///
    /// - Parameter string: Строковое значение даты в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'".
    ///
    /// ```
    /// convertDateFrom(string: "2023-04-02T00:00:00.000Z") -> "02.04.2023"
    /// ```
    ///
    /// - Returns: Строковое значение даты в формате "dd.MM.yyyy".
    static func convertDateFrom(string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: string) ?? Date()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    /// Конвертирует строку с датой в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" в объект типа `Date`.
    ///
    /// - Parameter string: Строка с датой в формате "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'".
    ///
    /// ```
    /// convertStringFromDate("2023-04-02T00:00:00.000Z") -> Date object representing April 2, 2023
    /// ```
    ///
    /// - Returns: Объект типа `Date`, представляющий дату.
    static func convertStringFromDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter.date(from: string) ?? Date()
    }

    
    ///Конвертирует из Date в String формат "dd.MM.yyyy"
    ///
    /// - Parameter date: Date, формат даты по умолчанию в Swift
    ///
    /// ```
    /// convertToString(from date: 2023-04-02 00:00:00 +0000) -> "02.04.2023"
    /// ```
    ///
    /// - Returns: String в формате "dd.MM.yyyy"
    static func convertToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
