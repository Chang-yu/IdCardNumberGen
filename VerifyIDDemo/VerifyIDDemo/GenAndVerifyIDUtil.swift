//
//  GenAndVerifyIDUtil.swift
//  VerifyIDDemo
//
//  Created by Johnson Chen on 2017/9/15.
//  Copyright © 2017年 OMG. All rights reserved.
//

import UIKit
import Foundation

class GenAndVerifyIDUtil {
    
    static func generateAlphabet() -> (String, Int) {
        var alphaNum:Int = 0
        var alphaStr:String = ""
        alphaNum = Int(arc4random_uniform(26)) + 65;
        alphaStr = String(UnicodeScalar(UInt8(alphaNum)))
        let finalNum = convertToIDFirstNumBy(ASCNum: alphaNum)
        
        return (alphaStr, finalNum)
    }
    
    static func generateString(WithNumberCount count:Int) -> (String, Int) {
        
        var str:String = ""
        
        for _ in 1...count {
            str += String(arc4random_uniform(10))
        }
        
        let sum = getNum(FromNum: str)
        
        return (str, sum)
    }
    
    static func getNumFrom(FirstAlphabet first:String) -> Int {
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
    
    static func getNum(FromNum number:String) -> Int {
        let numberArray = Array(number.characters)
        var sum:Int = 0
        for index in 0...(numberArray.count - 1) {
            if let strNum = Int(String(numberArray[index])) {
                
                sum += strNum * (numberArray.count - index)
                
            }
        }
        return sum
    }
    
    static func convertToIDFirstNumBy(ASCNum number:Int) -> Int {
        let newNum = number - 55
        let firstNum = newNum / 10
        let secondNum = newNum % 10
        return firstNum + secondNum * 9
    }
    
    static func popMessage(WithViewController viewcontroller:UIViewController, WithTitle title:String, WithSubTitle subtitle:String) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
}
