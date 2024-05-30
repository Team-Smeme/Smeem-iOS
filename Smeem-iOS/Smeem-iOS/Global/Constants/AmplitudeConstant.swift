//
//  AmplitudeConstant.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/15.
//

import Foundation
import AmplitudeSwift

struct AmplitudeManager {
    static let shared = Amplitude(configuration: Configuration(apiKey: ConfigConstant.amplitudeAppKey))
}

enum AmplitudeConstant {
    
    enum Onboarding {
        case first_view
        case onboarding_goal_view
        case onboarding_plan_view
        case onboarding_alarm_view
        case onboarding_later_click
        case signup_success
        case welcome_quit_click
        case welcome_more_click
        
        var event: BaseEvent {
            switch self {
            case .first_view:
                return BaseEvent(eventType: "first_view", eventProperties: nil)
            case .onboarding_goal_view:
                return BaseEvent(eventType: "onboarding_goal_view", eventProperties: nil)
            case .onboarding_plan_view:
                return BaseEvent(eventType: "onboarding_plan_view", eventProperties: nil)
            case .onboarding_alarm_view:
                return BaseEvent(eventType: "onboarding_alarm_view", eventProperties: nil)
            case .onboarding_later_click:
                return BaseEvent(eventType: "onboarding_later_click", eventProperties: nil)
            case .signup_success:
                return BaseEvent(eventType: "signup_success", eventProperties: nil)
            case .welcome_quit_click:
                return BaseEvent(eventType: "welcome_quit_click", eventProperties: nil)
            case .welcome_more_click:
                return BaseEvent(eventType: "welcome_more_click", eventProperties: nil)
            }
        }
        
    }
    
    enum home {
        case home_view
        case full_calendar_appear
        
        var event: BaseEvent {
            switch self {
            case .home_view:
                return BaseEvent(eventType: "home_view", eventProperties: nil)
            case .full_calendar_appear:
                return BaseEvent(eventType: "full_calendar_appear", eventProperties: nil)
                
            }
        }
    }
    
    enum diary {
        case for_writing_click
        case kor_writing_click
        case first_step_complete
        case sec_step_complete
        case diary_complete
        case hint_click
        
        var event: BaseEvent {
            switch self {
            case .for_writing_click:
                return BaseEvent(eventType: "for_writing_click", eventProperties: nil)
            case .kor_writing_click:
                return BaseEvent(eventType: "kor_writing_click", eventProperties: nil)
            case .first_step_complete:
                return BaseEvent(eventType: "first_step_complete", eventProperties: nil)
            case .sec_step_complete:
                return BaseEvent(eventType: "sec_step_complete", eventProperties: nil)
            case .diary_complete:
                return BaseEvent(eventType: "diary_complete", eventProperties: nil)
            case .hint_click:
                return BaseEvent(eventType: "hint_click", eventProperties: nil)
            }
        }
    }
    
    enum badge {
        case welcome_quit_click
        case welcome_more_click
        case badge_more_click(String)
        case tenth_badge_click
        
        var event: BaseEvent {
            switch self {
            case .welcome_quit_click:
                return BaseEvent(eventType: "welcome_quit_click", eventProperties: ["BadgeType":"EVENT"])
            case .welcome_more_click:
                return BaseEvent(eventType: "welcome_more_click", eventProperties: ["BadgeType":"EVENT"])
            case .badge_more_click(let type):
                return BaseEvent(eventType: "badge_more_click", eventProperties: ["BadgeType":type])
            case .tenth_badge_click:
                return BaseEvent(eventType: "tenth_badge_click", eventProperties: nil)
            }
        }
    }
    
    enum diaryDetail {
        case mydiary_click
        case mydiary_edit
        
        var event: BaseEvent {
            switch self {
            case .mydiary_click:
                return BaseEvent(eventType: "mydiary_click", eventProperties: nil)
            case .mydiary_edit:
                return BaseEvent(eventType: "mydiary_edit", eventProperties: nil)
            }
        }
    }
    
    enum myPage {
        case mypage_view
        
        var event: BaseEvent {
            return BaseEvent(eventType: "mypage_view", eventProperties: nil)
        }
    }
    
    enum summary {
        case achievement_view
        case badge_bottom_sheet_view(String, Bool)
        
        var event: BaseEvent {
            switch self {
            case .achievement_view:
                return BaseEvent(eventType: "achievement_view", eventProperties: nil)
            case .badge_bottom_sheet_view(let type, let hasBadge):
                return BaseEvent(eventType: "badge_bottom_sheet_view", eventProperties: ["BadgeType":type,
                                                                                         "hasBadge":hasBadge])
            }
        }
    }
}
