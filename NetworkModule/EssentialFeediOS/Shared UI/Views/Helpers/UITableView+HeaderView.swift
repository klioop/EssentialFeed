//
//  UITableView+HeaderView.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/08/01.
//

import UIKit

extension UITableView {
    func sizeTableHaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
