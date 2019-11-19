//
//  MyLib.swift
//  StundenApp
//
//  Created by Serz on 14.11.2019.
//  Copyright © 2019 Serz. All rights reserved.
//



import Foundation
import UIKit
import SystemConfiguration


var RK_X: CGFloat = UIScreen.main.bounds.width/CGFloat(375.0)
var USER_DATA = NSMutableDictionary()
var FIREBASE_TOKEN: String = ""

//===================
// SAVE TO KEYCHAIN
//===================
func saveKeychain(itemKey: String, dataValue: Data) {
    
    deleteKeychain(itemKey: itemKey)
    
    let queryAdd: [String: AnyObject] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: itemKey as AnyObject,
        kSecValueData as String: dataValue as AnyObject,
        kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
    ]
    
    let resultCode = SecItemAdd(queryAdd as CFDictionary, nil)
    
    if resultCode != noErr {
        print("🐝🐝🐝🐝🐝🐝🐝🐝🐝 Error saving to Keychain: \(resultCode).")
    }
}

//======================
// DELETE FROM KEYCHAIN
//======================
func deleteKeychain(itemKey: String) {
    let queryDelete: [String: AnyObject] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: itemKey as AnyObject
    ]
    
    _ = SecItemDelete(queryDelete as CFDictionary)
    
}


//====================
// READ FROM KEYCHAIN
//====================
func readKeychain(itemKey: String)->Data {
    let queryRead: [String: AnyObject] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: itemKey as AnyObject,
        //kSecAttrKeySizeInBits as String: 512 as AnyObject,
        kSecReturnData as String: true as AnyObject
    ]
    var result: AnyObject?
    let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(queryRead as [String : AnyObject] as CFDictionary, UnsafeMutablePointer($0)) }
    // let status = SecItemCopyMatching(queryRead as CFDictionary, &result)
    var resData = Data()
    if status == noErr, let data = result as? Data {
        resData = data
    }
    return resData
}



//===================
// CREATE IMAGE VIEW
//===================

func createImageView(_ parent: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat,  image: UIImage, action: Selector? = nil, contentMode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit, borderWidth: CGFloat = 0, borderRadius: CGFloat = 0, borderColor: UIColor = UIColor.clear, alpha: CGFloat = 1.0, shadowColor: UIColor = UIColor.lightGray, xShadow: CGFloat = 0, yShadow: CGFloat = 0, shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 0, tag: Int = 0) -> UIImageView{
    
    
    let imageView: UIImageView = UIImageView()
    imageView.alpha = alpha
    imageView.tag = tag
    imageView.frame = CGRect(x: x, y: y, width: width, height: height)
    imageView.contentMode = contentMode
    imageView.image = image
    
    
    if (borderWidth != 0 || borderRadius != 0){
        imageView.layer.borderWidth = borderWidth;
        imageView.layer.cornerRadius = borderRadius;
        imageView.layer.borderColor = borderColor.cgColor;
        imageView.clipsToBounds = true
    }
    
    
    if (xShadow != 0 || yShadow != 0){
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = false
        if shadowColor != UIColor.white{
            imageView.layer.shadowColor  = shadowColor.cgColor
        }
        imageView.layer.shadowOffset = CGSize(width: xShadow, height: yShadow)
        if (shadowRadius != 0){
            imageView.layer.shadowRadius  = shadowRadius
        } else {
            imageView.layer.shadowRadius  = yShadow
        }
        
        imageView.layer.shadowOpacity = shadowOpacity
    }
    
    
    parent.addSubview(imageView)
    return imageView;
}


//===================
//  UICOLOR FROM HEX
//===================


func hexColor(_ rgbValue:UInt32, alpha: CGFloat = 1.0)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:alpha)
}

//===================
//  CREATE LABEL
//===================
func createLabel(_ vc: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat,  text: String,  font: UIFont = UIFont.systemFont(ofSize: 16), textColor: UIColor = UIColor.black, aligment: NSTextAlignment=NSTextAlignment.left,  shadowColor: UIColor = UIColor.lightGray, xShadow: CGFloat = 0, yShadow: CGFloat = 0, numberOfLines: Int=1, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping, sizeToFit: Bool = false, borderWidth: CGFloat = 0, borderRadius: CGFloat = 0, borderColor: UIColor = UIColor.clear, backgroundColor: UIColor = UIColor.clear, lineSpacing: CGFloat = 0, alpha: CGFloat = 1.0, tag: Int = 0) ->UILabel {
    
    let label = UILabel()
    label.alpha = alpha
    label.frame = CGRect(x: x, y: y, width: width, height: height)
    label.tag = tag
    label.text = text
    
    if lineSpacing != 0{
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
    }
    label.textAlignment = .center
    
    label.lineBreakMode = lineBreakMode
    label.numberOfLines = numberOfLines
    label.textAlignment = aligment
    label.backgroundColor = backgroundColor
    
    
    
    
    
    label.font = font
    label.textColor = textColor
    
    label.isOpaque = true
    if (xShadow != 0 || yShadow != 0){
        label.shadowColor = shadowColor
        label.shadowOffset = CGSize(width: xShadow, height: yShadow)
    }
    
    if (borderWidth != 0 || borderRadius != 0){
        label.layer.borderWidth = borderWidth;
        label.layer.cornerRadius = borderRadius;
        label.layer.borderColor = borderColor.cgColor;
        label.clipsToBounds = true
    }
    
    if sizeToFit { label.sizeToFit() }
    
    vc.addSubview(label);
    return label;
    
}


//===================
//  CREATE TEXTFIELD
//===================


func createTextField(_ vc: UIViewController, parent: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat,  text: String, placeholder: String = "", font: UIFont = UIFont.systemFont(ofSize: 16), textColor: UIColor = UIColor.black, aligment: NSTextAlignment=NSTextAlignment.left, backgroundColor: UIColor = UIColor.clear, keyboardType: UIKeyboardType = UIKeyboardType.default, alpha: CGFloat = 1.0, image: String = "", borderWidth: CGFloat = 0, borderRadius: CGFloat = 0, borderColor: UIColor = UIColor.clear,  numberOfLines: Int=1, padding: CGFloat = 0, tag: Int = 0) ->UITextField{
    
    let textView = UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
    if image != "" {
        textView.background = UIImage(named: image)
    }
    ///textView.placeholder = placeholder
    if placeholder != ""{
        textView.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [kCTForegroundColorAttributeName as NSAttributedString.Key: hexColor(0xa3a6ac, alpha: 1)])
    }
    textView.tag = tag;
    textView.textAlignment = aligment;
    textView.text = text;
    textView.font = font;
    
//    textView.adjustsFontSizeToFitWidth = true
//    textView.minimumFontSize = 19
    
    textView.textColor = textColor;
    textView.alpha = alpha;
    textView.isOpaque = true;
    textView.keyboardType = keyboardType
    textView.autocorrectionType = UITextAutocorrectionType.no
    
    
    
    if padding != 0{
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:padding, height:textView.frame.height))
        textView.leftView = paddingView
        textView.leftViewMode = UITextField.ViewMode.always
    }
    
    if (borderWidth != 0 || borderRadius != 0){
        textView.layer.borderWidth = borderWidth;
        textView.layer.cornerRadius = borderRadius;
        textView.layer.borderColor = borderColor.cgColor;
        textView.clipsToBounds = true
    }
    
    parent.addSubview(textView);
    return textView;
    
}


//===================
//  CREATE BUTTON
//===================

func createButton (_ vc: UIViewController, parent: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, action: Selector,  title: String = "", textColor: UIColor = UIColor.black, titleAligment: UIControl.ContentHorizontalAlignment = .center, borderWidth: CGFloat = 0, borderRadius: CGFloat = 0, borderColor: UIColor = UIColor.clear, font: UIFont = UIFont.systemFont(ofSize: 15), imageName: String = "", imageNameDisabled: String = "", imageNameHighlighted: String = "", imageNameBackground: String = "", alpha: CGFloat = 1.0,  resizeKoeff_X:CGFloat=1, lineBreakMode: NSLineBreakMode = .byWordWrapping, shadowColor: UIColor = UIColor.lightGray, xShadow: CGFloat = 0, yShadow: CGFloat = 0, shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 0, backgroundColor: UIColor = UIColor.clear,  tag: Int = 0) ->UIButton
{
    let btn = UIButton();
    let frame = CGRect(x: resizeKoeff_X*x, y: y,width: resizeKoeff_X*width, height: resizeKoeff_X*height)
    btn.frame = frame
    btn.tag = tag
    btn.alpha = alpha
    btn.backgroundColor = backgroundColor
    
    
    if (title != ""){
        btn.setTitle(title, for: UIControl.State())
    }
    
    if (imageName != "") { btn.setImage(UIImage(named: imageName), for: UIControl.State())}
    if (imageNameDisabled != "") { btn.setImage(UIImage(named: imageNameDisabled), for: .disabled)}
    if (imageNameHighlighted != "") { btn.setImage(UIImage(named: imageNameHighlighted), for: .highlighted)}
    
    
    
    btn.setTitleColor(textColor, for: UIControl.State())
    btn.contentHorizontalAlignment = titleAligment //textAlignment = titleAligment
    btn.titleLabel?.font = font
    btn.titleLabel?.lineBreakMode = lineBreakMode//NSLineBreakMode.byTruncatingTail
    if (imageNameBackground != ""){
        btn.setBackgroundImage(UIImage(named: imageNameBackground), for: UIControl.State())
    }
    
    //btn.setTitleColor(UIColor.blackColor(), forState: .Highlighted);
    
    btn.addTarget(vc, action: action, for: .touchUpInside);
    if (borderWidth != 0 || borderRadius != 0)  {
        btn.clipsToBounds = true
        btn.layer.borderWidth = borderWidth;
        btn.layer.cornerRadius = round(borderRadius*resizeKoeff_X);
        btn.layer.borderColor = borderColor.cgColor;
    }
    
    
    if (xShadow != 0 || yShadow != 0){
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        if shadowColor != UIColor.white{
            btn.layer.shadowColor  = shadowColor.cgColor
        }
        btn.layer.shadowOffset = CGSize(width: xShadow, height: yShadow)
        if (shadowRadius != 0){
            btn.layer.shadowRadius  = shadowRadius
        } else {
            btn.layer.shadowRadius  = yShadow
        }
        
        btn.layer.shadowOpacity = shadowOpacity
    }
    
    
    parent.addSubview(btn);
    return btn;
}


//=============
// CREATE VIEW
//=============

func createView(_ parent: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, backgroundColor:UIColor = UIColor.clear, alpha: CGFloat = 1.0,  borderWidth: CGFloat = 0, borderRadius: CGFloat = 0, borderColor: UIColor = UIColor.clear,  shadowColor: UIColor = UIColor.white, belowSubview: UIView! = nil, xShadow: CGFloat = 0, yShadow: CGFloat = 0, shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 0,  tag: Int = 0) -> UIView{
    
    
    let View: UIView = UIView()
    View.alpha = alpha
    View.tag = tag
    View.frame = CGRect(x: x, y: y, width: width, height: height)
    View.backgroundColor = backgroundColor
    //    if borderRadius != 0 {
    //        View.layer.cornerRadius = borderRadius
    //        View.clipsToBounds = true
    //    }
    
    if (borderWidth != 0 || borderRadius != 0){
        View.layer.borderWidth = borderWidth;
        View.layer.cornerRadius = borderRadius;
        View.layer.borderColor = borderColor.cgColor;
    }
    
    if (xShadow != 0 || yShadow != 0){
        View.layer.masksToBounds = true
        View.clipsToBounds = false
        if shadowColor != UIColor.white{
            View.layer.shadowColor  = shadowColor.cgColor
        }
        View.layer.shadowOffset = CGSize(width: xShadow, height: yShadow)
        if (shadowRadius != 0){
            View.layer.shadowRadius  = shadowRadius
        }
        
        View.layer.shadowOpacity = shadowOpacity
    }
    
    
    if belowSubview != nil{
        parent.insertSubview(View, belowSubview: belowSubview)
    } else {
        parent.addSubview(View)
    }
    return View;
}


//=============
// getImageWithColor
//=============
func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
