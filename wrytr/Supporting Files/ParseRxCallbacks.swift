//
//  ParseRxCallbacks.swift
//  wrytr
//
//  Created by Andrew Breckenridge on 3/21/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import Foundation

import RxSwift

class ParseRxCallbacks {
    
    static func createWithCallback<T>(_ callback: ((AnyObserver<T>) -> Void)) -> Observable<T> {
        return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
            callback(observer)
            return NopDisposable.instance
        })
    }

    static func rx_parseCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T, _ error: NSError?) -> Void {
        return { (object: T, error: NSError?) in
            if error == nil {
                observer.on(.Next(object))
                observer.on(.Completed)
            } else {
                observer.on(.Error(error!))
            }
        }
    }
    
    static func rx_parseUnwrappedOptionalCallback<T>(_ observer: AnyObserver<T>) -> (_ object: T?, _ error: NSError?) -> Void {
        return { (object: T?, error: NSError?) in
            if error == nil {
                observer.on(.Next(object!))
                observer.on(.Completed)
            } else {
                observer.on(.Error(error!))
            }
        }
    }
    
    static func rx_parseOptionalCallback<T>(_ observer: AnyObserver<T?>) -> (_ object: T?, _ error: NSError?) -> Void {
        return { (object: T?, error: NSError?) in
            if error == nil {
                observer.on(.Next(object))
                observer.on(.Completed)
            } else {
                observer.on(.Error(error!))
            }
        }
    }
    
}
