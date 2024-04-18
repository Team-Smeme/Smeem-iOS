//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Foundation
import Combine

// MARK: - DiaryViewModel

class DiaryViewModel: ViewModel {
    struct Input {
        let textDidChangeSubject: CurrentValueSubject<String?, Never>
        let viewTypeSubject: CurrentValueSubject<DiaryViewType?, Never>
    }
    
    struct Output {
        let textValidationResult: AnyPublisher<Bool, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
    }
    
    // MARK: - Subjects
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var topicContentSubject = CurrentValueSubject<String?, Never>(nil)
    private (set) var textValidationState = CurrentValueSubject<Bool, Never>(false)
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // TODO: 꼭 필요한가?
    //    private var toastMessageFlag: Bool = false
    
    private var diaryText: String? = nil
    
    private (set) var model: DiaryModel
    
    // MARK: - Life Cycle
    
    init(model: DiaryModel) {
        self.model = model
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.textDidChangeSubject
            .sink { [weak self] text in
                guard let viewType = input.viewTypeSubject.value,
                      let isValid = self?.validateText(with: text ?? "", viewType: viewType)
                else { return }
                
                self?.textValidationState.send(isValid)
                self?.diaryText = text
            }
            .store(in: &cancelBag)
        
        let diaryTextAction = textValidationState.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        
        return Output(textValidationResult: diaryTextAction,
                      errorResult: errorResult)
    }
}

// MARK: - Private Helpers

extension DiaryViewModel {
    private func validateText(with text: String, viewType: DiaryViewType) -> Bool {
        let smeemTextViewHandler = SmeemTextViewHandler()
        
        let placeholderText = smeemTextViewHandler.placeholderTextForViewType(for: viewType)
        
        if text == placeholderText {
            return false
        } else {
            switch viewType {
            case .foregin, .stepTwoKorean, .edit:
                return smeemTextViewHandler.containsEnglishCharacters(with: text)
            case .stepOneKorean:
                return smeemTextViewHandler.containsKoreanCharacters(with: text)
            }
        }
    }
}

// MARK: - Internal Helpers

extension DiaryViewModel {
    func getTopicID() -> Int? {
        return model.topicID ?? nil
    }
    
    func getDiaryText() -> String? {
        return diaryText
    }
    
    func updateTopicID(to id: Int?) {
        model.topicID = id
    }
    
    func updateTopicStatus(isTopicCalled: Bool, topicContent: String?) {
        model.isTopicCalled = isTopicCalled
        model.topicContent = topicContent
    }
    
    func updateDiaryInfo(diaryID: Int, badgePopupContent: [PopupBadge]) {
        model.diaryID = diaryID
        model.badgePopupContent = badgePopupContent
    }
    
    func sendError(_ error: SmeemError) {
        errorResult.send(error)
    }
}

// MARK: - Network

extension DiaryViewModel {
    func callRandomTopicAPI(_ completion: @escaping () -> Void) {
        RandomTopicAPI.shared.getRandomSubject { [weak self] result in
            switch result {
            case .success(let response):
                self?.model.topicID = response.topicId
                self?.model.topicContent = response.content
                self?.topicContentSubject.value = response.content
                SharedDiaryDataService.shared.topicID = self?.model.topicID
                completion()
                
            case .failure(let error):
                self?.errorResult.send(error)
                completion()
            }
        }
    }
}
