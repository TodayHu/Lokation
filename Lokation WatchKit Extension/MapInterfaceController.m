//
//  MapInterfaceController.m
//  Lokation
//
//  Created by Clint on 2/6/15.
//  Copyright (c) 2015 Clint Akins. All rights reserved.
//

#import "MapInterfaceController.h"




@interface MapInterfaceController()



@end


@implementation MapInterfaceController

- (void)awakeWithContext:(id)context {
  [super awakeWithContext:context];
  self.region = context;

  NSLog(@"%f",self.region.center.latitude);
  NSLog(@"%f",self.region.center.longitude);
  

  MKCoordinateRegion region = MKCoordinateRegionMake(self.region.center, MKCoordinateSpanMake(0.003, 0.003));
  [self.mapView setRegion:region];
  
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



