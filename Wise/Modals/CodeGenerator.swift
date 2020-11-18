//
//  CodeGenerator.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/18/20.
//

import Foundation

extension Int {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

func generateCode(phNo: String) -> String {
    let date = Date().getFormattedDate(format: "HH:mm:ss.SSS")

    let spTime = date.components(separatedBy: ".")
    let spHMS = spTime[0].components(separatedBy: ":")
    let tmp = String(Int(spHMS[0])! + Int(spHMS[1])! + Int(spHMS[2])!)
    let p2 = tmp + spTime[1]

    let phNo = 8667511746
    let ph = phNo.digits
    _ = Int(p2)!.digits
    var code = [Character]()
    for i in 0..<ph.count {
        if ph[i] % 2 == 0 || i == ph.count || i == 5{ code.append(contentsOf: String(UnicodeScalar(ph[i] + 64)!)) }
        else { code.append(contentsOf: String(ph[i])) }
    }
    
    return "code"
    
}
