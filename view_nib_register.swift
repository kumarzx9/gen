//
//  ViewController2.swift
//  new
//
//  Created by mohit on 07/04/25.
//

import UIKit

class ViewController2: UIViewController, ViewRegDelegate  {
    func didTapButton(in view: ViewReg) {
        print("got in vc")
    }
    
    
    fileprivate func registerView() {
        let customView = ViewReg()
        customView.btn.setTitle("Hello from XIB!", for: .normal)
        customView.delegate = self
        
        /*
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        let customViewWidth = viewWidth - 60 // 30pt from both sides
        let customViewHeight: CGFloat = 100
        let customViewX = CGFloat(30) // Leading 30
        let customViewY = viewHeight - customViewHeight - 30 // Bottom 30
        customView.frame = CGRect(x: customViewX, y: customViewY, width: customViewWidth, height: customViewHeight)
        self.view.addSubview(customView)
        */
        
        
        // OR
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            customView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            customView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            customView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerView()
    }

}





protocol ViewRegDelegate: AnyObject {
    func didTapButton(in view: ViewReg)
}

class ViewReg: UIView {

    @IBOutlet weak var btn: UIButton!
    weak var delegate: ViewRegDelegate?
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          commonInit()
      }

    private func commonInit() {
        let nib = UINib(nibName: "ViewReg", bundle: nil)
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    @IBAction func tap(_ sender: Any) {
        print("Button tapped inside custom view")
             delegate?.didTapButton(in: self)
    }
    
    
}
