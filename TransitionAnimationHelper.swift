//
//  AnimationHelper.swift
//  CATransition-Example
//
//  Created by k on 20/06/25.
//  Copyright © 2025 k. All rights reserved.
//

import Foundation
import QuartzCore

struct TransitionAnimationHelper {
    enum Transition {
        enum Direction: String, CaseIterable {
            case fromLeft
            case fromRight
            case fromTop
            case fromBottom
            
            var caTransitionSubtype: CATransitionSubtype {
                switch self {
                case .fromLeft: return .fromLeft
                case .fromRight: return .fromRight
                case .fromTop: return .fromTop
                case .fromBottom: return .fromBottom
                }
            }
        }
        
        enum Timing: String {
            case linear
            case easeIn
            case easeOut
            case easeInEaseOut
            case `default`
            
            var caTimingFunction: CAMediaTimingFunctionName {
                switch self {
                case .linear: return .linear
                case .easeIn: return .easeIn
                case .easeOut: return .easeOut
                case .easeInEaseOut: return .easeInEaseOut
                case .default: return .default
                }
            }
        }
        
        enum Kind: String, CaseIterable {
            case fade
            case moveIn
            case push
            case reveal
            case oglFlip
            case cube
            case pageCurl
            case pageUnCurl
            
            // These may not work on modern iOS versions
            case rippleEffect
            case suckEffect
            case cameraIris
            
            var isSupported: Bool {
                switch self {
                case .rippleEffect, .suckEffect, .cameraIris:
                    return false // These are no longer supported
                default:
                    return true
                }
            }
            
            var caTransitionType: CATransitionType {
                switch self {
                case .fade: return .fade
                case .moveIn: return .moveIn
                case .push: return .push
                case .reveal: return .reveal
                default: return CATransitionType(rawValue: self.rawValue)
                }
            }
        }
    }
}

extension CALayer {
    func applyTransition(
        type: TransitionAnimationHelper.Transition.Kind,
        direction: TransitionAnimationHelper.Transition.Direction? = nil,
        duration: TimeInterval = 0.5,
        timingFunction: TransitionAnimationHelper.Transition.Timing = .easeInEaseOut
    ) {
        guard type.isSupported else {
            print("Transition type \(type.rawValue) is not supported on this iOS version")
            return
        }
        
        let transition = CATransition()
        transition.duration = duration
        transition.type = type.caTransitionType
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction.caTimingFunction)
        
        if let direction = direction {
            transition.subtype = direction.caTransitionSubtype
        }
        
        self.add(transition, forKey: type.rawValue)
    }
    
    // MARK: - Convenience Methods (only for supported transitions)
    
    func fadeTransition(duration: TimeInterval = 0.5) {
        applyTransition(type: .fade, duration: duration)
    }
    
    func pushFrom(direction: TransitionAnimationHelper.Transition.Direction, duration: TimeInterval = 0.5) {
        applyTransition(type: .push, direction: direction, duration: duration)
    }
    
    func cubeTransition(from direction: TransitionAnimationHelper.Transition.Direction, duration: TimeInterval = 0.5) {
        applyTransition(type: .cube, direction: direction, duration: duration)
    }
    
    func flipTransition(from direction: TransitionAnimationHelper.Transition.Direction, duration: TimeInterval = 0.5) {
        applyTransition(type: .oglFlip, direction: direction, duration: duration)
    }
}

//MARK: - usage
// refrence - https://github.com/jakechasan/CATransition-Demo
/*
 // both are same
lblCounter.layer.pushFromBottom(duration: 0.7)

lblCounter.layer.applyTransition(
    type: .push,
    direction: .fromTop,
    duration: 0.7,
    timingFunction: .easeInEaseOut
)
*/
