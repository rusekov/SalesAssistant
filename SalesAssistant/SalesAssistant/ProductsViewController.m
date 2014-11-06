//
//  ProductsViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "ProductsViewController.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController{
    NSMutableArray *items;
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StockItem *i1 = [[StockItem alloc] init];
    StockItem *i2 = [[StockItem alloc] init];
    StockItem *i3 = [[StockItem alloc] init];
    StockItem *i4 = [[StockItem alloc] init];
    StockItem *i5 = [[StockItem alloc] init];
    StockItem *i6 = [[StockItem alloc] init];
    StockItem *i7 = [[StockItem alloc] init];
    StockItem *i8 = [[StockItem alloc] init];
    StockItem *i9 = [[StockItem alloc] init];
    
    i1.name = @"Orbit";
    i2.name = @"Tic-Tac";
    i3.name = @"Milka";
    i4.name = @"Chio";
    i5.name = @"Lavaza";
    i6.name = @"Coca-Cola";
    i7.name = @"Fanta";
    i8.name = @"Sprite";
    i9.name = @"Lindt";
    
    i1.price = 0.99;
    i2.price = 0.89;
    i3.price = 1.99;
    i4.price = 2.99;
    i5.price = 5.99;
    i6.price = 1.20;
    i7.price = 1.20;
    i8.price = 1.20;
    i9.price = 3.49;
    
    items = [[NSMutableArray alloc] init];
    
    [items addObject:i1];
    [items addObject:i2];
    [items addObject:i3];
    [items addObject:i4];
    [items addObject:i5];
    [items addObject:i6];
    [items addObject:i7];
    [items addObject:i8];
    [items addObject:i9];

    searchResults = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else{
        return items.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = ((StockItem *)[searchResults objectAtIndex:indexPath.row]).name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"price: %.2f BGN",((StockItem *)[searchResults objectAtIndex:indexPath.row]).price];

    }
    else{
        cell.textLabel.text = ((StockItem *)[items objectAtIndex:indexPath.row]).name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"price: %.2f BGN",((StockItem *)[items objectAtIndex:indexPath.row]).price];
    }
    
    return cell;
}

#pragma Search Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", searchText];
    searchResults = [items filteredArrayUsingPredicate:predicate];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterContentForSearchText:searchString scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
