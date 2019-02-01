//
//  SuperStarNamingAnimation.swift
//  MjAnimationFramework
//
//  Created by Madhan Raj on 2/1/19.
//  Copyright © 2019 MS. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func copyLabel() -> UILabel {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UILabel
    }
}

public class SuperStarNamingAnimation {
    
    var objWindow:UIWindow
    var textToAnimate:String = "MADHAN"
    var arrayAnimationChar:[Character] = []
    var lblCaption: UILabel!
    var vcObj: UIViewController
    var strIdentifier: String = ""
    var stbdObj: UIStoryboard
    
    public init(currentWindowObj:UIWindow, currentStoryboardObj: UIStoryboard, endUpViewCtrlObj:UIViewController, endUpViewCtrlStoryboardIdentifier:String, animateString: String) {
        objWindow = currentWindowObj
        stbdObj = currentStoryboardObj
        vcObj = endUpViewCtrlObj
        strIdentifier = endUpViewCtrlStoryboardIdentifier
        textToAnimate = animateString
    }
    
    public func beginAnimation() {
        convertStringIntoArray(animationText: textToAnimate)
        doAnimate(animationChar: arrayAnimationChar[0], charIndex: 0)
    }

    func convertStringIntoArray(animationText str:String) {
        arrayAnimationChar = []
        let index = str.index(str.startIndex, offsetBy: 0)
        let endIndex = str.index(str.endIndex, offsetBy:0)
        for cha in str[index ..< endIndex] {
            arrayAnimationChar.append(cha)
        }
    }

    func addAnimationLabel(text:Character) {
        
        lblCaption = UILabel.init(frame: CGRect(x: 0, y: 0, width: (objWindow.bounds.width), height: (objWindow.bounds.height)))
        lblCaption.textAlignment = .center
        lblCaption.textColor = UIColor.white
        lblCaption.font = UIFont.boldSystemFont(ofSize: 999.0)
        lblCaption.text = String(text)
        objWindow.addSubview(lblCaption)
    }

    func doAnimate(animationChar cha:Character, charIndex:Int) {
        addAnimationLabel(text: cha)
        
        let lblCopy = lblCaption.copyLabel()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.lblCaption.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { done in
            
            self.lblCaption.font = UIFont.boldSystemFont(ofSize: 80.0)
            self.lblCaption.transform = .identity
            self.lblCaption.bounds = lblCopy.bounds
            
            let nextIndex = charIndex + 1
            if(nextIndex != self.arrayAnimationChar.count) {
                self.lblCaption.removeFromSuperview()
                self.doAnimate(animationChar: self.arrayAnimationChar[nextIndex], charIndex: nextIndex)
            }
            else {
                
                let vcObj = self.stbdObj.instantiateViewController(withIdentifier: self.strIdentifier)
                self.objWindow.rootViewController = vcObj
                
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: UIView.AnimationOptions.curveEaseIn,
                               animations: {
                                self.objWindow.rootViewController!.view.transform = .identity
                },completion: nil)
            }
        })
    }
}
