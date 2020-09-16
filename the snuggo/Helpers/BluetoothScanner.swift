//
//  BluetoothScanner.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/13/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BluetoothScanner: NSObject, BluetoothManager {
    weak var delegate: SnuggoWidgetDelegate? {
        didSet {
            delegate?.updatePowerStatus(power: centralManager?.state == .poweredOn ? true : false)
        }
    }
    var centralManager: CBCentralManager?
    let semaphore = DispatchSemaphore(value: 0)
    var timer, timer2: Timer?
    var currentPeripheral: CBPeripheral?
    var data: [SeatData]?
    let uuid = CBUUID(string: AppKeys.UUID.rawValue)
    var seatData: SeatData?
    var notifSent = false
    
    private(set) var peripherals = Dictionary<UUID, CBPeripheral>() {
        didSet {
            self.connectToPeripherals()
        }
    }
    
    // MARK: Singleton
    static let shared = BluetoothScanner()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(startScanning), name: UIApplication.willEnterForegroundNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(stopScanning), name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil)
    }
    
    // MARK: - Callbacks
    @objc func startScanning() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "\(AppKeys.UUID.rawValue)"])
        //centralManager?.r
       // self.cleanCurrentCocctions()
    }
    
    @objc func stopScanning() {
        if let central = self.centralManager {
            if central.isScanning {
                central.stopScan()
            }
            _ = self.peripherals.mapValues {
                central.cancelPeripheralConnection($0)
            }
            self.peripherals.removeAll()
            delegate?.updatePowerStatus(power: false)
            timer?.invalidate()
            notifSent = false
        }
    }
    
    func cleanCurrentConnections() {
        if self.centralManager?.state == .poweredOn {
            for (uuid, peripheral) in self.peripherals {
                if peripheral.state == .connected {
                    print(uuid)
                    self.centralManager?.cancelPeripheralConnection(peripheral)
                    peripheral.delegate = nil
                }
            }
//            if let devices = self.centralManager?.retrieveConnectedPeripherals(withServices: [self.uuid]), devices.count > 0 {
//                print(devices)
//                _ = devices.map{ self.centralManager?.cancelPeripheralConnection($0) }
//            }
        }
    }

    
    @objc func appWillTerminate() {
        self.cleanCurrentConnections()
        self.timer?.invalidate()
        if let scanning = self.centralManager?.isScanning, scanning {
            self.centralManager?.stopScan()
        }
        print("semaphore")
        semaphore.wait()
        print("sempahore released")
        self.centralManager = nil
    }
    
    @objc func appMovedToBackground() {
//        if let central = self.centralManager, central.isScanning {
//            central.stopScan()
//        }
       // self.timer?.invalidate()
    }
    
    @objc func connectToPeripherals() {
        guard self.peripherals.count > 0 else {
            print("No pripherals found")
            return
        }
        self.timer?.invalidate()
        print("Products count: \(self.peripherals.count)")
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            for (uuid, peripheral) in self.peripherals {
                if peripheral.state != .connected {
                    self.centralManager?.connect(peripheral, options: nil)
                    print("connecting to \(uuid)")
                    self.semaphore.wait()
                    print("connection completed \(peripheral.state == .connected)  \(peripheral.state == .connecting) \(peripheral.services?.count)")
                }
                if peripheral.state != CBPeripheralState.connected {
                    if let seat = self.seatData, seat.weight > 0 {
                        let errorMsg = ErrorMessage(shortMessage: "CHILD LEFT IN SEAT ALERT", longMessage: "Your child is still in the car seat, please ensure a responsible adult is with the child.")
                        //let errorMsg = ErrorMessage(shortMessage: "CHILD LEFT SEAT", longMessage: "Your child has left their car seat. If this was intentional then the SMART system will switch off in 60 seconds.")
                        let content = UNMutableNotificationContent()
                        content.title = errorMsg.shortMessage
                        content.body = errorMsg.longMessage
                        content.sound = UNNotificationSound.default
                        content.badge = 1
                        let notif = UNNotificationRequest(identifier: "SnuggoError.ChildLeftInSeat", content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(notif) { (error) in
                           // print(error)
                        }
                        self.delegate?.childLeftInCarSeat(left: true)
                    }
                    //peripheral.discoverServices([self.uuid])
                    
                    //self.centralManager?.cancelPeripheralConnection(peripheral)
                }
                else {
                    self.delegate?.childLeftInCarSeat(left: false)
                }
                //peripheral.discoverServices([self.uuid])
                //self.centralManager?.cancelPeripheralConnection(peripheral)
            }
            //self.centralManager?.stopScan()
            //self.connectToPeripherals()
        }
        
    }
}

// MARK: Central Manager Delegate
extension BluetoothScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("did update state")
        if delegate != nil {
            delegate?.updatePowerStatus(power: central.state == .poweredOn ? true : false)
        }
        if central.state == .poweredOn {
            if central.isScanning {
                central.stopScan()
            }
            print("starting scan")
//            let uuid_ = UUID(uuidString: uuid.uuidString)
//            print(central.retrievePeripherals(withIdentifiers: [uuid_!]))
//            print(central.retrieveConnectedPeripherals(withServices: [uuid]))
            if self.peripherals.count > 0 {
                self.connectToPeripherals()
            }
            central.scanForPeripherals(withServices: [uuid], options: nil)
            
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Snuggo requires bluetooth"
            content.body = "Please turn on bluetooth from settings"
            content.sound = UNNotificationSound.default
            content.badge = 1
            let notif = UNNotificationRequest(identifier: AppKeys.NO_BLUETOOTH_NOTIFICATION.rawValue, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(notif) { (error) in
               // print(error)
            }
            print("bluetooth is off")
            self.timer?.invalidate()
//            for (uuid, peripheral) in self.peripherals {
//                print("\(uuid), \(peripheral.state.rawValue)")
//            }
          //  self.cleanCurrentConnections()
            // show notification for bluetooth
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("restore state")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("peripheral found \(peripheral.name)")
        peripherals[peripheral.identifier] = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([uuid])
        print("Connected")
        semaphore.signal()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected \(error)")
        //peripheral.delegate = nil
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.connectToPeripherals()
            
        }
        
        //self.peripherals.removeValue(forKey: peripheral.identifier)
        //central.scanForPeripherals(withServices: [uuid], options: nil)
        semaphore.signal()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("fail to Connected")
        //central.scanForPeripherals(withServices: [uuid], options: nil)
        semaphore.signal()
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("connection event \(event)")
    }

}

// MARK: Peripheral Delegate
extension BluetoothScanner: CBPeripheralDelegate {
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        //remove timer
        print("peripherial \(peripheral.identifier) is ready")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("did discover services")
        guard let services = peripheral.services else { return }
        for service in services {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, for: thisService)
        }
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("included services")
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("descriptors")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for charateristic in characteristics {
            let thisCharacteristic = charateristic as CBCharacteristic
            peripheral.setNotifyValue(true, for: thisCharacteristic)
            print("peripheral can send data \(thisCharacteristic.properties)")
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                peripheral.readValue(for: thisCharacteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheril state changed")
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let data = characteristic.value, let json = String(bytes: data, encoding: .utf8)?.data(using: .utf8) {
            do {
                print(String(bytes: data, encoding: .utf8))
                seatData = try JSONDecoder().decode(SeatData.self, from: json)
                if let seatData = seatData, !seatData.hasError() {
                    notifSent = false
                }
                self.sendNotifications()
                if let seatData = seatData, delegate != nil {
                    delegate?.updateCarSeatSensorsData(seat: seatData)
                    if seatData.weight == 0 {
                        self.delegate?.childLeftCarSeat(left: true)
                    }
                    else {
                        self.delegate?.childLeftCarSeat(left: false)
                    }
                                        
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }
    }
    
    func sendNotifications() {
        guard !notifSent else {
            return
        }
        let errorMsg = seatData?.getErrorMessage()
        if let errorMsg = errorMsg  {
           let content = UNMutableNotificationContent()
           content.title = errorMsg.shortMessage
           content.body = errorMsg.longMessage
           content.sound = UNNotificationSound.default
           content.badge = 1
           let notif = UNNotificationRequest(identifier: "SnuggoError", content: content, trigger: nil)
           UNUserNotificationCenter.current().add(notif) { (error) in
              // print(error)
           }
           notifSent = true
        }
    }
}


