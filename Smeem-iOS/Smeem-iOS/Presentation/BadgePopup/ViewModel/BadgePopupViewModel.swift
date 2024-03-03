//
//  BadgePopupViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/2/24.
//

import Foundation
import Combine

final class BadgePopupViewModel: ViewModel {
    
    var popupBadge: [PopupBadge]?
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let amplitudeSujbect: PassthroughSubject<BadgeButtonType, Never>
    }
    
    struct Output {
        let viewWillAppearResult: AnyPublisher<[PopupBadge], Never>
        let cancelButtonResult: AnyPublisher<Void, Never>
        let moreBadgeListResult: AnyPublisher<Void, Never>
        let reviewPopupResult: AnyPublisher<Void, Never>
    }
    
    private let cancelButtonSubject = PassthroughSubject<Void, Never>()
    private let moreBadgeListSubject = PassthroughSubject<Void, Never>()
    private let reviewPopupSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .map { _ -> [PopupBadge] in
                guard let popupBadge = self.popupBadge else { return PopupBadge.empty }
                if popupBadge[0].name == "열 번째 일기" { self.reviewPopupSubject.send(()) }
                return popupBadge
            }
            .eraseToAnyPublisher()
        
        input.amplitudeSujbect
            .sink { buttonType in
                guard let popupBadge = self.popupBadge else { return }
                let badgeType = popupBadge[0].type
                if buttonType == .cancel {
                    if badgeType == "EVENT" {
                        AmplitudeManager.shared.track(event: AmplitudeConstant.badge.welcome_quit_click.event)
                    }
                    self.cancelButtonSubject.send(())
                } else if buttonType == .more && badgeType == "EVENT" {
                    AmplitudeManager.shared.track(event: AmplitudeConstant.badge.welcome_more_click.event)
                    self.moreBadgeListSubject.send(())
                } else if buttonType == .more && badgeType != "EVENT" {
                    AmplitudeManager.shared.track(event: AmplitudeConstant.badge.badge_more_click(badgeType).event)
                    self.moreBadgeListSubject.send(())
                }
            }
            .store(in: &cancelBag)
        
        let cancelButtonResult = cancelButtonSubject.eraseToAnyPublisher()
        let moreBadgeListResult = moreBadgeListSubject.eraseToAnyPublisher()
        let reviewPopupResult = reviewPopupSubject.eraseToAnyPublisher()
        
        return Output(viewWillAppearResult: viewWillAppearResult,
                      cancelButtonResult: cancelButtonResult,
                      moreBadgeListResult: moreBadgeListResult,
                      reviewPopupResult: reviewPopupResult)
    }
}
