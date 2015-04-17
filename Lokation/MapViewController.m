//
//  MapViewController.m
//  Lokation
//
//  Created by Clint on 2/3/15.
//  Copyright (c) 2015 Clint Akins. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h> 
#import <CoreLocation/CoreLocation.h>
#import "AddReminderViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *selectedAnnotation;

@end

@implementation MapViewController

//MARK:ViewDidLoad
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderAdded:) name:@"reminderAdded" object:nil];
  self.mapView.delegate = self;
  self.mapView.mapType = MKMapTypeHybrid;
  self.mapView.zoomEnabled = true;
  
  NSLog(@" %lu",(unsigned long)self.locationManager.monitoredRegions.count);
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  if ([CLLocationManager locationServicesEnabled]) {
    NSLog(@"Authorization status = %d", [CLLocationManager authorizationStatus]);
    
    if ([CLLocationManager authorizationStatus] == 0) {
      [self.locationManager requestAlwaysAuthorization];
    } else {
      self.mapView.showsUserLocation = true;
      self.mapView.showsPointsOfInterest = true;
      [self.locationManager startMonitoringSignificantLocationChanges];
    }
  }
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressed:)];
  
  [self.mapView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//MARK: MapLongPress/Location Manager

- (void)mapLongPressed:(id) sender {
  UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
  if (longPress.state == 3) {
    CGPoint location = [longPress locationInView:self.mapView];
    NSLog(@"location y: %f location x: %f", location.y, location.x);
    CLLocationCoordinate2D coordinates = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    NSLog(@"coordinate long: %f coordinate lat x: %f", coordinates.longitude, coordinates.latitude);
    
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinates;
    annotation.title = @"New Location";
    [self.mapView addAnnotation:annotation];
  }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSLog(@" the new status is %d", status);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.firstObject;
  NSLog(@"latitude: %f and longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isEqual:[self.mapView userLocation]]) {
    return nil;
  }
  MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  annotationView.animatesDrop = true;
  annotationView.pinColor = MKPinAnnotationColorGreen;
  annotationView.canShowCallout = true;
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
  return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
  self.selectedAnnotation = view.annotation;
  [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:self];
}

//MARK: DidEnterRegion

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"Did enter region");
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  localNotification.alertBody = @"Check your reminder";
  localNotification.alertAction = @"Region action";
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void) reminderAdded:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
  CLCircularRegion *region = userInfo[@"Reminder"];
  MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
  [self.mapView addOverlay:circleOverlay];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  circleRenderer.fillColor = [UIColor greenColor];
  circleRenderer.alpha = 0.3;
  return circleRenderer;
}



//MARK: IBAction methods

- (IBAction)schoolButtonPressed:(UIButton *)sender {
  CLLocationCoordinate2D schoolCoord = CLLocationCoordinate2DMake(47.623573, -122.336016);
  MKCoordinateRegion schoolRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(schoolCoord, 50, 50)];
  [self.mapView setRegion: schoolRegion animated:true];
}

- (IBAction)homeButtonPressed:(UIButton *)sender {
  CLLocationCoordinate2D homeCoord = CLLocationCoordinate2DMake(37.331741, -122.030333);
  MKCoordinateRegion homeRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(homeCoord, 50, 50)];
  [self.mapView setRegion: homeRegion animated:true];
}

- (IBAction)surfButtonPressed:(UIButton *)sender {
  CLLocationCoordinate2D surfCoord = CLLocationCoordinate2DMake(46.905129, -124.122554);
  MKCoordinateRegion surfRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(surfCoord, 500, 500)];
  [self.mapView setRegion: surfRegion animated:true];
}


//MARK:Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SHOW_DETAIL"]) {
    AddReminderViewController *addReminderVC = (AddReminderViewController *)segue.destinationViewController;
    addReminderVC.annotation = self.selectedAnnotation;
    addReminderVC.locationManager = self.locationManager;
  }
}


-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
