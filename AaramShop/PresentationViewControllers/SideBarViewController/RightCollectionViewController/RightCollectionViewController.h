//
//  RightCollectionViewController.h
//  AaramShop
//
//  Created by Approutes on 10/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@protocol RightControllerDelegate <NSObject>

-(void)selectCategory:(NSDictionary *)dict;
@end


@interface RightCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,AaramShop_ConnectionManager_Delegate>
{
    UIToolbar *toolBarBehindView;
    UICollectionView *collectionVwCategory;
    UISearchBar *searchBarCategory;
    NSMutableArray *arrSearchCategories;
}
@property(nonatomic,strong) NSMutableArray *arrCategories;
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,weak) id<RightControllerDelegate> delegate;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@end
