//
//  ViewController.swift
//  ProcedureKitMemoryLeaks
//
//  Created by Leo Tumwattana on 30/11/2016.
//  Copyright © 2016 procedurekitmemoryleaks. All rights reserved.
//

import UIKit
import ProcedureKit

class ViewController: UIViewController {
    
    lazy var queue: ProcedureQueue = {
        
        let q = ProcedureQueue()
        q.name = String(describing: type(of: self)) + "Queue"
        return q
        
    }()
    
    var tap:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        view.addGestureRecognizer(tap)
        
        startLeakyOp()
    }
    
    private func startLeakyOp() {
        
        let op = LeakyGroupProcedure()
        
        op.add(observer: DidFinishObserver(didFinish: { (op, errors) in
            op.log.notice(message: "Did finish")
        }))
        
        let block = AsyncBlockProcedure { (finishWithResult) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                finishWithResult(.success(()))
            }
        }
        
        block.add(dependency: op)
        
        queue.add(operations: [op, block])
        
    }
    
    func tapped(_ tap:UITapGestureRecognizer) {
        
        print("LALA")
        startLeakyOp()
        
    }

}

