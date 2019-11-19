//
//  Main.swift
//  Copyright © 2019 Serz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class Welcom: UIViewController, FUIAuthDelegate{
    
    private var welcomLbl: UILabel!
    private var overlay: UIView!
    private var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
                
        do {
            let data = readKeychain(itemKey: "USER_DATA")
            if let dic:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                USER_DATA = dic.mutableCopy() as! NSMutableDictionary
                if GIDSignIn.sharedInstance()?.hasPreviousSignIn()  == true{
                    GIDSignIn.sharedInstance()?.restorePreviousSignIn()
                } else {
                    createUI()
                }
            }
        } catch {
            createUI()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        removeOverlay()
    }
    
    func createUI(){
        
           
           _ = createImageView(self.view, x: 45*RK_X,  y: 83.5*RK_X, width: 83.5*RK_X, height: 83.5*RK_X, image: UIImage(named: "combinedShape.pdf")!, alpha: 1)
           
           
           self.welcomLbl = createLabel(self.view, x: 45*RK_X, y: 189*RK_X, width: 163.5*RK_X, height: 59.5*RK_X, text: "Welcome\nto App Name here", font: UIFont(name: "Roboto-Bold",  size: 30.2*RK_X)!, textColor: hexColor(0x292c32), aligment: .left, numberOfLines: 2, alpha: 1)
           let attributedString = NSMutableAttributedString(string: "Welcome\nto App Name here", attributes: [
               .font: UIFont(name: "Roboto-Bold", size: 22)!
               ])
           attributedString.addAttribute(.font, value: UIFont(name: "Roboto-Bold", size: 33)!, range: NSRange(location: 0, length: 7))
           self.welcomLbl.attributedText = attributedString
           
           

           _ = createLabel(self.view, x: 45*RK_X, y: 274*RK_X, width: 265*RK_X, height: 100*RK_X, text: "The site is a collection of plugins, tutorials, tips, articles, UI kits, wireframe kits, templates, icons, and many design resources", font: UIFont(name: "Roboto-Light",  size: 16.5*RK_X)!, textColor: hexColor(0x7c7c84), aligment: .left, numberOfLines: 4, lineSpacing: 6)
           
          
           
           
           let nextBtn = createButton(self, parent: self.view,  x: 46*RK_X, y: self.view.frame.height - 168*RK_X, width: self.view.frame.width-92*RK_X, height: 50*RK_X, action: #selector(self.btnTap(_:)), title: "SIGN IN VIA GOOGLE", textColor: .white, borderRadius: 6.25*RK_X, font:UIFont(name: "Roboto-Bold",  size: 17.5*RK_X)!, shadowColor: hexColor(0x188afe, alpha: 0.62), xShadow: 0, yShadow: 5*RK_X, shadowOpacity: 0.70, shadowRadius: 5*RK_X, backgroundColor: hexColor(0x188afe, alpha: 1), tag: 1)
           
           nextBtn.addTarget(self, action: #selector(self.btnDown(_:)), for: .touchDown);
           nextBtn.addTarget(self, action: #selector(self.btnUp(_:)), for: .touchUpOutside);
           nextBtn.addTarget(self, action: #selector(self.btnUp(_:)), for: .touchUpInside);

           
           
           
           let termslbl = createLabel(self.view, x: 60*RK_X, y: self.view.frame.height - 93*RK_X, width: self.view.frame.width - 130*RK_X, height: 39.5*RK_X, text: "By signin up to App name, you agree to our Terms of Use and Privacy Policy", font: UIFont(name: "Roboto-Regular",  size: 12.5*RK_X)!, textColor: hexColor(0xb9bec9), aligment: .center, numberOfLines: 2, lineSpacing: 3)

           let attributedString2 = NSMutableAttributedString(string: "By signin up to App name, you agree to our Terms of Use and Privacy Policy", attributes: [
               .font: UIFont(name: "Roboto-Regular",  size: 12.5*RK_X)!
               ])
           attributedString2.addAttribute(.underlineStyle, value: true, range: NSRange(location: 43, length: 12))
           attributedString2.addAttribute(.underlineStyle, value: true, range: NSRange(location: 60, length: 14))
           termslbl.attributedText = attributedString2
    }
    
    
    //====================
    //MARK: BUTTONS TAPS
    //====================
    @objc func btnDown(_ sender: UIButton!){
        sender.layer.shadowOpacity = 0
    }
    @objc func btnUp(_ sender: UIButton!){
        sender.layer.shadowOpacity = 0.7
    }
    
    
    @objc func btnTap(_ sender: UIButton!){
        switch sender.tag {
        // AUTH
        case 1:
            self.createOverlay()
            if GIDSignIn.sharedInstance()!.hasPreviousSignIn() == true{
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            } else {
                GIDSignIn.sharedInstance()?.presentingViewController = self
                GIDSignIn.sharedInstance().signIn()
            }
        default:
            print("undefined  id=\(sender.tag)!!!!!!!!!!")
        }
    }
    
    //==========================
    // removeOverlay
    //==========================
    func removeOverlay(){
        DispatchQueue.main.async {
            if self.activity != nil{
                self.activity.removeFromSuperview()
            }
            if self.overlay != nil{
                self.overlay.removeFromSuperview()
            }
        }
    }
    
    
    //==========================
    // createOverlay
    //==========================
    func createOverlay(){
        DispatchQueue.main.async {
            self.overlay = UIView(frame: self.view.frame)
            self.overlay.backgroundColor = UIColor.white
            self.overlay.alpha = 0.8
            self.view.addSubview(self.overlay)
            
            self.activity = UIActivityIndicatorView()
            self.activity.style = .gray
            self.activity.center = self.view.center
            self.activity.startAnimating()
            self.view.addSubview(self.activity)
        }
    }
    
    
}

