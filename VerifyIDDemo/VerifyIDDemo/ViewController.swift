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
        let tuple1:(str1:String, num1:Int) = generateAlphabet()
        let tuple2:(str2:String, num2:Int) = generateString(WithNumberCount: 7)
        let finalStr = String((10 - (tuple1.num1 + calNum + tuple2.num2) % 10) % 10)
        
        showIDLabel.text = tuple1.str1 + gendarStr + tuple2.str2 + finalStr
    }
    
    func generateAlphabet() -> (String, Int) {
        var alphaNum:Int = 0
        var alphaStr:String = ""
        alphaNum = Int(arc4random_uniform(26)) + 65;
        alphaStr = String(UnicodeScalar(UInt8(alphaNum)))
        let finalNum = convertToIDFirstNumBy(ASCNum: alphaNum)
        
        return (alphaStr, finalNum)
    }
    
    func generateString(WithNumberCount count:Int) -> (String, Int) {
        
        var str:String = ""
        
        for _ in 1...count {
            str += String(arc4random_uniform(10))
        }
        
        let sum = getNum(FromNum: str)
        
        return (str, sum)
    }

    func verifyUID(_ uid:String) -> Bool {
        
        guard uid.characters.count == 10 else {
            print("請輸入正確的ID. (10個字元)")
            return false
        }
        
        let index1 = uid.index(uid.startIndex, offsetBy: 1)
        let index2 = uid.index(uid.startIndex, offsetBy: 9)
        let range = index1..<index2
        let alpha = uid.substring(to: index1)
        let number = uid[range]
        
        let firNum = getNumFrom(FirstAlphabet: alpha)
        let secNum = getNum(FromNum: number)
        
        if let thirdNum = Int(String(uid.characters.suffix(1))) {
            guard firNum != 0 else {
                return false
            }
            
            let result = (firNum + secNum + thirdNum) % 10
            if result == 0 {
                return true
            }
        }
        
        return false
    }
    
    func getNumFrom(FirstAlphabet first:String) -> Int {
        let firNum = UnicodeScalar(first)?.value
        if let alphabetNum = firNum {
            
            if alphabetNum >= 65 && alphabetNum <= 90 {
                let newNum2 = Int(alphabetNum)
                return convertToIDFirstNumBy(ASCNum: newNum2)
            }else{
                print("請輸入正確的ID. (字母需大寫)")
                return 0
            }
        }
        else{
            print("Something wrong!")
            return 0
        }
    }
    
    func getNum(FromNum number:String) -> Int {
        let numberArray = Array(number.characters)
        var sum:Int = 0
        for index in 0...(numberArray.count - 1) {
            if let strNum = Int(String(numberArray[index])) {
                
                sum += strNum * (numberArray.count - index)
                
            }
        }
        return sum
    }
    
    func convertToIDFirstNumBy(ASCNum number:Int) -> Int {
        let newNum = number - 55
        let firstNum = newNum / 10
        let secondNum = newNum % 10
        return firstNum + secondNum * 9
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let input = textField.text, input != "" {
            print(input)
            let isOK = verifyUID(input)
            if isOK == true {
                print("uid is correct!")
            }else{
                print("uid is not valid.")
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

