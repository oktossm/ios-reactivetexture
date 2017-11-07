//
// Created by Mikhail Mulyar on 02/09/16.
// Copyright (c) 2016 Mikhail Mulyar. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import AsyncDisplayKit


extension Reactive where Base: ASButtonNode {
    /// Sets the title of the button for its normal state.
    public var attributedTitle: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.setAttributedTitle($1, for: .normal) }
    }

    /// Sets the title of the button for the specified state.
    public func attributedTitle(for state: UIControlState) -> BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.setAttributedTitle($1, for: state) }
    }

    /// Sets the image of the button for the specified state.
    public func image(for state: UIControlState) -> BindingTarget<UIImage?> {
        return makeBindingTarget { $0.setImage($1, for: state) }
    }

    public var image: BindingTarget<UIImage?> {
        return image(for: .normal)
    }
}
