//
// Created by Mikhail Mulyar on 27/11/2016.
// Copyright (c) 2016 Mikhail Mulyar. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import AsyncDisplayKit
import enum Result.NoError


extension Reactive where Base: ASEditableTextNode {
    /// Sets the attributed text of the node.
    public var attributedText: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.attributedText = $1 }
    }

    /// Sets the attributed placeholder text of the node.
    public var attributedPlaceholderText: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.attributedPlaceholderText = $1 }
    }

    /// A signal of text values emitted by the text node upon end of editing.
    ///
    /// - note: To observe text values that change on all editing events,
    ///   see `continuousTextValues`.
    public var textValues: Signal<String?, NoError> {
        return base.textView.reactive.textValues
    }

    /// A signal of text values emitted by the text node upon any changes.
    ///
    /// - note: To observe text values only when editing ends, see `textValues`.
    public var continuousTextValues: Signal<String?, NoError> {
        return base.textView.reactive.continuousTextValues
    }

    /// The current associated observer of `self`
    internal var associatedObserver: ASEditableTextNodeObserver {
        return associatedValue { _ in ASEditableTextNodeObserver() }
    }

    /// A signal of events sent when text node becomes first responder.
    public var firstResponderSignal: Signal<Bool, NoError> {
        let begin = NotificationCenter.default
                .reactive
                .notifications(forName: .UITextViewTextDidBeginEditing, object: base.textView)
                .take(during: lifetime)
                .map { _ in true }

        let end = NotificationCenter.default
                .reactive
                .notifications(forName: .UITextViewTextDidEndEditing, object: base.textView)
                .take(during: lifetime)
                .map { _ in false }
        return Signal.merge([begin, end])
    }

    /// A signal of events sent when return key tapped on keyboard.
    ///
    /// - note: ASEditableTextNode delegate will be overridden, old delegate
    ///   will be saved as weak var.
    public var returnKeySignal: Signal<Void, NoError> {
        return Signal {
            [weak base] observer, signalLifetime in

            let o = self.associatedObserver

            let disposable = CompositeDisposable()
            if let base = base {
                disposable += o.returnKeySignal(for: base).observeValues { observer.send(value: ()) }
            }

            disposable += self.lifetime.ended.observeCompleted {
                if let base = base {
                    o.revertDelegate(for: base)
                }
                observer.sendCompleted()
            }

            signalLifetime.observeEnded {
                disposable.dispose()
            }
        }
    }
}


internal final class ASEditableTextNodeObserver: NSObject, ASEditableTextNodeDelegate {

    fileprivate var returnObserver: Signal<Void, NoError>.Observer?
    fileprivate var returnSignal: Signal<Void, NoError>?

    fileprivate weak var delegate: ASEditableTextNodeDelegate?

    override init() {
        super.init()
    }

    func returnKeySignal(for textNode: ASEditableTextNode) -> Signal<Void, NoError> {

        if let signal = self.returnSignal {
            return signal
        }

        self.saveDelegate(for: textNode)

        let (signal, observer) = Signal<Void, NoError>.pipe()

        returnSignal = signal
        returnObserver = observer

        return signal
    }

    func saveDelegate(for textNode: ASEditableTextNode) {
        if textNode.delegate !== self {
            self.delegate = textNode.delegate
        }

        textNode.delegate = self
    }

    func revertDelegate(for textNode: ASEditableTextNode) {
        if self.delegate != nil {
            textNode.delegate = self.delegate
        } else if textNode.delegate === self {
            textNode.delegate = nil
        }
    }

    // MARK: Delegate

    func editableTextNodeDidBeginEditing(_ editableTextNode: ASEditableTextNode) {
        self.delegate?.editableTextNodeDidBeginEditing?(editableTextNode)
    }

    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let result = text.rangeOfCharacter(from: CharacterSet.newlines, options: [.backwards])

        if let observer = self.returnObserver, text.count == 1, let r = result, !r.isEmpty {
            observer.send(value: ())
            return false
        }

        return self.delegate?.editableTextNode?(editableTextNode, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    func editableTextNodeDidChangeSelection(_ editableTextNode: ASEditableTextNode,
                                            fromSelectedRange: NSRange,
                                            toSelectedRange: NSRange,
                                            dueToEditing: Bool) {

        self.delegate?.editableTextNodeDidChangeSelection?(editableTextNode,
                                                           fromSelectedRange: fromSelectedRange,
                                                           toSelectedRange: toSelectedRange,
                                                           dueToEditing: dueToEditing)
    }

    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        self.delegate?.editableTextNodeDidUpdateText?(editableTextNode)
    }

    func editableTextNodeDidFinishEditing(_ editableTextNode: ASEditableTextNode) {
        self.delegate?.editableTextNodeDidFinishEditing?(editableTextNode)
    }
}
