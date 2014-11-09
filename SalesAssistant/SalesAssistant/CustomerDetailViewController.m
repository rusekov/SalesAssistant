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
    
    [self setLabels];
    [self showAnnotationOnMap];
    
}

-(void)viewWillAppear:(BOOL)animated{
    Customer *lastcustommer = [[[StaticCustomers customers] listOfCustommers] lastObject];
    if (self.currentCustomer.companyName == lastcustommer.companyName) {
        self.currentCustomer.turnover = lastcustommer.turnover;
        self.currentCustomer.dateOfLastUpdate = lastcustommer.dateOfLastUpdate;
        self.turnover.text = [NSString stringWithFormat:@"TURNOVER: %.2f BGN", self.currentCustomer.turnover];
        self.lastVisit.text = [NSString stringWithFormat:@"VISITED: %@",[NSDateFormatter localizedStringFromDate:self.currentCustomer.dateOfLastUpdate dateStyle:NSDateFormatterFullStyle timeStyle:(NSDateFormatterNoStyle)]];
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SetLabels

-(void)setLabels{
    self.title = self.currentCustomer.companyName;
    self.city.text = self.currentCustomer.city;
    self.address.text = self.currentCustomer.address;
    self.contactPerson.text = [NSString stringWithFormat:@"CONTACT: %@",self.currentCustomer.contactName];
    self.phone.text = [NSString stringWithFormat:@"PHONE: %@",self.currentCustomer.phoneNumber];
    self.turnover.text = [NSString stringWithFormat:@"TURNOVER: %.2f BGN", self.currentCustomer.turnover];
    self.lastVisit.text = [NSString stringWithFormat:@"VISITED: %@",[NSDateFormatter localizedStringFromDate:self.currentCustomer.dateOfLastUpdate dateStyle:NSDateFormatterFullStyle timeStyle:(NSDateFormatterNoStyle)]];
}

#pragma mark MKMapView Show Annotation

-(void)showAnnotationOnMap{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:(CLLocationCoordinate2DMake(self.currentCustomer.latitude, self.currentCustomer.longitude))];
    [annotation setTitle:self.currentCustomer.companyName]; //You can set the subtitle too
    [self.myMapView addAnnotation:annotation];
    [self.myMapView showAnnotations:[NSArray arrayWithObject:annotation] animated:YES];
}

#pragma mark phone call

- (IBAction)callPhone:(UILongPressGestureRecognizer *)sender {
    NSLog(@"call works only on real device");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.currentCustomer.phoneNumber]]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToOrder"]) {
        OrderViewController *ovc = [segue destinationViewController];
        [ovc setCurrentCustomer:self.currentCustomer];
    }
}

@end
