//
//  MapInterfaceController.h
//  Lokation
//
//  Created by Clint on 2/6/15.
//  Copyright (c) 2015 Clint Akins. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MapInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceMap *mapView;
@property (strong, nonatomic) CLCircularRegion *region;

@end
