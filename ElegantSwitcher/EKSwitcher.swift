//
//  EKSwitcher.swift
//  ElegantSwitcher
//
//  Created by Emil Karimov on 05.06.2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

protocol EKSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: EKSwitcher, value: Bool)
}

class EKSwitcher: UIView {
    
    var button: UIButton!
    var buttonLeftConstraint: NSLayoutConstraint!
    var delegate: EKSwitcherChangeValueDelegate?
    
    var on: Bool = false
    var originalImage: UIImage?
    var selectedImage: UIImage?
    var selectedColor: UIColor
    var originalColor: UIColor
    
    var animateDuration: TimeInterval
    
    private var offCenterPosition: CGFloat!
    private var onCenterPosition: CGFloat!
    
    init(frame: CGRect = CGRect(x: 0, y: 0, width: 51, height: 31), animateDuration: TimeInterval = 0.4, selectedColor: UIColor = .green, deselectedColor: UIColor = .white) {
        
        self.selectedColor = selectedColor
        self.originalColor = deselectedColor
        self.animateDuration = animateDuration
        
        super.init(frame: frame)
        commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        button = UIButton(type: .custom)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControlEvents.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        offCenterPosition = self.bounds.height * 0.1
        onCenterPosition = self.bounds.width - (self.bounds.height * 0.9)
        
        if on == true {
            self.button.backgroundColor = selectedColor
        } else {
            self.button.backgroundColor = originalColor
        }
        
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        initLayout()
        animationSwitcherButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private func initLayout() {
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLeftConstraint = button.leftAnchor.constraint(equalTo: self.leftAnchor)
        buttonLeftConstraint.isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setImages(onImage: String, offImage: String) {
        button.setImage(UIImage(named: offImage), for: .normal)
        button.setImage(UIImage(named: onImage), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        selectedColor = .green
        originalColor = .gray
        animateDuration = 0.4
        super.init(coder: aDecoder)
    }
    
    @objc func switcherButtonTouch(_ sender: AnyObject) {
        on = !on
        animationSwitcherButton()
        delegate?.switcherDidChangeValue(switcher: self, value: on)
    }
    
    func animationSwitcherButton() {
        if on == true {
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = -CGFloat(Double.pi)
            rotateAnimation.toValue = 0.0
            rotateAnimation.duration = 0.45
            rotateAnimation.isCumulative = false
            self.button.layer.add(rotateAnimation, forKey: "rotate")
            
            
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = self.on
                self.buttonLeftConstraint.constant = self.onCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.selectedColor
                
                self.button.layer.shadowOffset = CGSize(width: 0, height: 0.2)
                self.button.layer.shadowOpacity = 0.3
                self.button.layer.shadowRadius = self.offCenterPosition
                self.button.layer.cornerRadius = self.button.frame.height / 2
                self.button.layer.shadowPath = UIBezierPath(roundedRect: self.button.layer.bounds, cornerRadius: self.button.frame.height / 2).cgPath
                
                self.backgroundColor = self.selectedColor
            }, completion: { (finish: Bool) -> Void in
                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.clear.cgColor
            })
        } else {
            
            self.button.layer.shadowOffset = CGSize.zero
            self.button.layer.shadowOpacity = 0
            self.button.layer.shadowRadius = self.button.frame.height / 2
            self.button.layer.cornerRadius = self.button.frame.height / 2
            self.button.layer.shadowPath = nil
            
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = -CGFloat(Double.pi)
            rotateAnimation.duration = 0.45
            rotateAnimation.isCumulative = false
            self.button.layer.add(rotateAnimation, forKey: "rotate")
            
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = self.on
                self.buttonLeftConstraint.constant = self.offCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.originalColor
                
                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.backgroundColor = .white
            }, completion: { (finish: Bool) -> Void in })
        }
    }
}

