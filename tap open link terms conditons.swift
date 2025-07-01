// MARK: custom class to open links

class LinkTextView: UITextView, UITextViewDelegate {
    typealias Links = [String: String]
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false
        delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func addLinks(_ links: Links) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        attributedText = mText
    }
    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}



// MARK: vc action

//Create text view and change class to LinkTextView
//Make its outlet as LinkTextView

        //super.viewDidLoad()
        txtViewLink.delegate = self
        let tu = "Terms and Conditions"
        let pp = "Privacy Policy"
        txtViewLink.addLinks([
            tu: "Terms",
            pp: "Privacy"
        ])
        self.txtViewLink.linkTextAttributes = [
            .foregroundColor: UIColor.red,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        txtViewLink.isEditable = false


extension TapableLinksViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "Terms" {
            print("Termmssss")
        } else {
            print("privacyyyyyy")
        }
        return false
    }
}
    
// open link if wanted
    fileprivate func openLinks() {
        let actionURL = "https://www.hackingwithswift.com"
        if let url = URL(string: "\(actionURL)") {
            UIApplication.shared.open(url)
        }
    }

    

