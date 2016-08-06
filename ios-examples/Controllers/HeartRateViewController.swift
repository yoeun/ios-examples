//
//  DetailViewController.swift
//  ios-examples
//
//  Created by Yoeun Pen on 7/31/16.
//  Copyright © 2016 Yoeun Pen. All rights reserved.
//

import UIKit
import CoreBluetooth

class HeartRateViewController: UIViewController {
    let HRDeviceName = "TICKR"
    let HRServiceUUID = CBUUID(string: "180D")
    let HRCharacteristicUUID = CBUUID(string: "2A37")
    
    var centralManager: CBCentralManager!
    var sensor: CBPeripheral!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    
    var statusText: String {
        get {
            return statusLabel.text ?? ""
        }
        set {
            statusLabel.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HeartRateViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case .PoweredOn:
            statusText = "Searching for devices"
            central.scanForPeripheralsWithServices(nil, options: nil)
        default:
            statusText = "Not connected"
            //        case .PoweredOff: break
            //        case .Resetting: break
            //        case .Unauthorized: break
            //        case .Unknown: break
            //        case .Unsupported: break
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        let deviceName = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
        
        if (deviceName?.containsString(HRDeviceName) != nil) {
            statusText = "Sensor found and connecting"
            centralManager.stopScan()
            
            sensor = peripheral
            sensor.delegate = self
            centralManager.connectPeripheral(sensor, options: nil)
        } else {
            statusText = "Sensor NOT found"
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        statusText = "Discovering services in device"
        peripheral.discoverServices(nil)
    }
}

extension HeartRateViewController: CBPeripheralDelegate {
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let services = peripheral.services {
            for service in services {
                if service.UUID == HRServiceUUID {
                    peripheral.discoverCharacteristics(nil, forService: service)
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.UUID == HRCharacteristicUUID {
                    sensor.setNotifyValue(true, forCharacteristic: characteristic)
                    statusText = "Connected"
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if characteristic.UUID == HRCharacteristicUUID {
            if let data = characteristic.value {
                // See: https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml
                var values = [UInt8](count: data.length, repeatedValue:0)
                data.getBytes(&values, length: data.length)
                
                //                let flags = values[0]
                let bpm = values[1]
                
                bpmLabel.text = String(bpm)
            }
        }
    }
}
