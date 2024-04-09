//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Foundation
import Combine

struct KeyboardInfo {
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
}

// MARK: - DiaryViewModel

class DiaryViewModel: ViewModel {
    struct Input {
        var textDidChangeSubject: CurrentValueSubject<String?, Never>
        var viewTypeSubject: CurrentValueSubject<DiaryViewType?, Never>
    }
    
    struct Output {
        let textValidationAction: AnyPublisher<Bool, Never>
    }
    
    private (set) var model: DiaryModel
    
    private var textValidationState = PassthroughSubject<Bool, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var diaryTextSubject = CurrentValueSubject<String?, Never>(nil)
    private (set) var topicContentSubject = CurrentValueSubject<String?, Never>(nil)
    private (set) var keyboardInfo: Observable<KeyboardInfo?> = Observable(nil)
    private (set) var toastType: Observable<ToastViewType?> = Observable(nil)
    
    // TODO: 꼭 필요한가?
//    private var toastMessageFlag: Bool = false
    
    private var diaryText: String? = nil
    
    var onError: ((Error) -> Void)?
    
    init(model: DiaryModel) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        input.textDidChangeSubject
            .sink { [weak self] text in
                guard let viewType = input.viewTypeSubject.value,
                      let isValid = self?.validateText(with: text ?? "", viewType: viewType)
                else { return }
                
                self?.textValidationState.send(isValid)
                self?.diaryTextSubject.send(text)
                self?.diaryText = text
            }
            .store(in: &cancelBag)
        
        let diaryTextAction = textValidationState.eraseToAnyPublisher()
        
        return Output(textValidationAction: diaryTextAction)
    }
}

// MARK: - Extensions

extension DiaryViewModel {
    func toggleRandomTopic() {
        isRandomTopicActive.value = !isRandomTopicActive.value
    }
    
    func getTopicID() -> Int? {
        return model.topicID ?? nil
    }
    
    func updateKeyboardInfo(info: KeyboardInfo) {
        keyboardInfo.value = info
    }
    
    func setToastViewType(_ type: ToastViewType) {
        toastType.value = type
    }
    
    func updateTopicStatus(isTopicCalled: Bool, topicContent: String?) {
        model.isTopicCalled = isTopicCalled
        model.topicContent = topicContent
    }
    
    func updateDiaryInfo(diaryID: Int, badgePopupContent: [PopupBadge]) {
        model.diaryID = diaryID
        model.badgePopupContent = badgePopupContent
    }
    
    func updateTopicID(topicID: Int?) {
        model.topicID = topicID
    }
    
    func getDiaryText() -> String? {
        return diaryText
    }
}

// MARK: - Action Helpers

extension DiaryViewModel {
    func validateText(with text: String, viewType: DiaryViewType) -> Bool {
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
    
    func showRegExToast() {
        setToastViewType(.smeemToast(bodyType: .regEx))
    }
    
    func showRegExKrToast() {
        setToastViewType(.smeemToast(bodyType: .regExKr))
    }
}

// MARK: - Network

extension DiaryViewModel {
    func callRandomTopicAPI() {
        RandomTopicAPI.shared.getRandomSubject { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.model.topicID = response.topicId
                self?.model.topicContent = response.content
                self?.topicContentSubject.value = response.content
                
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
