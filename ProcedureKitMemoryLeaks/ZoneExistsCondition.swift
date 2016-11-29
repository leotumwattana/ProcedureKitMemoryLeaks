//
//  ZoneExistsCondition.swift
//  ProcedureKitMemoryLeaks
//
//  Created by Leo Tumwattana on 30/11/2016.
//  Copyright © 2016 procedurekitmemoryleaks. All rights reserved.
//

import CloudKit
import ProcedureKit

final class ZoneExistCondition: Condition {
    
    enum ConditionError: Error {
        case ZoneDoesNotExist
    }
    
    override init() {
        
        super.init()
        name = String(describing: type(of: self))
        log.severity = .notice
        
        add(dependency: ZoneSetupProcedure())
        
    }
    
    override func evaluate(procedure: Procedure, completion: @escaping (ConditionResult) -> Void) {
        
        if zoneExists {
            completion(.success(true))
        } else {
            completion(.failure(ConditionError.ZoneDoesNotExist))
        }
        
    }
    
}
