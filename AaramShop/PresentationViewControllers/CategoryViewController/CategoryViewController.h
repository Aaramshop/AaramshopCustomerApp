//
//  CategoryViewController.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "StoreModel.h"
@protocol CategoryViewControllerDelegate <NSObject>

-(void)refreshSubCategoryData:(NSInteger )selectedCategory;
@end

@interface CategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,V8HorizontalPickerViewDataSource,V8HorizontalPickerViewDelegate,V8HorizontalPickerElementState>
@property(nonatomic,strong) id<CategoryViewControllerDelegate> delegate;
@property(nonatomic) NSInteger mainCategoryIndex;
@property(nonatomic,strong) NSMutableArray *arrCategory;
@property(nonatomic,strong) UICollectionView *collectionViewCategory;
@property(nonatomic,strong) V8HorizontalPickerView *pickerViewOfCategory;
@end
