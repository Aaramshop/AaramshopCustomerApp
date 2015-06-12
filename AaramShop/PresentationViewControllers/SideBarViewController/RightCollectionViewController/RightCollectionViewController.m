//
//  RightCollectionViewController.m
//  AaramShop
//
//  Created by Approutes on 10/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RightCollectionViewController.h"

static NSString *strCollectionCategory = @"collectionCategories";

@interface RightCollectionViewController ()
{
    BOOL isSearching;
    NSString *strSearchTxt;
}
@end

@implementation RightCollectionViewController
@synthesize arrCategories,arrSearchCategories,searchBarCategory,collectionVwCategory;
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;
    strSearchTxt = @"";
    arrSearchCategories = [[NSMutableArray alloc]init];
    arrCategories = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumLineSpacing = 0.0;
    flowLayout1.minimumInteritemSpacing = 1.0f;
    [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    collectionVwCategory.allowsSelection=YES;
    collectionVwCategory.alwaysBounceVertical = YES;
    [collectionVwCategory setDataSource:self];
    [collectionVwCategory setDelegate:self];
    
    [collectionVwCategory registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionCategory];
    collectionVwCategory.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    collectionVwCategory.backgroundColor = [UIColor clearColor];
    collectionVwCategory.pagingEnabled = YES;
    
}
#pragma mark - UICollectionView Delegate & DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sectionNum = 0;
    sectionNum = 1;
    return sectionNum;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if (isSearching) {
        rowCount = arrSearchCategories.count;
    }
    else
    rowCount = arrCategories.count;
    return rowCount;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell=CGSizeZero;
    sizeCell=CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3-2, 110);
    return sizeCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    if (cell == nil) {
        cell = [collectionVwCategory dequeueReusableCellWithReuseIdentifier:strCollectionCategory forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    CategoryModel *objCategoryModel = nil;
    if (isSearching) {
        objCategoryModel = [arrSearchCategories objectAtIndex:indexPath.row];
    }
    else
        objCategoryModel= [arrCategories objectAtIndex:indexPath.row];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(((([UIScreen mainScreen].bounds.size.width)/3-2)-60)/2,10,60, 60)];
    imgV.image = [UIImage imageNamed:objCategoryModel.img];
    [cell.contentView addSubview:imgV];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, (([UIScreen mainScreen].bounds.size.width)/3-22), 20)];
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:kRobotoRegular size:13.0];
    lbl.text = objCategoryModel.strCategoryName;
    [cell.contentView addSubview:lbl];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionViewSelected didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionViewSelected deselectItemAtIndexPath:indexPath animated:YES];
}
-(BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


#pragma mark - Search Bar Delegates

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // called only once
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]==0)
    {
        isSearching =NO;
        [arrSearchCategories removeAllObjects];
        [collectionVwCategory reloadData];
        return;
    }
    
    strSearchTxt = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    isSearching=YES;
    if ([strSearchTxt length]>0)
    {
        [arrSearchCategories removeAllObjects];
        [collectionVwCategory reloadData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.strCategoryName contains[cd] %@",strSearchTxt];
        [arrSearchCategories addObjectsFromArray:[arrCategories filteredArrayUsingPredicate:predicate]];
        [collectionVwCategory reloadData];
    }
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
