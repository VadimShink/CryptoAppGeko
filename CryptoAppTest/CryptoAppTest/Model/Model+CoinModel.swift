//
//  Model+CoinModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

extension Model {
    
    /// Обрабатывает запрос на получение списка моделей валют с сервера.
    ///
    /// Функция принимает в качестве входного параметра номер страницы `page`, для которой необходимо получить список моделей валют.
    /// Внутри функции записывается лог в систему логирования `LoggerAgent.shared.log`, указывая категорию "model" и сообщение "handleCoinModelGetListRequest".
    /// Затем создается команда `ServerCommands.CoinController.GetCoinModel(page:)` для получения списка моделей валют с указанной страницей.
    /// Далее вызывается метод `executeCommand(command:)` объекта `serverAgent` для выполнения команды на сервере и получения списка моделей валют.
    /// Полученные модели валют возвращаются из функции.
    ///
    /// - Parameter page: Номер страницы для получения списка моделей валют.
    /// - Returns: Массив моделей валют.
    /// - Throws: Ошибки, которые могут возникнуть при выполнении запроса.
    func handleCoinModelGetListRequest(page: Int) async throws -> [CoinModel] {
        LoggerAgent.shared.log(category: .model, message: "handleCoinModelGetListRequest")
        
        let command = ServerCommands.CoinController.GetCoinModel(page: page)
        
        return try await serverAgent.executeCommand(command: command)
    }

}
