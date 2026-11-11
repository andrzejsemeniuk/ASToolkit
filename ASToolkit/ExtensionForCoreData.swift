//
//  ExtensionForCoreData.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2024-10-24.
//  Copyright © 2024 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreData

extension NSAttributeType {
    
    var name : String {
        switch self {
            case .undefinedAttributeType        : return "?"
            case .integer16AttributeType        : return "Int16"
            case .integer32AttributeType        : return "Int32"
            case .integer64AttributeType        : return "Int64"
            case .decimalAttributeType          : return "Decimal"
            case .doubleAttributeType           : return "Double"
            case .floatAttributeType            : return "Float"
            case .stringAttributeType           : return "String"
            case .booleanAttributeType          : return "Bool"
            case .dateAttributeType             : return "Date"
            case .binaryDataAttributeType       : return "Binary Data"
            case .UUIDAttributeType             : return "UUID"
            case .URIAttributeType              : return "URI"
            case .transformableAttributeType    : return "Transformable"
            case .objectIDAttributeType         : return "Object ID"
            case .compositeAttributeType        : return "Composite"
            @unknown default:
                fatalError()
        }
    }
}

