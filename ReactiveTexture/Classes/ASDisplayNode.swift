//
//  ASDisplayNode.swift
//  Pods
//
//  Created by Mikhail Mulyar on 08/01/2017.
//
//

import ReactiveSwift
import ReactiveCocoa
import AsyncDisplayKit


extension Reactive where Base: ASDisplayNode {
    /// Sets the alpha value of the view.
    public var alpha: BindingTarget<CGFloat> {
        return makeBindingTarget { $0.alpha = $1 }
    }

    /// Sets whether the view is hidden.
    public var isHidden: BindingTarget<Bool> {
        return makeBindingTarget { $0.isHidden = $1 }
    }

    /// Sets whether the view accepts user interactions.
    public var isUserInteractionEnabled: BindingTarget<Bool> {
        return makeBindingTarget { $0.isUserInteractionEnabled = $1 }
    }

    /// Sets the background color of the view.
    public var backgroundColor: BindingTarget<UIColor> {
        return makeBindingTarget { $0.backgroundColor = $1 }
    }

    /// Observe interface state.
    public var interfaceState: Property<ASInterfaceState> {
        return associatedValue {
            _ in
            Property<NSNumber>(object: self.base, keyPath: "interfaceState").map { ASInterfaceState(rawValue: $0.uint8Value) }
        }
    }
}
