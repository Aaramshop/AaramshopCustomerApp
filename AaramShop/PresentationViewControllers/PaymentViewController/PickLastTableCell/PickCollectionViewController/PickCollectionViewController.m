//
//  PickCollectionViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PickCollectionViewController.h"
#import "ProductsModel.h"
static NSString *strCollectionItemsValue = @"collectionItems";

@interface PickCollectionViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation PickCollectionViewController
@synthesize collectionV,dataSource;
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
#pragma mark - CollectionView Delegates & DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeCell=CGSizeZero;
    sizeCell=CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3-2, 85);
    return sizeCell;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    if (cell == nil) {
        cell = [collectionV dequeueReusableCellWithReuseIdentifier:strCollectionItemsValue forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];


    ProductsModel *objProductModel =[dataSource objectAtIndex:indexPath.row];
    
    UIImageView *imgProfilePic = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 56, 56)];
    imgProfilePic.backgroundColor = [UIColor clearColor];
    
    
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, 80, 21)];
    lblPrice.textColor = [UIColor redColor];
    lblPrice.font = [UIFont fontWithName:kRobotoRegular size:11.0];
    lblPrice.text=objProductModel.product_price;
    
    [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductModel.product_image]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];

    
    [cell.contentView addSubview:imgProfilePic];
    [cell.contentView addSubview:lblPrice];
    return cell;
}


#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
