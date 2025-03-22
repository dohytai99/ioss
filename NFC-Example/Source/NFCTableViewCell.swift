//
//  NFCTableViewCell.swift
//  NFC-Example
//
//  Created by Hans Knöchel on 12.06.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import UIKit

class NFCTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        detailTextLabel?.font = .systemFont(ofSize: 14)
        detailTextLabel?.textColor = .gray
        accessoryType = .disclosureIndicator
    }
    
    func configure(with record: NFCNDEFPayload) {
        let typeNameFormat = String(describing: record.typeNameFormat)
        let payload = String(data: record.payload, encoding: .utf8) ?? "Không thể đọc nội dung"
        
        textLabel?.text = typeNameFormat
        detailTextLabel?.text = payload
    }
}
