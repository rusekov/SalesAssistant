//
//  BagOfItems.h
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockItem.h"

@interface BagOfItems : NSObject

@property (strong, nonatomic) NSCountedSet * items;

-(void) addStockItem: (StockItem*) item withQuantity: (int) quantity;

-(void) removeStockItem: (StockItem*) item withQuantity: (int) quantity;

-(int) countAssortment;

-(int) countItemsOfType: (StockItem*) item;

@end
