//
//  RightCollectionViewController.h
//  AaramShop
//
//  Created by Approutes on 10/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@interface RightCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    UIToolbar *toolBarBehindView;
    UICollectionView *collectionVwCategory;
    UISearchBar *searchBarCategory;
    NSMutableArray *arrSearchCategories;
}
@property(nonatomic,strong) NSMutableArray *arrCategories;
@end
