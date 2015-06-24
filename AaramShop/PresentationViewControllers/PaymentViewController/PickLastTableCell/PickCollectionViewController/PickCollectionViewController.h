//
//  PickCollectionViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickCollectionViewController : UIViewController
 @property(nonatomic)   __weak IBOutlet UICollectionView *collectionV;
 @property(nonatomic,strong)  NSMutableArray *dataSource;

@end
