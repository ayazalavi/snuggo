//
//  Data.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/7/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation

struct Product: Codable {
    var title, photo: String
    var id: Int
    
    static func getAllProducts() -> [Product]? {
        var products: [Product]?
        if let data = UserDefaults.standard.value(forKey:KEYS.PRODUCTS.rawValue) as? Data {
            products = try? PropertyListDecoder().decode(Array<Product>.self, from: data)
        }
        return products
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

struct QRData:Decodable {
    var product_id: Int
}

enum KEYS: String, RawRepresentable {
    case PRODUCTS
}

var data = [
    Product(title: "Car Seat Monitoring", photo: "carseat", id: 1),
    Product(title: "Car Seat Monitoring", photo: "carseat", id: 2),
    Product(title: "Car Seat Monitoring", photo: "carseat", id: 3),
    Product(title: "Car Seat Monitoring 2", photo: "carseat-2", id: 4),
    Product(title: "Car Seat Monitoring 2", photo: "carseat-2", id: 5),
    Product(title: "Car Seat Monitoring 2", photo: "carseat-2", id: 6)
]
