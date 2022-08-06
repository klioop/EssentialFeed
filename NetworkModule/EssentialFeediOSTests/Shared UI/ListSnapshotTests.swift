//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/08/06.
//

import XCTest
import EssentialFeediOS

class ListSnapshotTests: XCTestCase {
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a \nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_DARK")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSize: .extraExtraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE_DARK_extraExtraExtraLarge")
    } 
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsHorizontalScrollIndicator = false
        controller.tableView.showsVerticalScrollIndicator = false
        return controller
    }
}
