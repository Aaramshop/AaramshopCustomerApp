//
//  Protocols.h
//  AaramShop
//
//  Created by Pradeep Singh on 23/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#ifndef AaramShop_Protocols_h
#define AaramShop_Protocols_h
#import "CMGlobalSearch.h"
//=====================================================
@protocol OffersTableCellDelegate <NSObject>

- (void)addedValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath;
- (void)minusValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath;
- (void)updateTableAtIndexPath:(NSIndexPath *)inIndexPath;

@end

//===========================================
@protocol GlobalSearchViewControllerDelegate <NSObject>
@optional
-(void)removeSearchViewFromParentView;
-(void)openSearchedUserPrroductFor:(CMGlobalSearch *)globalSearchModel;

@end

#endif
