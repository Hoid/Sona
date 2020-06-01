//
//  BroadcastSearchFilterHelperTests.swift
//  SonaTests
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import XCTest
@testable import Sona

class BroadcastSearchFilterHelperTests: XCTestCase {
    
    var broadcastSearchFilterHelper = BroadcastSearchFilterHelper(broadcasts: [
        Broadcast(
            song: Song(id: "1", title: "November Rain", artist: "Guns N' Roses"),
            user: User(username: "sylphrenetic")
        ),
        Broadcast(
            song: Song(id: "2", title: "How To Disappear Completely", artist: "Radiohead"),
            user: User(username: "sylphrenetic")
        ),
        Broadcast(
            song: Song(id: "3", title: "Kids", artist: "MGMT"),
            user: User(username: "other_username")
        )
    ])

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFilterForSpecificSong() throws {
        let filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: "Nov")
        XCTAssert(filteredBroadcasts.count == 1)
        XCTAssert(filteredBroadcasts[0].song.title == "November Rain")
    }
    
    func testWillFilterForSpecificArtist() throws {
        let filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: "Rad")
        XCTAssert(filteredBroadcasts.count == 1)
        XCTAssert(filteredBroadcasts[0].song.artist == "Radiohead")
    }
    
    func testWillFilterForSpecificUsername() throws {
        let filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: "syl")
        XCTAssert(filteredBroadcasts.count == 2)
        XCTAssert(filteredBroadcasts[0].user.username == "sylphrenetic")
        XCTAssert(filteredBroadcasts[1].user.username == "sylphrenetic")
    }
    
    func testWillNotReturnAnythingForNoMatches() throws {
        let filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: "ski")
        XCTAssert(filteredBroadcasts.count == 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
