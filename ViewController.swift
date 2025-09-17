//
//  ViewController.swift
//  Exp_Learn_UIKIT
//
//  Created by k on 04/08/25.
//

import UIKit


// /mtr-3-minute-breakfast-kesari-halwa-8 // dots
let htmlString1 = """
<p>Wholesome & tasty halwa, ready in 3 minutes with just hot water. Savour this mouthwatering halwa and share it with your dear ones. If you are a sweet-toothed person, then this will be the right choice for you. Easy to prepare, enjoy this at your own leisure.</p>
<p>Semolina (45%), Sugar, Milk Solids, Clarified Butter (Ghee), Edible Vegetable Fat-Interesterified (Palmolein Oil, Palm Kernel Oil), Cashewnut, Raisins, Maltodextrin, Cardamom, Saffron Extract.</p>
"""

// /horlicks-health-and-nutrition-drink-classic-malt-jar-9
let htmlString2 = """
<ul style="font-size: 14px;">
    <li><span style="color: rgb(73, 73, 73); font-size: 14px;">Health Drink that has nutrients to support immunity</span></li>
    <li><span style="color: rgb(73, 73, 73); font-size: 14px;">Clinically proven to improve 5 signs of growth</span></li>
    <li><span style="color: rgb(73, 73, 73); font-size: 14px;">Scientifically proven to improve the Power of Milk</span></li>
</ul>
"""

// /magic-cellar-non-alcoholic-red-grape-wine   //dots
let htmlString3 = """
<ul style="font-size: 14px;">
    <li><span style="color: rgb(103, 103, 103); font-size: 14px;">Suitable to be enjoyed by everyone</span></li>
    <li><span style="color: rgb(103, 103, 103); font-size: 14px;">Makes your skin better</span></li>
    <li><span style="color: rgb(103, 103, 103); font-size: 14px;">For a better sleep</span></li>
    <li><span style="color: rgb(103, 103, 103); font-size: 14px;">For looking good and fresh</span></li>
</ul>
"""
class ViewController: UIViewController {

    /*
    private lazy var vm: VM = {
        
    }
    */
    
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //-=--=-=- perfect without bullets
        /*
        label.attributedText = htmlString1.htmlAttributedString(
            font: .systemFont(ofSize: 14),
            color: .darkGray,
            lineSpacing: 3,
            paragraphSpacing: 6
        )

        label2.attributedText = htmlString2.htmlAttributedString(
            font: .systemFont(ofSize: 14),
            color: .darkGray,
            lineSpacing: 3,
            paragraphSpacing: 6
        )

        label3.attributedText = htmlString3.htmlAttributedString(
            font: .systemFont(ofSize: 14),
            color: .darkGray,
            lineSpacing: 3,
            paragraphSpacing: 6
        )
        */

        let customFont2 = UIFont(name: "Roboto-Bold", size: 14) ?? UIFont.systemFont(ofSize: 10)

        
        label.attributedText = htmlString1
            .withParagraphBullets()
            .htmlAttributedString(
                font: customFont2, /* UIFont.boldSystemFont(ofSize: 16),*/
                color: .lightGray,
                lineSpacing: 3,
                paragraphSpacing: 6
            )

        label2.attributedText = htmlString2 // untouched, keeps <ul><li> bullets
            .htmlAttributedString(font: .systemFont(ofSize: 14), color: .darkGray)

        label3.attributedText = htmlString3
            .htmlAttributedString(font: .systemFont(ofSize: 14), color: .darkGray)
        
    }

    
    

}

//-=--=-=- perfect without bullets
/*
import UIKit

extension String {
    func htmlAttributedString(
        font: UIFont,
        color: UIColor,
        lineSpacing: CGFloat = 2,
        paragraphSpacing: CGFloat = 4
    ) -> NSAttributedString? {
        
        guard let data = self.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else { return nil }
        
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        // Apply your font + color
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        // Paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.paragraphSpacingBefore = 0
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        // 🔥 Trim trailing whitespace/newlines
        while attributedString.string.hasSuffix("\n") || attributedString.string.hasSuffix(" ") {
            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
        }
        
        return attributedString
    }
}
*/
import UIKit

extension String {
    /// Insert a bullet before each <p> block
    func withParagraphBullets() -> String {
        var html = self
        html = html.replacingOccurrences(of: "<p>", with: "<p>• ")
        return html
    }
    
    func htmlAttributedString(
        font: UIFont,
        color: UIColor,
        lineSpacing: CGFloat = 2,
        paragraphSpacing: CGFloat = 4
    ) -> NSAttributedString? {
        
        guard let data = self.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else { return nil }
        
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        // Apply your font + color
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        // Paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.paragraphSpacingBefore = 0
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        // Trim trailing whitespace/newlines
        while attributedString.string.hasSuffix("\n") || attributedString.string.hasSuffix(" ") {
            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
        }
        
        return attributedString
    }
}





