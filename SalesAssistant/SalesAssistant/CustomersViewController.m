//
//  CustomersViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "CustomersViewController.h"

@interface CustomersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation CustomersViewController{
    NSString * sofia;
    NSString * plovdiv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // creating test Customers
    sofia = @"Sofia";
    plovdiv = @"Plovdiv";
    
    Customer *c1 = [[Customer alloc] init];
    Customer *c2 = [[Customer alloc] init];
    Customer *c3 = [[Customer alloc] init];
    Customer *c4 = [[Customer alloc] init];
    
    c1.companyName = @"Fantastico";
    c1.contactName = @"Pesho";
    c1.address = @"bul. Bulgaria 131";
    c1.city = sofia;
    c1.turnover = 1000;
    c1.dateOfLastUpdate = [NSDate date];
    c1.phoneNumber = @"0888840880";
    
    c2.companyName = @"Billa";
    c2.contactName = @"Mitaka";
    c2.address = @"ul. Akademik Stoyan Argirov 39";
    c2.city = sofia;
    c2.turnover = 2000;
    c2.dateOfLastUpdate = [NSDate date];
    c2.phoneNumber = @"0888840881";
    
    c3.companyName = @"Picadilly";
    c3.contactName = @"Gogo";
    c3.address = @"bul. Alaksander Stamboliiski 195a";
    c3.city = sofia;
    c3.turnover = 800;
    c3.dateOfLastUpdate = [NSDate date];
    c3.phoneNumber = @"0888840882";

    c4.companyName = @"Lidl";
    c4.contactName = @"Penka";
    c4.address = @"ploshtad Makedonia 2";
    c4.city = plovdiv;
    c4.turnover = 6000;
    c4.dateOfLastUpdate = [NSDate date];
    c4.phoneNumber = @"0888840883";
    
    [[[StaticCustomers customers] listOfCustommers] addObject:c1];
    [[[StaticCustomers customers] listOfCustommers] addObject:c2];
    [[[StaticCustomers customers] listOfCustommers] addObject:c3];
    [[[StaticCustomers customers] listOfCustommers] addObject:c4];
    
    
    [self sectionedList];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tabView reloadData];
}

- (NSArray*) sectionedList{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (NSString *town in [[StaticCustomers customers] cities]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city like %@", town];
        [list addObject:[[[StaticCustomers customers] listOfCustommers] filteredArrayUsingPredicate:predicate]];
    }
    return list;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

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

    
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"goToDetails"]) {
        CustomerDetailViewController *cmvc = [segue destinationViewController];
        NSIndexPath *path = [self.tblView indexPathForSelectedRow];
        
        Customer *selectedCustommer = [self sectionedList][path.section][path.row];
        [cmvc setCurrentCustomer:selectedCustommer];
    }
}
@end