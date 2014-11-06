//
//  CustomerDetailViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "CustomerDetailViewController.h"

@interface CustomerDetailViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *contactPerson;
@property (weak, nonatomic) IBOutlet UILabel *lastVisit;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *turnover;

@end

@implementation CustomerDetailViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.currentCustomer.companyName;
    self.city.text = self.currentCustomer.city;
    self.address.text = self.currentCustomer.address;
    self.contactPerson.text = [NSString stringWithFormat:@"CONTACT: %@",self.currentCustomer.contactName];
    self.phone.text = [NSString stringWithFormat:@"PHONE: %@",self.currentCustomer.phoneNumber];
    self.turnover.text = [NSString stringWithFormat:@"TURNOVER: %.2f BGN", self.currentCustomer.turnover];
    self.lastVisit.text = [NSString stringWithFormat:@"VISITED: %@",[NSDateFormatter localizedStringFromDate:self.currentCustomer.dateOfLastUpdate dateStyle:NSDateFormatterFullStyle timeStyle:(NSDateFormatterNoStyle)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self.myMapView setRegion:MKCoordinateRegionMake(
                                                     CLLocationCoordinate2DMake(self.currentCustomer.latitude, self.currentCustomer.longitude), MKCoordinateSpanMake(0.002f, 0.002f)) animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToOrder"]) {
    OrderViewController *ovc = [segue destinationViewController];
    [ovc setCurrentCustomer:self.currentCustomer];
    }
}

@end
