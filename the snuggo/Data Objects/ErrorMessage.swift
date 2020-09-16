//
//  File.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation

struct ErrorMessage {
    let shortMessage, longMessage: String
}

enum SnuggoError: Error {
    case PowerDown, WeightError, TemperatrueError, ChildLeftCarSeat, ChildLeftInSeat, SeatBeltError, NONE
}
