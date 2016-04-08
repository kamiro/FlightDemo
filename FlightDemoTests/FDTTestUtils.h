//
//  FDTTestUtils.h
//  FlightDemo
//
//  Created by Gary Morrison on 4/7/16.
//  Copyright © 2016 Gary Morrison. All rights reserved.
//

#ifndef FDTTestUtils_h
#define FDTTestUtils_h

#define FDTTestNilThenSet(property, value) XCTAssertNil(property); property = value; XCTAssertEqual(property, value);

#endif /* FDTTestUtils_h */
