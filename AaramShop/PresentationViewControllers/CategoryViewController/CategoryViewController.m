//
//  CategoryViewController.m
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CategoryViewController.h"

static NSString *strCollectionCellCategory = @"collectionCellCategories";

@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize arrCategory,collectionViewCategory,mainCategoryIndex,delegate,pickerViewOfCategory;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainCategoryIndex = 0;
    UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumLineSpacing = 0.0;
    flowLayout1.minimumInteritemSpacing = 0.0f;
    [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    collectionViewCategory = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 233) collectionViewLayout:flowLayout1];
    collectionViewCategory.allowsSelection=YES;
    collectionViewCategory.alwaysBounceHorizontal = YES;
    [collectionViewCategory setDataSource:self];
    [collectionViewCategory setDelegate:self];
    
    [collectionViewCategory registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionCellCategory];
    
    collectionViewCategory.backgroundColor = [UIColor clearColor];
    collectionViewCategory.pagingEnabled = YES;
    
    UIImageView *imgVBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 194, [UIScreen mainScreen].bounds.size.width, 40)];
    imgVBg.image = [UIImage imageNamed:@"homeDetailsBannerShade.png"];
    
    pickerViewOfCategory = [[V8HorizontalPickerView alloc]initWithFrame:CGRectMake(0, 194, [UIScreen mainScreen].bounds.size.width, 40)];
    pickerViewOfCategory.backgroundColor = [UIColor clearColor];
    pickerViewOfCategory.currentSelectedIndex = self.mainCategoryIndex;
    pickerViewOfCategory.delegate =self;
    pickerViewOfCategory.dataSource = self;
    pickerViewOfCategory.selectedTextColor = [UIColor whiteColor];
    pickerViewOfCategory.textColor   = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] colorWithAlphaComponent:0.75];
    pickerViewOfCategory.elementFont = [UIFont fontWithName:kRobotoRegular size:14.0];
    
    pickerViewOfCategory.selectionPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/3, 0);
    [pickerViewOfCategory scrollToElement:self.mainCategoryIndex animated:YES];
    
    [self.view addSubview:collectionViewCategory];
    [self.view addSubview:imgVBg];
    [self.view addSubview:pickerViewOfCategory];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (arrCategory.count>0) {
        [pickerViewOfCategory scrollToElement:self.mainCategoryIndex animated:YES];
        [self.collectionViewCategory scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mainCategoryIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }
}
#pragma mark - UICollectionView Delegate & DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionNum = 0;
    if (collectionView == collectionViewCategory) {
        sectionNum = 1;
    }
    return sectionNum;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if (collectionView == collectionViewCategory)
        rowCount = arrCategory.count;
    return rowCount;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell=CGSizeZero;
    sizeCell=CGSizeMake([UIScreen mainScreen].bounds.size.width, 233);
    return sizeCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    if (collectionView == collectionViewCategory) {
        if (cell == nil) {
            cell = [collectionViewCategory dequeueReusableCellWithReuseIdentifier:strCollectionCellCategory forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
        
        
        StoreModel *objStoreModel = [arrCategory objectAtIndex:indexPath.row];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234)];
        
        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.store_main_category_banner_1]] placeholderImage:[UIImage imageNamed:@"homePageBannerImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
        [cell.contentView addSubview:imgV];
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionViewSelected didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionViewSelected deselectItemAtIndexPath:indexPath animated:YES];
}
-(BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath;
    for (UICollectionViewCell *cell in [collectionViewCategory visibleCells])
    {
        indexPath = [collectionViewCategory indexPathForCell:cell];
    }
    if (self.mainCategoryIndex != indexPath.row)
    {
        self.mainCategoryIndex = indexPath.row;
        
        [pickerViewOfCategory scrollToElement:self.mainCategoryIndex animated:YES];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(CategoryViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(refreshSubCategoryData:)])
        {
            [self.delegate refreshSubCategoryData:self.mainCategoryIndex];
        }
    }
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
    NSInteger numberOfElements=0;
    numberOfElements = arrCategory.count;
    return numberOfElements;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index
{
    StoreModel *objStoreModel = [arrCategory objectAtIndex:index];
    NSString *strValue = objStoreModel.store_main_category_name;
    return strValue;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index
{
    NSInteger widthValue=0;
    widthValue=[UIScreen mainScreen].bounds.size.width/3;
    return widthValue ;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    
    if (self.mainCategoryIndex != index) {
        self.mainCategoryIndex = index;
        
        [self.collectionViewCategory scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mainCategoryIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(CategoryViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(refreshSubCategoryData:)])
        {
            [self.delegate refreshSubCategoryData:self.mainCategoryIndex];
        }
        
    }
    
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
