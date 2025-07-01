func showActions() {
    UIControl.swizzleButtonActions()
}
extension UIControl {
    
    private static let swizzleSendAction: Void = {
        guard let original = class_getInstanceMethod(UIControl.self, #selector(sendAction(_:to:for:))),
              let swizzled = class_getInstanceMethod(UIControl.self, #selector(swizzled_sendAction(_:to:for:))) else { return }
        method_exchangeImplementations(original, swizzled)
    }()
    
    @objc private func swizzled_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if self is UIButton {
            print("~~ Button action: \(action) on \((target as? NSObject).map { NSStringFromClass(type(of: $0)).components(separatedBy: ".").last ?? "" } ?? "Unknown")")
        }
        swizzled_sendAction(action, to: target, for: event)
    }
    
    static func swizzleButtonActions() {
        _ = swizzleSendAction
    }
}
