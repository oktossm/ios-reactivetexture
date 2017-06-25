//
// Created by Mikhail Mulyar on 16/11/2016.
// Copyright (c) 2016 Mikhail Mulyar. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import AsyncDisplayKit


extension Reactive where Base: ASTextNode {
    /// Sets the attributed text of the node.
    public var attributedText: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.attributedText = $1 }
    }
}
