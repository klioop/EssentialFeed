//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/08/01.
//

import UIKit
import NetworkModule

public final class ImageCommentCellController: CellController {
    let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        return cell
    }
    
    public func preload() {
        
    }
    
    public func cancelLoad() {
        
    }
}
