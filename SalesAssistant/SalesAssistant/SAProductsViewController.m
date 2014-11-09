//
//  ProductsViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "SAProductsViewController.h"

@interface SAProductsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation SAProductsViewController{
    NSMutableArray *items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = [[NSMutableArray alloc] init];

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

            self.results = [[NSMutableArray alloc] initWithCapacity:items.count];
            UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
            searchResultsController.tableView.dataSource = self;
            searchResultsController.tableView.delegate = self;
            
            self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
            
            self.searchController.searchResultsUpdater = self;
            
            self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
            
            self.tblView.tableHeaderView = self.searchController.searchBar;
            
            self.definesPresentationContext = YES;


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

#pragma mark Table View Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        return self.results.count;
    }
    else{
        return items.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    SAStockItem *currentItem;
    
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        currentItem = [self.results objectAtIndex:indexPath.row];
    }
    else{
        currentItem = [items objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = currentItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price: %.2f BGN",currentItem.price];
    
    return cell;
}

#pragma marks - UISearchResultUpdating Methods

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = [[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]];
    
    [self filterContentForSearchText:searchString scope:scope];
    
    [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
}

#pragma Filtering Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.results = [NSMutableArray arrayWithArray:[items filteredArrayUsingPredicate:predicate]];
}

@end
