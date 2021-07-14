//
//  Cache.swift
//  T
//
//  Created by youngho joo on 2021/07/14.
//

import Foundation

struct Cache<Key: Hashable, Value> {
    private var wrapped = Dictionary<WrappedKey, Entry>()
    
    mutating func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.updateValue(entry, forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        let entry = wrapped[WrappedKey(key)]
        return entry?.value
    }
    
    mutating func removeValue(forKey key: Key) {
        wrapped.removeValue(forKey: WrappedKey(key))
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
}

private extension Cache {
    final class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

