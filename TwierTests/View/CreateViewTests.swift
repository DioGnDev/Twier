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
    sut = CreatePresenter(interactor: interactor,
                          userSession: UserSession(),
                          router: CreateRouter())
    
    //then
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.errorMessage, "")
  }
  
  func test_createPostAndSaveToCoredata_andReturnFailed(){
    //given
    let datasource = MockCreateLocalDataSourceFailed()
    let interactor = MockCreateInteractorImpl(dataSource: datasource)
    let expectation = expectation(description: "promise...")
    sut = CreatePresenter(interactor: interactor,
                          userSession: UserSession(),
                          router: CreateRouter())
    
    //when
    sut.create(completion: {})
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
      expectation.fulfill()
    }
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertFalse(sut.isLoading)
    XCTAssertEqual(sut.errorMessage, "Database Error")
    XCTAssertFalse(sut.isSuccess)
    
  }
  
}
