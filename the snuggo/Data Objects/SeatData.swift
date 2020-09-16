//
//  SeatData.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation

struct SeatData: Decodable {
    let belt_1, belt_2, belt_3, belt_4, belt_5, belt_6: Bool
    let weight, temperature: Int
    
    enum KEYS: String, CodingKey {
        case BELTSENSOR_1, BELTSENSOR_2, BELTSENSOR_3, BELTSENSOR_4, BELTSENSOR_5, BELTSENSOR_6, WEIGHTSENSOR, TEMPERATURESENSOR
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: KEYS.self)
        self.belt_1 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_1)
        self.belt_2 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_2)
        self.belt_3 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_3)
        self.belt_4 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_4)
        self.belt_5 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_5)
        self.belt_6 = try values.decode(Bool.self, forKey: KEYS.BELTSENSOR_6)
        self.weight = try values.decode(Int.self, forKey: KEYS.WEIGHTSENSOR)
        self.temperature = try values.decode(Int.self, forKey: KEYS.TEMPERATURESENSOR)
    }
    
    func checkError(snuggoError: SnuggoError) -> Bool {
        switch snuggoError {
            case SnuggoError.SeatBeltError:
                if !belt_1 || !belt_2 || !belt_3 || !belt_4 || !belt_5 || !belt_6 {
                    return true
                }
            case SnuggoError.WeightError:
                if self.weight > 0 && (self.weight < 13 || self.weight > 18) {
                    return true
                }
            case SnuggoError.TemperatrueError:
                if self.temperature < 5 || self.temperature > 27 {
                    return true
                }
            default:
                return false
        }
        return false
    }
    
    func hasError() -> Bool {
        if !belt_1 || !belt_2 || !belt_3 || !belt_4 || !belt_5 || !belt_6 {
            return true
        }
        else if self.weight == 0 || self.weight < 13 || self.weight > 18 {
            return true
        }
        else if self.temperature < 5 || self.temperature > 27 {
            return true
        }
        return false
    }
    
    func getErrorMessage(type: SnuggoError) -> ErrorMessage? {
        switch type {
            case SnuggoError.SeatBeltError:
                if !belt_1 || !belt_2 {
                    return ErrorMessage(shortMessage: "Car seat not installed correctly", longMessage: "The Car seat belt is not installed correctly on the bottom right side of your child’s car seat\n\nFor installation video guide")
                }
                else if !belt_3 || !belt_4 {
                        return ErrorMessage(shortMessage: "Car seat not installed correctly", longMessage: "The Car seat belt is not installed correctly on the bottom left side of your child’s car seat\n\nFor installation video guide")
                }
                else if !belt_5 {
                        return ErrorMessage(shortMessage: "Car seat not installed correctly", longMessage: "The Car seat belt is not installed correctly on the back side of your child’s car seat\n\nFor installation video guide")
                }
                else if !belt_6 {
                        return ErrorMessage(shortMessage: "Car seat not installed correctly", longMessage: "The Car seat belt is not installed correctly on the front side of your child’s car seat\n\nFor installation video guide")
                }
            case SnuggoError.WeightError:
                if self.weight < 13{
                    return ErrorMessage(shortMessage: "WRONG CAR SEAT TYPE", longMessage: "Your child has is too small for their car seat, please consider upgrading your car seat suitable for your child.\n\nFor a full range of car seats")
                }
                else if self.weight > 18 {
                    return ErrorMessage(shortMessage: "WRONG CAR SEAT TYPE", longMessage: "Your child has outgrown their car seat, please consider upgrading your car seat suitable for your child.\n\nFor a full range of car seats")
                }
            case SnuggoError.TemperatrueError:
                if self.temperature < 5  {
                    return ErrorMessage(shortMessage: "LOW TEMPERATURE", longMessage: "The temperature around your child’s car seat is very low.\n\nFor top tips on keeping your child cool")
                }
                else if self.temperature > 27 {
                    return ErrorMessage(shortMessage: "HIGH TEMPERATURE", longMessage: "The temperature around your child’s car seat is very high,\nChildren overheat 5 times faster than adults in hot weather and are particularly vulnerable.\n\nFor top tips on keeping your child cool")
                }
            case SnuggoError.ChildLeftInSeat:
                return ErrorMessage(shortMessage: "CHILD LEFT IN SEAT", longMessage: "Your child is still in the car seat, please ensure a responsible adult is with the child.")
            case SnuggoError.ChildLeftCarSeat:
                return ErrorMessage(shortMessage: "CHILD LEFT SEAT", longMessage: "Your child has left their car seat. If this was intentional then the SMART system will switch off in 60 seconds.")
            default:
                return nil
        }
        return nil
    }
    
}
