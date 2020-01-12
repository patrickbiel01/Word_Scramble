//
//  Word_Scrambler_Patrick_BielTests.swift
//  Word_Scrambler_Patrick_BielTests
//
//  Created by Patrick Biel on 2019-02-05.
//  Copyright © 2019 Patrick Biel. All rights reserved.
//

import XCTest
@testable import Word_Scrambler_Patrick_Biel

class Word_Scrambler_Patrick_BielTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSort() {
        var entries = Entries()
        
        //Test # 1
        entries.entries = [Entry(name: "Patrick", score: 100),Entry(name: "000Patrick", score: 1000000), Entry(name: "Patrffvick", score: 1)]
        entries = entries.sort()
        let rightAnswer1 = [Entry(name: "000Patrick", score: 1000000), Entry(name: "Patrick", score: 100), Entry(name: "Patrffvick", score: 1)]
        XCTAssert(entries.entries == rightAnswer1, "Test # 1 Failed")
        
        //Test # 2
        entries.entries = [Entry(name: "PatrickBiel", score: 10),Entry(name: "Patrick Biel", score: 10), Entry(name: "Patrick B", score: 15)]
        entries = entries.sort()
        let rightAnswer2 = [Entry(name: "Patrick B", score: 15), Entry(name: "PatrickBiel", score: 10), Entry(name: "Patrick Biel", score: 10)]
        XCTAssert(entries.entries == rightAnswer2, "Test # 2 Failed")
        
    }
    
}
