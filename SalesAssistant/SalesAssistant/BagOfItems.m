//
//  BagOfItems.m
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "BagOfItems.h"

@implementation BagOfItems

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        _items = [[NSCountedSet alloc] init];
    }
    return self;
}

-(void) addStockItem:(StockItem *)item withQuantity:(int)quantity{
    /* for dictionary
     
     if ([[self.items allKeys] containsObject:item.ID]) {
        int newValue = [[self.items objectForKey:item.ID] intValue] + quantity;
        
        [self.items setValue:[NSNumber numberWithInt:newValue] forKey:item.ID ];
    }
    else{
        [self.items setValue:[NSNumber numberWithInt:quantity] forKey:item.ID ];

    }
     */
    
    for (int i = 0; i<quantity; i++) {
        [self.items addObject:item];
    }
    
}

-(void) removeStockItem:(StockItem *)item withQuantity:(int)quantity{
    for (int i = 0; i<quantity; i++) {
        [self.items removeObject:item];
    }
    
    //ToDo: Check for sufficient items
}

-(int) countAssortment{
    return self.items.count;
}

-(int) countItemsOfType:(StockItem *)item{
    return [self.items countForObject:item];
}

@end
