
import Foundation
import UIKit
import WebKit

//MARK:- UIVIEW EXTENTION

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.shadowColor!)
            return color
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
}

//MARK: - Text Filed Place Holder Color EXTENTION
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
           get {
               return self.placeHolderColor
           }
           set {
               self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
           }
       }
}

//MARK: - CLASS NAME EXTENTION

extension NSObject {
    var className: String {
        return NSStringFromClass(self as! AnyClass).components(separatedBy: ".").last ?? ""
    }
    
    public class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}


//MARK: - Storyboad
extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func authStoryboard() -> UIStoryboard {
        UIStoryboard(name: "Auth", bundle: Bundle.main)
    }
    
    
}
// MARK: color realtime dark mode and light mode
extension UIColor {
    
    // usage in vc
    //vw1.layer.borderColor = UIColor.customColor.cgColor
    
    private static let _customColor = UIColor.init(hexString: "E34040")
    static let customColor = UIColor.dynamic(light: _customColor, dark: UIColor(.brown))
    

   private static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return dark
                case .light, .unspecified:
                    return light
                @unknown default:
                    assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                    return light
                }
            })
        }
        // iOS 12 and earlier
        return light
    }
}

// MARK: hex color swiftui mac os

extension Color {
    // Initializes a SwiftUI Color from a hexadecimal string and an optional alpha (opacity) value
    init(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(alpha))
    }
}

//MARK: - HEX COLOR EXTENTION for storyboard

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MARK: - SETTING MAXIMUM LENGTH OF TEXT FIELD EXTENTION

private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

//MARK: - SETTING TEXT FIELD PADDING IB INSPACTABLE
extension UITextField {
    
    // PADDING FROM SELF
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    // PADDING FROM MAIN VIEW
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
   
}

extension UIViewController {
    
    //MARK: - TEXT FIELD VALIDATION OF DISPLAY ALERT, VALID EMAIL ID AND SPACING BETWEEN CHARACTERS
    
    func dispalyAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func modifyCreditCardString(creditCardString : String, spacingAfter: Int) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % spacingAfter == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    
    func removeTrailingZero(decimalNumber: Double) -> String {
        let decimalNumber = String(format: "%g", decimalNumber)
        return decimalNumber
    }
    
    func roundingOffDecimals (inputNumber: Double, roundingUpTo: UInt8) -> Double{
        let inputNumber = (inputNumber * pow(10, Double(roundingUpTo))).rounded()/pow(10, Double(roundingUpTo))
        return inputNumber
    }
    
    
}

//MARK: - USER DEFAULTS MODAL API
extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
