//
//  HomeSecondViewController.h
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "RightCollectionViewController.h"

@interface HomeSecondViewController : UIViewController<V8HorizontalPickerViewDelegate,V8HorizontalPickerViewDataSource,CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIScrollViewDelegate>
{    
    __weak IBOutlet UITableView *tblVwCategory;
    RightCollectionViewController *rightCollectionVwContrllr;
}
@property(nonatomic,strong) NSMutableArray *arrListData;
@property(nonatomic,strong) NSMutableArray *arrSubCategory;
@property (nonatomic) NSInteger mainCategoryIndexPicker;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@end
