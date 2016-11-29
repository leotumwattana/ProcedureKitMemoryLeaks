//
//  LeakyGroupProcedure.swift
//  ProcedureKitMemoryLeaks
//
//  Created by Leo Tumwattana on 30/11/2016.
//  Copyright © 2016 procedurekitmemoryleaks. All rights reserved.
//

import ProcedureKit

final class LeakyGroupProcedure: GroupProcedure {
    
    init() {
        
        let op1 = LeakyProcedure()
        let op2 = LeakyProcedure()
        
        op2.add(dependency: op1)
        
        super.init(operations: [op1, op2])
        name = String(describing: type(of: self))
        qualityOfService = .userInitiated
        
        log.severity = .notice
        
        add(observer: BackgroundObserver())
        add(observer: TimeoutObserver(by: 20))
        add(observer: NetworkObserver())
        
        add(condition: ZoneExistCondition())
        
    }
    
}

final class LeakyProcedure: Procedure {
    
    override init() {
       
        super.init()
        name = String(describing: type(of: self))
        
        self.add(observer: BackgroundObserver())
        self.add(observer: TimeoutObserver(by: 20))
        
        log.severity = .notice
        
    }
    
    override func execute() {
        
        guard !isCancelled else { return }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.finish()
        }
        
    }
    
}
