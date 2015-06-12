//
//  CategoryViewController.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@protocol CategoryViewControllerDelegate <NSObject>

-(void)refreshSubCategoryData;
@end

@interface CategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,V8HorizontalPickerElementState,V8HorizontalPickerViewDataSource,V8HorizontalPickerViewDelegate>
@property(nonatomic,strong) id<CategoryViewControllerDelegate> delegate;
@property(nonatomic) NSInteger mainCategoryIndex;
@property(nonatomic,strong) NSMutableArray *arrCategory;
@property(nonatomic,strong) UICollectionView *collectionViewCategory;
@property(nonatomic,strong) V8HorizontalPickerView *pickerViewOfCategory;
@end
