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
            image = image?.withTintColor(.red)
        case 3...24:
            image = image?.withTintColor(.blue)
        case 24...48:
            image = image?.withTintColor(.green)
        default: break
        }
        return image ?? UIImage()
    }
}
