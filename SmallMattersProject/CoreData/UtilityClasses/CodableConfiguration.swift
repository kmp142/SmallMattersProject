//
//  CodableConfiguration.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.05.2024.
//

import Foundation

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
