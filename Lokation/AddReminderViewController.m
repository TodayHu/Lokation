//
//  AddReminderViewController.m
//  Lokation
//
//  Created by Clint on 2/4/15.
//  Copyright (c) 2015 Clint Akins. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderTextField;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self.reminderTextField becomeFirstResponder];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender {
  NSLog(@" long: %f lat: %f", self.annotation.coordinate.longitude, self.annotation.coordinate.latitude);
  [self.reminderTextField resignFirstResponder];
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.annotation.coordinate radius:50 identifier:self.reminderTextField.text];
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager.monitoredRegions allObjects];   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reminderAdded" object:self userInfo:@{@"Reminder" : region}];
    [self.navigationController popViewControllerAnimated:YES];
  }
}















@end
