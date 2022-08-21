//
//  Observable.swift
//  MVVM_Demo
//
//  Created by Ahmed Amin on 21/08/2022.
//

import Foundation


class Observable<T> {
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T?) -> Void)?
    
    init(_ value: T?) {
        self.value = value
    }
    
    public func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
 
