//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation

extension Int {
    public func toRoundedSuffixAsString() -> String {
        var number = Double(self)
        let sign = ((number < 0) ? "-" : "" );
        number = fabs(number);
        if (number < 1000.0){
            return "\(sign)\(number)";
        }
        let exp: Int = Int(log10(number) / 3.0 );
        let units: [String] = ["K","M","G","T","P","E"];
        let roundedNum: Double = round(10 * number / pow(1000.0, Double(exp))) / 10;
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
}
