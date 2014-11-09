//
//  CustomersViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "CustomersViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface CustomersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation CustomersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeReachability];

    [self sectionedList];
    self.title = @"CUSTOMERS";
    [[StaticCustomers customers] sortByNameCustomers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tabView reloadData];
}

#pragma mark Section Sort

- (IBAction)sortCustommers:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [[StaticCustomers customers] sortByNameCustomers];
            break;
        case 1:
            [[StaticCustomers customers] sortByTurnoverCustomers];
            break;
        case 2:
            [[StaticCustomers customers] sortByDateCustomers];
            break;
        default:
            break;
    }
    [self.tabView reloadData];
}

#pragma Table View Methods

- (NSArray*) sectionedList{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (NSString *town in [[StaticCustomers customers] cities]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city like %@", town];
        [list addObject:[[[StaticCustomers customers] listOfCustommers] filteredArrayUsingPredicate:predicate]];
    }
    return list;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self sectionedList].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Customer *c = [self sectionedList][section][0];
    return c.city;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *a = [self sectionedList][section];
    return a.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Customer *c = [self sectionedList][indexPath.section][indexPath.row];
    
    cell.textLabel.text = c.companyName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"turnover: %.2f BGN",c.turnover];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //Fetch current customer from core data
        Customer *c = [self sectionedList][indexPath.section][indexPath.row];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(companyName = %@)", c.companyName];
        [request setPredicate:pred];
        NSManagedObject *matches = nil;
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        //Update current customer data
        if ([objects count] == 0)
        {
            NSLog(@"No matches");
        }
        else
        {
            matches = objects[0];
            [[[StaticCustomers customers] listOfCustommers] removeObject:c];
            [context deleteObject:matches];
        }
        
        [context save:&error];
        [self.tblView reloadData];
        
        //saving deleted customer at background
        PFObject *dc = [PFObject objectWithClassName:@"DeletedCustomers"];
        dc[@"companyName"] = c.companyName;
        dc[@"city"] = c.city;
        dc[@"address"] = c.address;
        dc[@"contactPerson"] = c.contactName;
        dc[@"phoneNumber"] = c.phoneNumber;
        dc[@"turnover"] = [NSNumber numberWithDouble:c.turnover];
        dc[@"latitude"] = [NSNumber numberWithDouble:c.latitude];
        dc[@"longitude"] = [NSNumber numberWithDouble:c.longitude];
        [dc saveInBackground];

    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"goToDetails"]) {
        CustomerDetailViewController *cmvc = [segue destinationViewController];
        NSIndexPath *path = [self.tblView indexPathForSelectedRow];
        
        Customer *selectedCustommer = [self sectionedList][path.section][path.row];
        [cmvc setCurrentCustomer:selectedCustommer];
        
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
    }
}

#pragma mark Reachability methods

-(void)observeReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    if ([curReach connectionRequired])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IMPORTANT" message:@"This app needs internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end