//
//  OrderViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "SAOrderViewController.h"
#import "AppDelegate.h"

@interface SAOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation SAOrderViewController{
    NSMutableArray *items;
    NSMutableArray *purchasedItems;
    double totalVal;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self becomeFirstResponder];
    items = [[NSMutableArray alloc] init];
    purchasedItems = [[NSMutableArray alloc] init];
    totalVal = 0;
    
    self.title = self.currentCustomer.companyName;
    self.totalValue.text = [NSString stringWithFormat:@"Total: %.2f BGN", totalVal];
    
    PFQuery *query = [PFQuery queryWithClassName:@"StockItem"];
    [query orderByAscending:@"price"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                SAStockItem *item = [[SAStockItem alloc] init];
                item.name = object[@"name"];
                item.price = [object[@"price"] floatValue];
                [items addObject:item];
            }
            [self.tblView reloadData];
            SAToast *toast = [SAToast toastWithMessage:@"Products loaded" andColor:[UIColor blueColor]];
            [toast showOnView:self.view];

        } else {
            // Log details of the failure
            SAToast *toast = [SAToast toastWithMessage:@"Error loading products" andColor:[UIColor redColor]];
            [toast showOnView:self.view];
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Accelerometer and Shake Gesture methods

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"CLEAR THE ORDER" message:nil delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"CLEAR", nil];
        [allert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [purchasedItems removeAllObjects];
        totalVal = 0;
        self.totalValue.text = [NSString stringWithFormat:@"Total: %.2f BGN", totalVal];
    }
}

#pragma mark Add Product methods

- (IBAction)addProduct:(UIButton *)sender {
    NSArray *selectedIndexPaths = [self.tblView indexPathsForSelectedRows];
    for (int i = 0; i < selectedIndexPaths.count; i++) {
        NSIndexPath* path = selectedIndexPaths[i];
        SAStockItem *currentItem =items[path.row];
        [purchasedItems addObject:currentItem];
        totalVal += currentItem.price;
        [self.tblView deselectRowAtIndexPath:[self.tblView indexPathForSelectedRow] animated:YES];
        [self.tblView reloadData];
    }
    self.totalValue.text = [NSString stringWithFormat:@"Total: %.2f BGN", totalVal];
}

- (IBAction)done:(UIButton *)sender {
    
    //Fetch current customer from core data
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(companyName = %@)", self.currentCustomer.companyName];
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
        [[[SAStaticCustomers customers] listOfCustommers] removeObject:self.currentCustomer];
        self.currentCustomer.dateOfLastUpdate = [[NSDate alloc] init];
        self.currentCustomer.turnover += totalVal;
        [matches setValue: self.currentCustomer.dateOfLastUpdate forKey:@"dateOfLastUpdate"];
        //test only
        [matches setValue: [NSNumber numberWithDouble:self.currentCustomer.turnover] forKey:@"turnover"];
        [[[SAStaticCustomers customers] listOfCustommers] addObject:self.currentCustomer];
    }
    
    [context save:&error];
    
    //Sending sales to the database
    for (int i = 0; i < purchasedItems.count; i++) {
        
        SAStockItem *item = purchasedItems[i];
        
        PFObject *sale = [PFObject objectWithClassName:@"Sales"];
        sale[@"company"] = self.currentCustomer.companyName;
        sale[@"city"] = self.currentCustomer.city;
        sale[@"address"] = self.currentCustomer.address;
        sale[@"item"] = item.name;
        sale[@"price"] = [NSNumber numberWithDouble:item.price];
        [sale saveInBackground];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TableView Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return items.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = ((SAStockItem *)[items objectAtIndex:indexPath.row]).name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price: %.2f BGN",((SAStockItem *)[items objectAtIndex:indexPath.row]).price];
    return cell;
}

@end
