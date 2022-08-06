//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/08/01.
//

import XCTest
import EssentialFeediOS
@testable import NetworkModule

class ImageCommentsSnapshotTests: XCTestCase {
    
    func test_listWithComments() {
        let sut = makeSUT()
        
        sut.display(comments())
        
        assert (snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func comments() -> [CellController] {
        commentControllers().map { CellController($0) }
    }
    
    private func commentControllers() -> [ImageCommentCellController] {
        [
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "ontrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC.",
                date: "1000 years ago",
                username: "a long long long long long username")),
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of  45 BC.",
                date: "10 days ago",
                username: "a username")),
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "nice",
                date: "1 hour ago",
                username: "a."))
        ]
    }
}
