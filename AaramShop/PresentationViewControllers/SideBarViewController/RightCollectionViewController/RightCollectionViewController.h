//
//  RightCollectionViewController.h
//  AaramShop
//
//  Created by Approutes on 10/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@interface RightCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) NSMutableArray *arrCategories;
@property(nonatomic,weak) IBOutlet UICollectionView *collectionVwCategory;
@property(nonatomic,weak) IBOutlet UISearchBar *searchBarCategory;
@property(nonatomic,strong) NSMutableArray *arrSearchCategories;
@end
