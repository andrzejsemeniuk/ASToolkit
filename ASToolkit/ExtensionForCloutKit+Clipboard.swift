//
//  ExtensionForCloutKit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2025-12-03.
//  Copyright © 2025 Andrzej Semeniuk. All rights reserved.
//

import CloudKit

public func cloudKitClipboardUpload(container identifier: String, recordType: String, recordName: String, data: Data, info: [String : String]) async throws {
    let container = CKContainer(identifier: identifier)
    let database = container.publicCloudDatabase
    
    let recordID = CKRecord.ID(recordName: recordName)
    
    func applyFields(_ record: CKRecord) throws {
        if !info.isEmpty {
            let infoData: Data = try Data.encoded(info)
            if !infoData.isEmpty {
                record["info"] = infoData as CKRecordValue
            }
        }
        record["payload"]      = data as CKRecordValue
        record["isCompressed"] = true as CKRecordValue
        record["updatedAt"]    = Date() as CKRecordValue
        record["sizeInBytes"]  = data.count as CKRecordValue
    }
    
    func applyAndSave(_ record: CKRecord) async throws {
        try applyFields(record)
        _ = try await database.save(record)
    }
    
    do {
        let existing = try await database.record(for: recordID)
        do {
            try await applyAndSave(existing)
        } catch let saveError as CKError {
            switch saveError.code {
                case .serverRecordChanged:
                    let server = try await database.record(for: recordID)
                    try await applyAndSave(server)
                case .unknownItem:
                    let fresh = CKRecord(recordType: recordType, recordID: recordID)
                    try await applyAndSave(fresh)
                default:
                    throw saveError
            }
        }
    } catch let fetchError as CKError {
        switch fetchError.code {
            case .unknownItem:
                let fresh = CKRecord(recordType: recordType, recordID: recordID)
                try await applyAndSave(fresh)
            default:
                throw fetchError
        }
    }
}

public func cloudKitClipboardDownload(container identifier: String, recordName: String) async throws -> (payload: Data, info: [String: String]) {
    let container = CKContainer(identifier: identifier)
    let database = container.publicCloudDatabase
    
    let recordID = CKRecord.ID(recordName: recordName)
    let record = try await database.record(for: recordID)
    
    guard let payload = record["payload"] as? Data else {
        throw AnError.invalidParameter("payload is nil")
    }
    
    var info: [String: String] = [:]
    if let infoData = record["info"] as? Data {
        info ?= try? infoData.decoded()
    }
    
    return (payload, info)
}

