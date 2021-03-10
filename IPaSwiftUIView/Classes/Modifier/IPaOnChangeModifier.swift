//
//  IPaOnChangeModifier.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/31.
//

import SwiftUI

@available(
  iOS, introduced: 13, deprecated: 14,
  message: "Use onChange for iOS 14 directly"
)
/// See `View.onChange(of: value, perform: action)` for more information
struct ChangeObserver<Base: View, Value: Equatable>: View {
    let base: Base
    let value: Value
    let action: (Value)->Void

    let model = Model()

    var body: some View {
        if model.update(value: value) {
            DispatchQueue.main.async { self.action(self.value) }
        }
        return base
    }

    class Model {
        private var savedValue: Value?
        func update(value: Value) -> Bool {
            guard value != savedValue else { return false }
            savedValue = value
            return true
        }
    }
}
@available(
  iOS, introduced: 13, deprecated: 14,
  message: "Use onChange for iOS 14 directly"
)
extension View {
    /// Adds a modifier for this view that fires an action when a specific value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a value changing, such as an Environment key or a Binding.
    ///
    /// `onChange` is called on the main thread. Avoid performing long-running tasks on the main thread. If you need to perform a long-running task in response to value changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure. The previous value may be captured by the closure to compare it to the new value. For example, in the following code example, PlayerView passes both the old and new values to the model.
    ///
    /// ```
    /// struct PlayerView : View {
    ///   var episode: Episode
    ///   @State private var playState: PlayState
    ///
    ///   var body: some View {
    ///     VStack {
    ///       Text(episode.title)
    ///       Text(episode.showTitle)
    ///       PlayButton(playState: $playState)
    ///     }
    ///   }
    ///   .onChange(of: playState) { [playState] newState in
    ///     model.playStateDidChange(from: playState, to: newState)
    ///   }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that failed the comparison check.
    /// - Returns: A modified version of this view
    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (_ newValue: Value)->Void) -> ChangeObserver<Self, Value> {
        ChangeObserver(base: self, value: value, action: action)
    }
}
