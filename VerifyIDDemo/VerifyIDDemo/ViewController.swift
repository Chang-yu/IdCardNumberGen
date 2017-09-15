//
//  ViewController.swift
//  VerifyIDDemo
//
//  Created by Johnson Chen on 2017/9/12.
//  Copyright © 2017年 OMG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputIDTextField: UITextField!
    @IBOutlet weak var showIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputIDTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func generateID(_ sender: UIButton) {
        let gendarNum = Int(arc4random_uniform(2) + 1)
        let calNum = gendarNum * 8
        let gendarStr = String(gendarNum)
        let tuple1:(str1:String, num1:Int) = GenAndVerifyIDUtil.generateAlphabet()
        let tuple2:(str2:String, num2:Int) = GenAndVerifyIDUtil.generateString(WithNumberCount: 7)
        let finalStr = String((10 - (tuple1.num1 + calNum + tuple2.num2) % 10) % 10)
        
        showIDLabel.text = tuple1.str1 + gendarStr + tuple2.str2 + finalStr
    }

    func verifyUID(_ uid:String) -> Bool {
        
        guard uid.characters.count == 10 else {
            print("請輸入正確的ID. (10個字元)")
            GenAndVerifyIDUtil.popMessage(WithViewController: self, WithTitle: "請輸入正確的ID. (10個字元)", WithSubTitle: "")
            return false
        }
        
        let index1 = uid.index(uid.startIndex, offsetBy: 1)
        let indexForGendar = uid.index(uid.startIndex, offsetBy: 2)
        let index2 = uid.index(uid.startIndex, offsetBy: 9)
        let rangeForGendar = index1..<indexForGendar
        let range = index1..<index2
        let alpha = uid.substring(to: index1)
        let number = uid[range]
        
        let firNum = GenAndVerifyIDUtil.getNumFrom(FirstAlphabet: alpha)
        let secNum = GenAndVerifyIDUtil.getNum(FromNum: number)
        
        guard firNum != 0 else {
            GenAndVerifyIDUtil.popMessage(WithViewController: self, WithTitle: "請輸入正確的ID. (字母需大寫)", WithSubTitle: "")
            return false
        }
        
        guard uid[rangeForGendar] == "1" || uid[rangeForGendar] == "2" else {
            print("請輸入正確的ID. (性別碼錯誤)")
            GenAndVerifyIDUtil.popMessage(WithViewController: self, WithTitle: "請輸入正確的ID. (性別碼錯誤)", WithSubTitle: "")
            return false
        }
        
        if let thirdNum = Int(String(uid.characters.suffix(1))) {
            
            let result = (firNum + secNum + thirdNum) % 10
            if result == 0 {
                return true
            }
        }
        
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let input = textField.text, input != "" {
            print(input)
            let isOK = verifyUID(input)
            if isOK == true {
                print("uid is correct!")
                GenAndVerifyIDUtil.popMessage(WithViewController: self, WithTitle: "輸入的身分證字號正確", WithSubTitle: "")
            }else{
                print("uid is not valid.")
                GenAndVerifyIDUtil.popMessage(WithViewController: self, WithTitle: "輸入的身分證字號錯誤", WithSubTitle: "")
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10
    }
    
}

