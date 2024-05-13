//
//  DeadlineIndicator.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation
import UIKit

class DeadlineIndicator {

    static func getImageByDeadline(date: Date) -> UIImage {
        let timeIntervalInSeconds = date.timeIntervalSinceNow
        let distinctionBetweenDateAndNowInHours =  timeIntervalInSeconds / (60 * 60)
        var image = UIImage(named: "whiteTemplate")
        switch distinctionBetweenDateAndNowInHours {
        case 0...3:
            let red = #colorLiteral(red: 1, green: 0.3226445913, blue: 0.3124185205, alpha: 1)
            image = image?.withTintColor(red)
        case 3...24:
            let blue = #colorLiteral(red: 0.4115773439, green: 0.793646872, blue: 1, alpha: 1)
            image = image?.withTintColor(blue)
        case 24...48:
            let green = #colorLiteral(red: 0.4513883591, green: 1, blue: 0.672924757, alpha: 1)
            image = image?.withTintColor(green)
        default: break
        }
        return image ?? UIImage()
    }
}
