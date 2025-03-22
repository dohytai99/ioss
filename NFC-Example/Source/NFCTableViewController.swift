//
//  NFCTableViewController.swift
//  NFC-Example
//
//  Created by Hans Knöchel on 08.06.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import UIKit
import CoreNFC

// #warning: Ensure to set a use valid app-id / provisioning profile that includes NFC capabilities

class NFCTableViewController: UITableViewController {
    
    // Reference the NFC session
    private var nfcSession: NFCNDEFReaderSession!
    
    // Reference the found NFC messages
    private var nfcMessages: [[NFCNDEFMessage]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNFCSession()
    }
    
    private func startNFCSession() {
        // Create the NFC Reader Session when the app starts
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        
        // A custom description that helps users understand how they can use NFC reader mode in your app.
        self.nfcSession.alertMessage = "Bạn có thể đặt thẻ NFC vào phía sau iPhone"
        
        // Begin scanning
        self.nfcSession.begin()
    }
    
    @IBAction func restartScanning(_ sender: Any) {
        startNFCSession()
    }
    
    class func formattedTypeNameFormat(from typeNameFormat: NFCTypeNameFormat) -> String {
        switch typeNameFormat {
        case .empty:
            return "Empty"
        case .nfcWellKnown:
            return "NFC Well Known"
        case .media:
            return "Media"
        case .absoluteURI:
            return "Absolute URI"
        case .nfcExternal:
            return "NFC External"
        case .unchanged:
            return "Unchanged"
        default:
            return "Unknown"
        }
    }
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NFCTableViewController: NFCNDEFReaderSessionDelegate {
    
    // Called when the reader-session expired, you invalidated the dialog or accessed an invalidated session
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Lỗi đọc NFC: \(error.localizedDescription)")
    }
    
    // Called when a new set of NDEF messages is found
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("Đã phát hiện thẻ NFC mới:")
        
        for message in messages {
            for record in message.records {
                print("Định dạng tên: \(record.typeNameFormat)")
                print("Nội dung: \(record.payload)")
                print("Loại: \(record.type)")
                print("Định danh: \(record.identifier)")
            }
        }
        
        // Add the new messages to our found messages
        self.nfcMessages.append(messages)
        
        // Reload our table-view on the main-thread to display the new data-set
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension NFCTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.nfcMessages.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nfcMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numberOfMessages = self.nfcMessages[section].count
        let headerTitle = numberOfMessages == 1 ? "Một thông điệp" : "\(numberOfMessages) thông điệp"
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFCTableCell", for: indexPath)
        let nfcTag = self.nfcMessages[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = "\(nfcTag.records.count) bản ghi"
        
        return cell
    }
}
