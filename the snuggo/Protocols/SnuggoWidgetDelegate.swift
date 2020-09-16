//
//  SnuggoWidgetDelegate.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation

protocol SnuggoWidgetDelegate: AnyObject {
    func updatePowerStatus(power: Bool)
    func updateCarSeatSensorsData(seat: SeatData)
    func childLeftCarSeat(left: Bool)
    func childLeftInCarSeat(left: Bool)
}
