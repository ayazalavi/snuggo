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
    var current = 0
    var animating = false
    var seatError, weightError, tempError, childLeftIn, childLeftSeat: SnuggoError?
    let cellid1 = "cell-id1"
    let cellid2 = "cell-id2"
    let cellid3 = "cell-id3"
    var seat: SeatData?
    var errorMessage: ErrorMessage?
    var timer: Timer?
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
    
    @objc func gotoCameraScreen() {
        self.performSegue(withIdentifier: "camera", sender: self)
    }
    
}

// MARK: Snuggo Widget Delegate
extension ProductDashboard: SnuggoWidgetDelegate {
    
    func childLeftCarSeat(left: Bool) {
        childLeftSeat = left ? SnuggoError.ChildLeftCarSeat : nil
        self.updateUI()
        
        if left {
            if let isvalid = timer?.isValid, isvalid { return }
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (_) in
                BluetoothScanner.shared.stopScanning()
            })
        }
        else {
            timer?.invalidate()
        }
        
//        self.errorMessage = ErrorMessage(shortMessage: "CHILD LEFT SEAT", longMessage: "Your child has left their car seat. If this was intentional then the SMART system will switch off in 60 seconds.")
//        self.collectionView.reloadData()
    }
    
    func childLeftInCarSeat(left: Bool) {
        childLeftIn = left ? SnuggoError.ChildLeftInSeat : nil
        self.updateUI()
//        self.errorMessage = ErrorMessage(shortMessage: "CHILD LEFT IN SEAT", longMessage: "Your child is still in the car seat, please ensure a responsible adult is with the child.")
//        self.collectionView.reloadData()
    }
    
    func updatePowerStatus(power: Bool) {
        self.powerSettings.setPowerState(on: power)
        self.autoMode.setPowerState(on: power)
        self.carSeat.setCardSeat(powerDown: !power, otherError: false)
        if let seat = self.seat {
            self.temperature.setTemperature(temperature: seat.temperature, error: seat.getError(snuggoError: SnuggoError.TemperatrueError(temperature: 10)))
        }
    }
    
    func updateCarSeatSensorsData(seat: SeatData) {
        self.seat = seat
        seatError = seat.getError(snuggoError: SnuggoError.SeatBeltError(seat: seat))
        weightError = seat.getError(snuggoError: SnuggoError.WeightError(weight: seat.weight))
        tempError = seat.getError(snuggoError: SnuggoError.TemperatrueError(temperature: seat.temperature))
        self.updateUI()
        //self.collectionView.reloadData()
    }
    
   
    
    func updateUI() {
        if let seat_ = self.seat {
            self.carSeat.setCardSeat(powerDown: false, otherError: seatError != nil || weightError != nil || childLeftIn != nil || childLeftSeat != nil)
            self.temperature.setTemperature(temperature: seat_.temperature, error: tempError)
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
        guard let _ = seat else {
            return 0
        }
        if weightError != nil {
            return 3
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let seat = self.seat else {
            return UICollectionViewCell()
        }
        switch indexPath.item {
            case 2:
                if seat.hasError() && weightError != nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! ErrorCell
                    cell.error = seat.getErrorMessage()
                    return cell
                }
            case 1:
                if (seat.hasError() && weightError != nil) || !seat.hasError() {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! WeightCell
                    cell.error = seat.getErrorMessage()
                    cell.data = self.seat
                    return cell
                }
                else if seat.hasError() || childLeftIn != nil || childLeftSeat != nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! ErrorCell
                    if childLeftSeat != nil {
                        cell.error = ErrorMessage(shortMessage: "CHILD LEFT SEAT", longMessage: "Your child has left their car seat. If this was intentional then the SMART system will switch off in 60 seconds.")
                    } else if childLeftIn != nil {
                        cell.error = ErrorMessage(shortMessage: "CHILD LEFT IN SEAT", longMessage: "Your child is still in the car seat, please ensure a responsible adult is with the child.")
                    }
                    else {
                        cell.error = seat.getErrorMessage()
                    }
                    return cell
                }
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid1, for: indexPath) as! SeatBeltCell
                cell.backgroundImage.image = UIImage(named: self.product!.photo)
                cell.data = self.product
                cell.error = seat.getErrorMessage()
                return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
