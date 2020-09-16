//
//  ViewController.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/5/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import UIKit

class ProductDashboard: UIViewController {
    
    @IBOutlet weak var pager: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var powerSettings: BluetoothPowerControl!
    @IBOutlet weak var autoMode: AutoModeDisplay!
    @IBOutlet weak var carSeat: CarSeatDisplay!
    @IBOutlet weak var temperature: TemperatureDisplay!
    
    var product: Product?
    var snuggoError: SnuggoError = .NONE
    let cellid1 = "cell-id1"
    let cellid2 = "cell-id2"
    let cellid3 = "cell-id3"
    var seat: SeatData?
    var current = 0
    var timer: Timer?
    var notifSent = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton.customButton(image: #imageLiteral(resourceName: "back-arrow").withRenderingMode(.alwaysTemplate), tintColor: .white, selector: #selector(popViewController), target: self))
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "TheSnuggoLogowhiteSmall"))
        collectionView.register(SeatBeltCell.self, forCellWithReuseIdentifier: cellid1)
        collectionView.register(WeightCell.self, forCellWithReuseIdentifier: cellid2)
        collectionView.register(ErrorCell.self, forCellWithReuseIdentifier: cellid3)
        collectionView.isPagingEnabled = true
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0
        BluetoothScanner.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPager()
    }
    
    func loadPager() {
        self.pager.isHidden = false
        let _ = self.pager.subviews.map { $0.alpha = 0.6 }
        self.pager.subviews[current % 2].alpha = 1
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: Snuggo Widget Delegate
extension ProductDashboard: SnuggoWidgetDelegate {
    
    func childLeftCarSeat(left: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.snuggoError = (left ? SnuggoError.ChildLeftCarSeat : (self?.snuggoError == .ChildLeftCarSeat ? .NONE : self?.snuggoError ))!
            self?.updateUI()
            if left {
                if let isvalid = self?.timer?.isValid, isvalid { return }
                self?.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (_) in
                    BluetoothScanner.shared.stopScanning()
                })
            }
            else {
                self?.timer?.invalidate()
            }
        }
        
    }
    
    func childLeftInCarSeat(left: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.snuggoError = (left ? SnuggoError.ChildLeftInSeat : (self?.snuggoError == .ChildLeftInSeat ? .NONE : self?.snuggoError ))!
            self?.updateUI()
        }
    }
    
    func updatePowerStatus(power: Bool) {
        self.powerSettings.setPowerState(on: power)
        self.autoMode.setPowerState(on: power)
        self.carSeat.setCardSeat(powerDown: !power, otherError: false)
        if let seat = self.seat {
            self.temperature.setTemperature(temperature: seat.temperature, error: seat.checkError(snuggoError: .TemperatrueError))
        }
    }
    
    func updateCarSeatSensorsData(seat: SeatData) {
        self.seat = seat
        if seat.checkError(snuggoError: .SeatBeltError) {
            snuggoError = .SeatBeltError
            if let errorMessage = seat.getErrorMessage(type: .SeatBeltError), !notifSent {
                NotificationManager.sendNotifications(title: errorMessage.shortMessage, message: errorMessage.longMessage, type: .SEAT_BELT)
                notifSent = true
            }
        }
        else if seat.checkError(snuggoError: .WeightError) {
            snuggoError = .WeightError
            if let errorMessage = seat.getErrorMessage(type: .WeightError), !notifSent {
                NotificationManager.sendNotifications(title: errorMessage.shortMessage, message: errorMessage.longMessage, type: .WEIGHT)
                notifSent = true
            }
        }
        else if seat.checkError(snuggoError: .TemperatrueError) {
            snuggoError = .TemperatrueError
            if let errorMessage = seat.getErrorMessage(type: .TemperatrueError), !notifSent {
                NotificationManager.sendNotifications(title: errorMessage.shortMessage, message: errorMessage.longMessage, type: .TEMPERATURE)
                notifSent = true
            }
        }
        else {
            notifSent = false
            snuggoError = .NONE
        }
        self.updateUI()
    }
    
   
    
    func updateUI() {
        if let seat_ = self.seat {
            self.powerSettings.setPowerState(on: true)
            self.autoMode.setPowerState(on: true)
            self.carSeat.setCardSeat(powerDown: false, otherError: snuggoError != .NONE && snuggoError != .TemperatrueError)
            self.temperature.setTemperature(temperature: seat_.temperature, error: snuggoError == .TemperatrueError)
            self.collectionView.reloadData()
        }
        else {
            self.powerSettings.setPowerState(on: false)
            self.autoMode.setPowerState(on: false)
        }
    }
}

// MARK: Collection view delegate and data source
extension ProductDashboard: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard seat != nil else {
            return 0
        }
        if snuggoError != .NONE && snuggoError == .WeightError {
            return 3
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let seat = self.seat else { return UICollectionViewCell() }
        switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid1, for: indexPath) as! SeatBeltCell
                cell.data = self.product
                cell.error = seat.getErrorMessage(type: snuggoError)
                return cell
            case 1:
                if snuggoError == .NONE || snuggoError == .WeightError {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! WeightCell
                    cell.error = seat.getErrorMessage(type: snuggoError)
                    cell.data = self.seat
                    return cell
                }
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! ErrorCell
                    cell.error = seat.getErrorMessage(type: snuggoError)
                    return cell
                }
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! ErrorCell
                cell.error = seat.getErrorMessage(type: snuggoError)
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
