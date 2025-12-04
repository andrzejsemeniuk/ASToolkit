//
//  ExtensionForCloutKit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2025-12-03.
//  Copyright © 2025 Andrzej Semeniuk. All rights reserved.
//

import CloudKit

public struct CloudKitClipboardPackedPayload: Codable {
    let version: Int
    let encoding: String
    let payload: Data // gzip-compressed content
}

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

public func cloudKitClipboardDownload(container identifier: String, recordName: String) async throws -> (payload: Data, metadata: CloudKitClipboardMetadata) {
    
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

    let isCompressed = record["isCompressed"] as? Bool
    let updatedAt = record["updatedAt"] as? Date
    let sizeInBytes = record["sizeInBytes"] as? Int

    let metadata = CloudKitClipboardMetadata(
        info: info,
        isCompressed: isCompressed,
        updatedAt: updatedAt,
        sizeInBytes: sizeInBytes
    )

    return (payload, metadata)
}

public struct CloudKitClipboardMetadata {
    public let info: [String: String]
    public let isCompressed: Bool?
    public let updatedAt: Date?
    public let sizeInBytes: Int?
}

public func cloudKitClipboardMetadata(container identifier: String, recordName: String) async throws -> CloudKitClipboardMetadata {
    let container = CKContainer(identifier: identifier)
    let database = container.publicCloudDatabase

    let recordID = CKRecord.ID(recordName: recordName)

    // Only fetch the fields we care about; exclude "payload"
    let desiredKeys: [CKRecord.FieldKey] = ["info", "isCompressed", "updatedAt", "sizeInBytes"]

    return try await withCheckedThrowingContinuation { continuation in
        let op = CKFetchRecordsOperation(recordIDs: [recordID])
        op.desiredKeys = desiredKeys
        op.qualityOfService = .userInitiated

        var resultError: Error?
        var fetchedRecord: CKRecord?

        op.perRecordResultBlock = { id, result in
            switch result {
            case .success(let record):
                fetchedRecord = record
            case .failure(let error):
                resultError = error
            }
        }

        op.fetchRecordsResultBlock = { overallResult in
            if let error = resultError {
                continuation.resume(throwing: error)
                return
            }
            if case .failure(let error) = overallResult {
                continuation.resume(throwing: error)
                return
            }
            guard let record = fetchedRecord else {
                continuation.resume(throwing: AnError.invalidParameter("record not found"))
                return
            }

            var info: [String: String] = [:]
            if let infoData = record["info"] as? Data {
                info ?= try? infoData.decoded()
            }

            let isCompressed = record["isCompressed"] as? Bool
            let updatedAt = record["updatedAt"] as? Date
            let sizeInBytes = record["sizeInBytes"] as? Int

            continuation.resume(returning: CloudKitClipboardMetadata(
                info: info,
                isCompressed: isCompressed,
                updatedAt: updatedAt,
                sizeInBytes: sizeInBytes
            ))
        }

        database.add(op)
    }
}
