//
// Created by Mikhail Mulyar on 02/09/16.
// Copyright (c) 2016 Mikhail Mulyar. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import AsyncDisplayKit


extension Reactive where Base: ASButtonNode {
    /// The action to be triggered when the button is pressed. It also controls
    /// the enabled state of the button.
    public var pressed: CocoaAction<Base>? {
        get {
            return associatedAction.withValue {
                info in
                return info.flatMap {
                    info in
                    return info.controlEvents == .touchUpInside ? info.action : nil
                }
            }
        }

        nonmutating set {
            setAction(newValue, for: .touchUpInside)
        }
    }

    /// Sets the title of the button for its normal state.
    public var attributedTitle: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.setAttributedTitle($1, for: []) }
    }

    /// Sets the title of the button for the specified state.
    public func attributedTitle(for state: UIControlState) -> BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.setAttributedTitle($1, for: state) }
    }
}
