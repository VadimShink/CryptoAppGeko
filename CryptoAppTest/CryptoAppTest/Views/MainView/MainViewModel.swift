//
//  MainViewModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    let action: PassthroughSubject<Action, Never> = .init()
    
    let screenData: CurrentValueSubject<[CoinModel], Never> = .init([])
    
    @Published var coinList: [CoinRowViewModel] = []
    
    @Published var link: Link? { didSet { isLinkActive = link != nil } }
    @Published var isLinkActive: Bool = false
    
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 1
    private var bindings = Set<AnyCancellable>()
    private let model: Model
    
    init(model: Model) {
        self.model = model
        
        Task {
            await loadScreenData()
        }
        
        bind()
    }
    
    private func bind() {
        screenData
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] screenData in
                
                guard screenData.isEmpty == false else { return }
                
                self.coinList = createCoinList(from: screenData)
            }
            .store(in: &bindings)
        
        action
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] action in
                
                switch action {
                        
                    case let payload as MainViewModelAction.OpenDetail:
                        
                        self.link = .detailView(MainDetailViewModel(model: model, detailModel: payload.detailModel, closeAction: { [weak self] in
                            self?.link = nil
                        }))
                        
                    default:
                        break
                }
            }
            .store(in: &bindings)
    }
    
    /// Создает список `CoinRowViewModel` на основе моделей валют.
    ///
    /// Функция принимает в качестве входного параметра массив моделей валют `model`.
    /// Создается пустой массив `coinList`, который будет содержать объекты `CoinRowViewModel`.
    /// Затем происходит маппинг моделей валют на `CoinRowViewModel` с использованием метода `map`.
    /// Каждая модель валюты `coin` преобразуется в `CoinRowViewModel` с помощью инициализатора `CoinRowViewModel(coin:closure:)`.
    /// Внутри замыкания `closure` выполняется отправка действия `MainViewModelAction.OpenDetail`, передавая идентификатор валюты.
    ///
    /// Возвращается массив `coinList`, содержащий созданные `CoinRowViewModel`.
    ///
    /// - Parameter model: Массив моделей валют.
    /// - Returns: Массив `CoinRowViewModel` на основе моделей валют.
    func createCoinList(from model: [CoinModel]) -> [CoinRowViewModel] {
        var coinList: [CoinRowViewModel] = []
        
        coinList = model.map { CoinRowViewModel(coin: $0) { [weak self] coinID in
            guard let detailModel = model.first(where: { $0.id == coinID }) else { return }
            self?.action.send(MainViewModelAction.OpenDetail(detailModel: detailModel))
        }}
        
        return coinList
    }
    
    func loadScreenData() async {
        
        do {
            self.screenData.value = try await model.handleCoinModelGetListRequest(page: currentPage)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Загружает дополнительное содержимое при достижении конца списка валют.
    ///
    /// Функция проверяет, является ли переданная валюта `coin` последней в списке `screenData.value`.
    /// Если это так, и при этом нет активной загрузки данных (`isLoading == false`), то функция выполняет следующие действия:
    ///   - Устанавливает флаг `isLoading` в значение `true`, чтобы избежать параллельных загрузок.
    ///   - Асинхронно вызывает функцию `getMoreCoin(page:)` для получения дополнительных данных о валюте со следующей страницы.
    ///   - Увеличивает значение `currentPage` на 1, чтобы указать текущую страницу загрузки.
    ///
    /// - Parameter coin: Объект типа `CoinRowViewModel`, представляющий текущую валюту.
    func loadMoreContent(currentCoin coin: CoinRowViewModel) {
        let thresholdIndex = screenData.value.index(screenData.value.endIndex, offsetBy: -1)
        let currentIndex = screenData.value.firstIndex(where: { $0.id == coin.id })
        
        if thresholdIndex == currentIndex, isLoading == false {
            self.isLoading = true
            
            Task {
                await getMoreCoin(page: currentPage + 1)
                self.currentPage += 1
            }
        }
    }
    
    /// Получает дополнительные данные о валютах с указанной страницы и добавляет их в список `screenData.value`.
    ///
    /// Функция асинхронно вызывает функцию `handleCoinModelGetListRequest(page:)` модели, передавая ей номер страницы `page`.
    /// Результат, содержащий новые данные о валютах, сохраняется в переменной `newCoins`.
    /// Затем новые данные добавляются в конец списка `screenData.value` с помощью метода `append(contentsOf:)`.
    ///
    /// В конце, при помощи `await MainActor.run`, устанавливается флаг `isLoading` в значение `false`,
    /// что сигнализирует о завершении загрузки данных.
    ///
    /// Если происходит ошибка во время выполнения запроса, сообщение об ошибке выводится в консоль.
    ///
    /// - Parameter page: Номер страницы для загрузки дополнительных данных о валютах.
    func getMoreCoin(page: Int) async {
        do {
            let newCoins = try await model.handleCoinModelGetListRequest(page: page)
            screenData.value.append(contentsOf: newCoins)
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum Link {
        case detailView(MainDetailViewModel)
    }
    
    //MARK: - MainViewModelAction
    enum MainViewModelAction {
        
        struct OpenDetail: Action {
            let detailModel: CoinModel
        }
    }
}
