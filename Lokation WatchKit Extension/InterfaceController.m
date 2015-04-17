//
//  InterfaceController.m
//  Lokation WatchKit Extension
//
//  Created by Clint on 2/5/15.
//  Copyright (c) 2015 Clint Akins. All rights reserved.
//

#import "InterfaceController.h"
#import "ReminderRowController.h"
#import <CoreLocation/CoreLocation.h>
#import "MapInterfaceController.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *regionsTable;
@property (strong, nonatomic) NSArray *regionsArray;


@end


@implementation InterfaceController 

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  NSSet *regions = locationManager.monitoredRegions;
  self.regionsArray = regions.allObjects;
  
  
  [self.regionsTable setNumberOfRows:self.regionsArray.count withRowType:@"ReminderRowController"];
  NSInteger index = 0;
  for (CLCircularRegion *region in self.regionsArray) {
    ReminderRowController *rowController = [self.regionsTable rowControllerAtIndex:index];
    [rowController.regionsLabel setText:region.identifier];
    index++;
  }
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
  return self.regionsArray[rowIndex];
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



