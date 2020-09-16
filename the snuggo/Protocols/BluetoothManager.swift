//
//  BluetoothManager.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothManager {
    var peripherals: Dictionary<UUID, CBPeripheral> { get }
    var delegate: SnuggoWidgetDelegate? { get set }
    func connectToPeripherals()
}
