//
//  Product.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Product: Codable {
    var title, photo, uuid: String
    var id: Int
    
    static func getAllProducts() -> [Product]? {
        var products: [Product]?
        if let data = UserDefaults.standard.value(forKey:KEYS.PRODUCTS.rawValue) as? Data {
            products = try? PropertyListDecoder().decode(Array<Product>.self, from: data)
        }
        return products
    }
    
    static func getAddedProductsCBUUIDs() -> [CBUUID] {
        var uuids = [CBUUID]()
        if let data = UserDefaults.standard.value(forKey:KEYS.PRODUCTS.rawValue) as? Data {
            if let products = try? PropertyListDecoder().decode(Array<Product>.self, from: data) {
                _ = products.map {
                   // uuids[] =
                    uuids.append(CBUUID(string: $0.uuid))
                }
                
            }
        }
        return uuids
    }
    
    static func addProduct(product: Product) {
        guard !product.exists else {
            return
        }
        var products = [Product]()
        if let products_ = getAllProducts() {
            products = products_
        }
        products.append(product)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(products), forKey:KEYS.PRODUCTS.rawValue)
    }
    
    var exists: Bool {
        guard let products = Product.getAllProducts() else {
            return false
        }
        return products.filter { $0.id == self.id }.count > 0
    }
}
