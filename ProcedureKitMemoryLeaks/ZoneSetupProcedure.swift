//
//  ZoneSetupProcedure.swift
//  ProcedureKitMemoryLeaks
//
//  Created by Leo Tumwattana on 30/11/2016.
//  Copyright © 2016 procedurekitmemoryleaks. All rights reserved.
//

import CloudKit
import ProcedureKit

var zoneExists = false

final class ZoneSetupProcedure: GroupProcedure {
    
    init() {
        
        if zoneExists {
            
            super.init(operations: [])
            
        } else {
            
            let op = CloudKitProcedure { CKModifyRecordZonesOperation() }
            op.name = String(describing: type(of: op.self))
            op.container = CKContainer.default()
            op.database = CKContainer.default().privateCloudDatabase
            
            let zoneID = CKRecordZoneID(zoneName: "LeakyZone", ownerName: CKOwnerDefaultName)
            let recordZone = CKRecordZone(zoneID: zoneID)
            
            op.recordZonesToSave = [recordZone]
            op.recordZoneIDsToDelete = nil
            
            op.setModifyRecordZonesCompletionBlock {
                
                (saved, deletedIDs) in
                
                if saved?.count != 0 {
                    zoneExists = true
                }
                
            }
            
            op.set(errorHandlerForCode: .serverRejectedRequest) {
                
                (op, error, log, suggested) ->
                (Delay?, (CKProcedure<CKModifyRecordZonesOperation>) -> Void)? in
                
                zoneExists = true
                
                return nil
                
            }
            
            op.set(errorHandlerForCode: .zoneNotFound) {
                
                (op, error, log, suggested) ->
                (Delay?, (CKProcedure<CKModifyRecordZonesOperation>) -> Void)? in
                
                return suggested
                
            }
            
            op.set(errorHandlerForCode: .userDeletedZone) {
                
                (procedure, error, log, suggested) ->
                (Delay?, (CKProcedure<CKModifyRecordZonesOperation>) -> Void)? in
                
                return suggested
                
            }
            
            super.init(operations: [op])
            
        }
        
        name = String(describing: type(of: self))
        log.severity = .notice
        
        add(condition: NoFailedDependenciesCondition(ignoreCancellations: false))
        
        add(observer: BackgroundObserver())
        add(observer: TimeoutObserver(by: 5 * 60))
        
    }
    
}
