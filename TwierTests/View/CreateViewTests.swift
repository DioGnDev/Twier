//
//  CreateViewTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import SwiftUI

final class CreateViewTests: XCTestCase {
  
  var sut: CreatePresenter!
  
  func test_initPresenter() {
    //given
    let datasource = MockCreateLocalDataSourceFailed()
    let interactor = MockCreateInteractorImpl(dataSource: datasource)
    
    //when
    sut = CreatePresenter(interactor: interactor)
    
    //then
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.errorMessage, "")
  }
  
  func test_createPostAndSaveToCoredata_andReturnFailed(){
    //given
    let datasource = MockCreateLocalDataSourceFailed()
    let interactor = MockCreateInteractorImpl(dataSource: datasource)
    let expectation = expectation(description: "promise...")
    sut = CreatePresenter(interactor: interactor)
    
    //when
    sut.create()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
      expectation.fulfill()
    }
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.errorMessage, "Error")
    XCTAssertFalse(sut.isSuccess)
    
  }
  
}
