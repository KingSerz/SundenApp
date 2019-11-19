//
//  Main.swift
//  Copyright © 2019 Serz. All rights reserved.
//

import Foundation
import MessageUI
import AVFoundation
import Firebase
import GoogleSignIn

class Main: UIViewController{
    
    private var hahaImg: UIImageView!
    private var helloLbl: UILabel!
    private var nameLbl: UILabel!
    private var descLbl: UILabel!
    private var profileBtn: UIButton!
    private var overlay: UIView!
    private var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        DispatchQueue.main.async {
            self.createUI()
        }
        
        getRequest("https://sergeykvasov.firebaseapp.com/hello", query: 1)
     
    }
 
    //====================
    // createUI
    //====================
    func createUI(){
        self.hahaImg = createImageView(self.view, x: self.view.frame.width,  y: 106*RK_X, width: 88.5*RK_X, height: 98*RK_X, image: UIImage(named: "hahaFace.pdf")!, alpha: 1)
        
        self.helloLbl = createLabel(self.view, x: -20*RK_X, y: 120*RK_X, width: 219*RK_X, height: 98*RK_X, text: "Hello!", font: UIFont(name: "Roboto-Bold",  size: 83*RK_X)!, textColor: hexColor(0x292c32), aligment: .left, numberOfLines: 1, alpha: 0)
        self.helloLbl.adjustsFontSizeToFitWidth = true
        self.helloLbl.minimumScaleFactor = 0.1;
        self.helloLbl.transform = CGAffineTransform(scaleX: 1/50, y: 1/50)
        
        self.nameLbl = createLabel(self.view, x: 50*RK_X, y: 320*RK_X, width: self.view.frame.width - 90*RK_X, height: 27*RK_X, text: "", font: UIFont(name: "Roboto-Bold",  size: 25*RK_X)!, textColor: hexColor(0x292c32), aligment: .left, numberOfLines: 1, alpha: 0)
        
        self.descLbl = createLabel(self.view, x: 45*RK_X, y: 362*RK_X, width: 265*RK_X, height: 100*RK_X, text: "The site is a collection of plugins, tutorials, tips, articles, UI kits, wireframe kits, templates, icons, and many design resources", font: UIFont(name: "Roboto-Light",  size: 16.5*RK_X)!, textColor: hexColor(0x7c7c84), aligment: .left, numberOfLines: 4, lineSpacing: 6, alpha: 0)
        
        self.profileBtn = createButton(self, parent: self.view,  x: 46*RK_X, y: self.view.frame.height - 168*RK_X, width: self.view.frame.width-92*RK_X, height: 50*RK_X, action: #selector(self.btnTap(_:)), title: "Profile", textColor: hexColor(0x7c7c84), font:UIFont(name: "Roboto-Light",  size: 17.5*RK_X)!, shadowColor: hexColor(0x7c7c84, alpha: 1), xShadow: 0, yShadow: 5*RK_X, shadowOpacity: 0.80, shadowRadius: 5*RK_X, backgroundColor: hexColor(0x188afe, alpha: 0), tag: 1)
        self.profileBtn.alpha = 0
    }
    
    //====================
    // showMustGoOn
    //====================
     func showMustGoOn() {
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue =  NSNumber(value: -2*Double.pi * 2)
        rotation.duration = 1.1
        rotation.isCumulative = true
        rotation.repeatCount = 1
        self.hahaImg.layer.add(rotation, forKey: "rotationAnimation")
        
        UIView.animate(withDuration: 1.2, animations: {
            self.hahaImg.frame = CGRect(x: 45*RK_X, y: 106*RK_X, width: 88.5*RK_X, height: 98*RK_X)
        }, completion: {
            (value: Bool) in
            self.helloLbl.alpha = 0.5
            UIView.animate(withDuration: 0.7, animations: {
                self.helloLbl.alpha = 1
                self.helloLbl.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.helloLbl.frame = CGRect(x: 45*RK_X, y: 233.5*RK_X, width: 219*RK_X, height: 98*RK_X)
            }, completion: {
                (value: Bool) in
                self.helloLbl.transform = .identity
                self.helloLbl.frame = CGRect(x: 45*RK_X, y: 233.5*RK_X, width: 219*RK_X, height: 98*RK_X)
                
                UIView.animate(withDuration: 0.35, animations: {
                    self.nameLbl.alpha = 1
                }, completion: {
                    (value: Bool) in
                    UIView.animate(withDuration: 0.35, animations: {
                        self.descLbl.alpha = 1
                        self.profileBtn.alpha = 1
                    }, completion: {
                        (value: Bool) in
                    })
                })
            })
        })
    }
    
    
    //====================
    // BUTTONS TAP
    //====================
    
    @objc func btnTap(_ sender: UIButton!){
        switch sender.tag {
        // PROFILE
        case 1:
            let prof = Profile()
            self.navigationController?.pushViewController(prof, animated: true)
        default:
            print("undefined  id=\(sender.tag)!!!!!!!!!!")
        }
    }
    
    
    //=============
     // getRequest
     //=============
    func getRequest(_ url: String, query: Int) {
        
        print(url)
        createOverlay()
         
        let encodeString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodeString!)
        var request = URLRequest(url: url!);
        request.addValue("Bearer \(FIREBASE_TOKEN)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                DispatchQueue.main.async {
                    print("Ошибка соединения с сервером")
                }
                self.removeOverlay()
                return
            }
            DispatchQueue.main.async {
                self.removeOverlay()
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        
                        let helloTxt = String(data: data!, encoding: String.Encoding.utf8)
                        self.nameLbl.text = helloTxt
                        
                        self.showMustGoOn()
                    } else {
                        // ERROR
                        print("!!!!!!!!! Error with response.statusCode: \(response.statusCode)\n data=\(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)))")
                    }
                }
            }
        }
        task.resume()
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

