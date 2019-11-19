//
//  Main.swift
//  Copyright © 2019 Serz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class Profile: UIViewController, UITextFieldDelegate{
    
    var firstStart: Bool = false
    
    private var welcomLbl: UILabel!
    private var overlay: UIView!
    private var activity: UIActivityIndicatorView!
    
    private var lblFName, lblName, lblBirthday: UILabel!
    private var tfFName, tfName, tfBirthday: UITextField!
    private var datePicker: UIDatePicker!
    private var datePickerBar: UIView!
    private var kbDone: UIToolbar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        var name = ""
        var birthday = ""
        var fname = ""
        
        if !firstStart{
            _ = createButton(self, parent: self.view,  x: 10*RK_X, y: 46*RK_X, width: 40*RK_X, height: 40*RK_X, action: #selector(self.btnTap(_:)), imageName: "arrowLeftFillpng", tag: 4)
            if let str =  USER_DATA["name"] as? String{
                name = str
            }
            if let str = USER_DATA["fname"] as? String{
                fname = str
            }
            if let str =  USER_DATA["birthday"] as? String{
                birthday = str
            }
  
            
        } else {
            if let displayName = USER_DATA["displayName"] as? String{
                let nameArr = displayName.split(separator: " ") as NSArray
                if nameArr.count > 0{
                    name = nameArr[0] as! String
                }
                if nameArr.count > 1{
                    for i in 1...nameArr.count-1{
                        if i == 1 {
                            fname = nameArr[i] as! String
                        } else {
                            fname = fname + " " + (nameArr[i] as! String)
                        }
                    }
                }
            }
        }
        
        _ = createLabel(self.view, x: 36.5*RK_X, y: 118*RK_X, width: 200*RK_X, height: 29*RK_X, text: "Main Information", font: UIFont(name: "Roboto-Bold",  size: 25*RK_X)!, textColor: hexColor(0x292c32))
        
        
        kbDone = UIToolbar(frame: CGRect(x: 200,y: 200, width: self.view.frame.size.width,height: 30))
        kbDone.barStyle = UIBarStyle.default
        
        
        let button: UIButton = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 20)
        button.setTitle("Done", for: UIControl.State())
        button.addTarget(self, action: #selector(self.btnTap(_:)), for: UIControl.Event .touchUpInside)
        button.tag = 5
        button.setTitleColor(hexColor(0x188afe), for: UIControl.State())
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont(name: "Roboto-Regular",  size: 20*RK_X)!
        let nextButton: UIBarButtonItem = UIBarButtonItem()
        nextButton.customView = button
        
        
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10.0
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let toolbarButton = [flexSpace,nextButton,negativeSpace]
        kbDone.setItems(toolbarButton, animated: false)
        
        
        // NAME
        var viewBG = UIView(frame: CGRect(x: 38.5*RK_X, y: 197*RK_X, width: self.view.frame.width - 77*RK_X, height: 59.6*RK_X))
        viewBG.layer.borderWidth = 1;
        viewBG.layer.cornerRadius = 4*RK_X;
        viewBG.layer.borderColor = hexColor(0xe3e7ea).cgColor
        viewBG.clipsToBounds = true
        self.view.addSubview(viewBG)
        

        var addY:  CGFloat = 8*RK_X
        var hidden: Bool = false
        if name == "" {
            hidden = true
            addY = 0
        }
        
        // NAME
        lblName = createLabel(self.view, x: 55.5*RK_X, y: 207.5*RK_X, width: 134*RK_X, height: 15*RK_X, text: "Name", font: UIFont(name: "Roboto-Regular",  size: 12.75*RK_X)!, textColor: hexColor(0x979b9e), aligment: .left, numberOfLines:1)
        lblName.isHidden = hidden

        tfName = createTextField(self, parent: self.view, x: 55.5*RK_X, y: 215*RK_X+addY, width: self.view.frame.width-111*RK_X, height: 27*RK_X, text: name,  placeholder: "Name", font: UIFont(name: "Roboto-Regular",  size: 17*RK_X)!,  textColor: hexColor(0x383b41), keyboardType: .default)
        tfName.delegate = self
        tfName.inputAccessoryView = kbDone
        

        
        // SECOND NAME
        var addTop = 76*RK_X
        viewBG = UIView(frame: CGRect(x: 38.5*RK_X, y: 197*RK_X+addTop, width: self.view.frame.width - 77*RK_X, height: 59.6*RK_X))
        viewBG.layer.borderWidth = 1;
        viewBG.layer.cornerRadius = 4*RK_X;
        viewBG.layer.borderColor = hexColor(0xe3e7ea).cgColor
        viewBG.clipsToBounds = true
        self.view.addSubview(viewBG)
        
        addY = 8*RK_X
        hidden = false
        if fname == "" {
            hidden = true
            addY = 0
        }
        
        // NAME
        lblFName = createLabel(self.view, x: 55.5*RK_X, y: 207.5*RK_X+addTop, width: 134*RK_X, height: 15*RK_X, text: "Enter Second Name", font: UIFont(name: "Roboto-Regular",  size: 12.75*RK_X)!, textColor: hexColor(0x979b9e), aligment: .left, numberOfLines:1)
        lblFName.isHidden = hidden

        tfFName = createTextField(self, parent: self.view, x: 55.5*RK_X, y: 215*RK_X+addTop+addY, width: self.view.frame.width-111*RK_X, height: 27*RK_X, text: fname,  placeholder: "Enter Second Name", font: UIFont(name: "Roboto-Regular",  size: 17*RK_X)!,  textColor: hexColor(0x383b41), keyboardType: .default)
        tfFName.delegate = self
        tfFName.inputAccessoryView = kbDone
        
        
        
        // BIRTHDAY
        addTop = 76*RK_X*2
        viewBG = UIView(frame: CGRect(x: 38.5*RK_X, y: 197*RK_X+addTop, width: self.view.frame.width - 77*RK_X, height: 59.6*RK_X))
        viewBG.layer.borderWidth = 1;
        viewBG.layer.cornerRadius = 4*RK_X;
        viewBG.layer.borderColor = hexColor(0xe3e7ea).cgColor
        viewBG.clipsToBounds = true
        self.view.addSubview(viewBG)
        
      
        addY = 8*RK_X
        hidden = false
        if birthday == "" {
            hidden = true
            addY = 0
        }
        
        // NAME
        lblBirthday = createLabel(self.view, x: 55.5*RK_X, y: 207.5*RK_X+addTop, width: 134*RK_X, height: 15*RK_X, text: "Date of birth", font: UIFont(name: "Roboto-Regular",  size: 12.75*RK_X)!, textColor: hexColor(0x979b9e), aligment: .left, numberOfLines:1)
        lblBirthday.isHidden = hidden

        tfBirthday = createTextField(self, parent: self.view, x: 55.5*RK_X, y: 215*RK_X+addTop + addY, width: self.view.frame.width-111*RK_X, height: 27*RK_X, text: birthday,  placeholder: "Date of birth", font: UIFont(name: "Roboto-Regular",  size: 17*RK_X)!,  textColor: hexColor(0x383b41), keyboardType: .default)
        tfBirthday.delegate = self
        
        _ = createButton(self, parent: self.view,  x: 55.5*RK_X, y: 197*RK_X+addTop, width: self.view.frame.width-111*RK_X, height: 60*RK_X, action: #selector(self.datePickerClick(_:)), title: "", tag: 4)
        _ = createButton(self, parent: self.view,  x: 305*RK_X, y: 372*RK_X, width: 17*RK_X, height: 17*RK_X, action: #selector(self.datePickerClick(_:)), imageName: "arrowDownSLine.pdf", tag: 4)
        
        
        
        
        // SAVE BTN
        let saveBtn = createButton(self, parent: self.view,  x: 37.5*RK_X, y: self.view.frame.height - 116*RK_X, width: self.view.frame.width-75*RK_X, height: 50*RK_X, action: #selector(self.btnTap(_:)), title: "Complete My Profile", textColor: .white, borderRadius: 6.25*RK_X, font:UIFont(name: "Roboto-Bold",  size: 17.5*RK_X)!, shadowColor: hexColor(0x188afe, alpha: 0.62), xShadow: 0, yShadow: 5*RK_X, shadowOpacity: 0.70, shadowRadius: 5*RK_X, backgroundColor: hexColor(0x188afe, alpha: 1), tag: 1)
        saveBtn.addTarget(self, action: #selector(self.btnDown(_:)), for: .touchDown);
        saveBtn.addTarget(self, action: #selector(self.btnUp(_:)), for: .touchUpOutside);
        saveBtn.addTarget(self, action: #selector(self.btnUp(_:)), for: .touchUpInside);

        
        _ = createButton(self, parent: self.view,  x: 37.5*RK_X, y: self.view.frame.height - 55*RK_X, width: self.view.frame.width-75*RK_X, height: 40*RK_X, action: #selector(self.btnTap(_:)), title: "Cancel Registration", textColor: hexColor(0x979b9e),  font:UIFont(name: "Roboto-Regular",  size: 12.75*RK_X)!, tag: 2)

        
        datePicker =  UIDatePicker(frame: CGRect(x:0, y:25*RK_X, width:self.view.frame.width, height:216));
        datePicker.backgroundColor = UIColor.white;
        datePicker.datePickerMode = UIDatePicker.Mode.date;
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.allEvents)
        
    }
    
    
    //=============================================
    //MARK: TEXTFIELD EVENTS
    //=============================================
    
    //=============================================
    // textField shouldChangeCharactersIn
    //=============================================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let str: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        var up = false
        var down = false
        if (textField.text! as NSString).length == 0 && str.length != 0{
            down =  true
        }
        if (textField.text! as NSString).length != 0 && str.length == 0{
            up =  true
        }
        
        
        var hidden = false
        if str == ""{
            hidden = true
        }
        if textField == tfName{
            lblName.isHidden = hidden
        } else if textField == tfFName{
            lblFName.isHidden = hidden
        }
        
        if up {
            textField.frame = CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y - 8*RK_X, width:  textField.frame.width, height: textField.frame.height)
        } else if down{
            textField.frame = CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y + 8*RK_X, width:  textField.frame.width, height: textField.frame.height)
        }
        
        return true
    }
    
    //=============================================
    // textField textFieldDidBeginEditing
    //=============================================
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.datePickerBar != nil{
            if !self.datePickerBar.isHidden{
                UIView.animate(withDuration: 0.4, animations: {
                    self.datePickerBar.frame = CGRect(x:0, y: self.view.frame.height, width: self.datePickerBar.frame.width, height: self.datePickerBar.frame.height);
                }, completion: {
                    (value: Bool) in
                    self.datePickerBar.isHidden = true
                })
            }
        }
    }
    
    //======================
    //MARK: BUTTONS EVENTS
    //======================
    @objc func btnDown(_ sender: UIButton!){
        sender.layer.shadowOpacity = 0
    }
    @objc func btnUp(_ sender: UIButton!){
        sender.layer.shadowOpacity = 0.7
    }
    
    
    //====================
    //MARK: BUTTONS TAP
    //====================
    
    @objc func btnTap(_ sender: UIButton!){
        switch sender.tag {
        // SAVE
        case 1:
            let formatter = DateFormatter();
            formatter.dateFormat = "dd MMMM yyyy"
            var years_txt = ""
            if tfBirthday.text != ""{
                let date = formatter.date(from: "\(tfBirthday.text!)")!
                let years: Int = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
                years_txt = "\(years)"
            }
            let params = "{user: { fullname: \"\(tfName.text!) \(tfFName.text!)\", age: \(years_txt)} }"
            
            USER_DATA["name"] = "\(tfName.text!)"
            USER_DATA["fname"] = "\(tfFName.text!)"
            USER_DATA["birthday"] = tfBirthday.text!
            USER_DATA["profileComplited"] = true
            do {
                let data = try JSONSerialization.data(withJSONObject: USER_DATA, options: JSONSerialization.WritingOptions.prettyPrinted)
                saveKeychain(itemKey: "USER_DATA", dataValue: data)
            }   catch let error as NSError {
                print(error)
            }
            print(params)
            postRequest(urlString: "https://sergeykvasov.firebaseapp.com/update_user_info",  params: params, tryQty:1)
            


        // LOGOUT
        case 2:
            
           do{
                GIDSignIn.sharedInstance()?.disconnect()
                try Firebase.Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.disconnect()
                
            }   catch let error as NSError {
                print(error)
            }
            
            deleteKeychain(itemKey: "USER_DATA")
            USER_DATA = NSMutableDictionary()
            FIREBASE_TOKEN = ""
            
           self.navigationController?.popToRootViewController(animated: false)
            
            
        case 3:
            
            UIView.animate(withDuration: 0.4, animations: {
                self.datePickerBar.frame = CGRect(x:0, y: self.view.frame.height, width: self.datePickerBar.frame.width, height: self.datePickerBar.frame.height);
            }, completion: {
                (value: Bool) in
                self.datePickerBar.isHidden = true
            })
            
        case 4:
            
            self.navigationController?.popViewController(animated: true)
            
        case 5:
            
            self.view.endEditing(true)
            
        default:
            print("undefined  id=\(sender.tag)!!!!!!!!!!")
        }
    }
    
    //===================
    //MARK: POST WEB DATA
    //===================
    
    func postRequest(urlString: String,  params: String,tryQty: Int = 1){
        
        self.createOverlay()
        
        print(urlString)
        
        let tryQtyNew = tryQty + 1
        
        let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodeString!)
        var request = URLRequest(url: url!);
        
        
        request.addValue("Bearer \(FIREBASE_TOKEN)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        if params != ""{
            request.httpBody = params.data(using: String.Encoding.utf8)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
//            if error != nil{
//                let alert = UIAlertView()
//                alert.message = "Server error \(error?.localizedDescription)"
//                alert.show()
//            }
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                DispatchQueue.main.async {
                    self.removeOverlay()
                    if tryQty <= 1{
                        self.postRequest(urlString: urlString, params: params, tryQty: tryQtyNew)
                    } else {
                        let alert = UIAlertView()
                        alert.addButton(withTitle: "OK")
                        alert.message = "Conection server error"
                        alert.show()
                    }
                    
                }
                return
            }
            
            self.removeOverlay()
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    let result = String(data: data!, encoding: String.Encoding.utf8)
                    print("\(result!)")
                    DispatchQueue.main.async {
                        if self.firstStart{
                            let main = Main()
                            self.navigationController?.pushViewController(main, animated: true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    // ERROR
                    let alert = UIAlertView()
                    alert.addButton(withTitle: "OK")
                    alert.message = "Profile saving error \(response.statusCode)"
                    alert.show()
                    print("!!!!!!!!! Error with response.statusCode: \(response.statusCode)\n data=\(String(describing: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)))")


                    
                }
            }
            
            
        }
        task.resume()
    }
    
    

    
    //=======================
    // handleDatePicker
    //=======================
    @objc func handleDatePicker(_ sender: UIDatePicker!) {
        
        let formatter = DateFormatter();
        formatter.dateFormat = "dd MMMM yyyy"
        let date_txt = formatter.string(from:sender.date)
        self.tfBirthday.text = date_txt
        if lblBirthday.isHidden {
            lblBirthday.isHidden = false
            self.tfBirthday.frame = CGRect(x: self.tfBirthday.frame.origin.x, y: self.tfBirthday.frame.origin.y + 8*RK_X, width:  self.tfBirthday.frame.width, height: self.tfBirthday.frame.height)
            
        }
    }
    
    
      //=======================
      // MARK: datePickerClick
      //=======================
    @objc func datePickerClick(_ sender: UIButton!){
        
        self.view.endEditing(false)
        if datePickerBar == nil{
            
            
            datePickerBar = createView(self.view, x: 0, y:self.view.frame.height, width:self.view.frame.width, height: self.view.frame.height, backgroundColor: UIColor.clear);
            
            
            let whiteBg = createView(datePickerBar, x: 0, y:datePickerBar.frame.height-(260-44+25*RK_X), width:self.view.frame.width, height: 260-44+25*RK_X, backgroundColor: UIColor.white, borderWidth: 1,  borderColor: UIColor.gray,  shadowColor: UIColor.white,  yShadow: -5*RK_X, shadowOpacity: 0.2, shadowRadius: 5*RK_X);
            datePickerBar.isHidden = true;
            _ = createView(whiteBg, x: 0, y:self.view.frame.height-260+44-25*RK_X, width:self.view.frame.width, height: 25*RK_X, backgroundColor: UIColor.lightGray);
            
            _ = createButton(self, parent: whiteBg,  x: self.view.frame.width-80*RK_X, y: 0*RK_X, width: 80*RK_X, height: 35*RK_X, action: #selector(self.btnTap(_:)), title:  "Done",  textColor:  hexColor(0x188afe, alpha: 1), font: UIFont(name: "Roboto-Regular",  size: 20*RK_X)!, tag: 3)
            
            datePicker =  UIDatePicker(frame: CGRect(x:0, y:25*RK_X, width:self.view.frame.width, height:216));
            datePicker.backgroundColor = UIColor.white;
            datePicker.datePickerMode = UIDatePicker.Mode.date;
            datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.allEvents)
            
            whiteBg.addSubview(datePicker);
            
            datePickerBar.isHidden = false;
            UIView.animate(withDuration: 0.4, animations: {
                self.datePickerBar.frame = CGRect(x:0, y: self.view.frame.height - self.datePickerBar.frame.height, width: self.datePickerBar.frame.width, height: self.datePickerBar.frame.height);
            })
        } else {
            datePickerBar.isHidden = false;
            UIView.animate(withDuration: 0.4, animations: {
                self.datePickerBar.frame = CGRect(x:0, y: self.view.frame.height - self.datePickerBar.frame.height, width: self.datePickerBar.frame.width, height: self.datePickerBar.frame.height);
            })
        }
        
        if tfBirthday.text != ""{
            let formatter = DateFormatter();
            formatter.dateFormat = "dd MMMM yyyy"
            let date = formatter.date(from: tfBirthday.text!)!
            datePicker.date = date
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

