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
@synthesize arrCategories,delegate,strStore_Id,aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;
    strSearchTxt = @"";
    arrSearchCategories = [[NSMutableArray alloc]init];
    arrCategories = [[NSMutableArray alloc]init];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;

    searchBarCategory = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 44)];
    searchBarCategory.delegate = self;
    
    
    toolBarBehindView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumLineSpacing = 0.0;
    flowLayout1.minimumInteritemSpacing = 1.0f;
    [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionVertical];

//    collectionVwCategory = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 54, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-54) collectionViewLayout:flowLayout1];
    
    
    collectionVwCategory = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 54, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(54+93+49)) collectionViewLayout:flowLayout1];

    
    

    collectionVwCategory.allowsSelection=YES;
    collectionVwCategory.alwaysBounceVertical = YES;
    [collectionVwCategory setDataSource:self];
    [collectionVwCategory setDelegate:self];
    
    [collectionVwCategory registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionCategory];
    collectionVwCategory.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    collectionVwCategory.backgroundColor = [UIColor clearColor];
    collectionVwCategory.pagingEnabled = YES;
    
    UIView *viewBehindToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54)];
    viewBehindToolBar.backgroundColor = [UIColor whiteColor];
	
	
    [self.view addSubview:toolBarBehindView];
    [self.view addSubview:viewBehindToolBar];
    [self.view addSubview:searchBarCategory];
    [self.view addSubview:collectionVwCategory];
	
    
//    UITextField *searchField;
//    UIView *subviews = [searchBarCategory.subviews lastObject];
//    searchField = (id)[subviews.subviews objectAtIndex:1];
//        for (UIView *subView in searchBarCategory.subviews){
//            for (UIView *ndLeveSubView in subView.subviews){
//                if ([ndLeveSubView isKindOfClass:[UITextField class]])
//                {
//                    searchField = (UITextField *)ndLeveSubView;
//                    break;
//                }
//            }
//        }
//    searchField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
//    
//    if(!(searchField == nil)) {
//        searchField.textColor = [UIColor blackColor];
//        [searchField setBackground: [UIImage imageNamed:@"searchBox.png"]];
//        [searchField setBorderStyle:UITextBorderStyleNone];
//    }
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBox.png"]forState:UIControlStateNormal];
    [searchBarCategory setBackgroundImage:[UIImage new]];
    [searchBarCategory setTranslucent:YES];
    searchBarCategory.layer.cornerRadius  = 4;
    searchBarCategory.layer.masksToBounds= YES;
    searchBarCategory.placeholder = @"Search";
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f]];
    [searchBarCategory setImage:[UIImage imageNamed:@"searchIconGrey"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    
//    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBox.png"]forState:UIControlStateNormal];
//    [searchBarr setTranslucent:YES];
//    [searchBarCategory setBackgroundImage:[UIImage new]];
//    searchBarCategory.layer.masksToBounds= YES;

//    searchBarr.layer.cornerRadius  = 4;
//    searchBarr.clipsToBounds= YES;
//    searchBarr.delegate=self;
//    searchBarr.placeholder = @"Search";
//    
//    searchBarr.tintColor =[UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
    
    
    
    
 
    
//    [searchBarr setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    searchBarCategory.placeholder = @"Search";
//    searchBarCategory.searchBarStyle = UISearchBarStyleMinimal;
//    searchBarCategory.translucent = YES;
//    searchBarCategory.barStyle = UIBarStyleDefault;

}
- (void)viewWillAppear:(BOOL)animated
{
	[collectionVwCategory reloadData];
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
    
    CategoryModel *objCategoryModel = nil;

    if (isSearching) {
        objCategoryModel = [arrSearchCategories objectAtIndex:indexPath.row];
    }
    else
        objCategoryModel= [arrCategories objectAtIndex:indexPath.row];

    CGSize size= [Utils getLabelSizeByText:objCategoryModel.category_name font:[UIFont fontWithName:kRobotoRegular size:13.0] andConstraintWith:([UIScreen mainScreen].bounds.size.width)/3-22];
    
    if (size.height < 20) {
        size.height = 110;
    }
    else
        size.height = size.height+80;

    
    sizeCell=CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3-2, size.height);
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
    if([self.selectedId integerValue]==[objCategoryModel.category_id integerValue])
	{
		[imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.categroy_image_active]] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				if (image) {
				}
		}];
	}
	else
	{
		[imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.categroy_image_inactive]] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			if (image) {
			}
		}];
	}

    [cell.contentView addSubview:imgV];
    
    CGSize size= [Utils getLabelSizeByText:objCategoryModel.category_name font:[UIFont fontWithName:kRobotoRegular size:13.0] andConstraintWith:([UIScreen mainScreen].bounds.size.width)/3-22];
    
    if (size.height < 20) {
        size.height = 20;
    }

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, (([UIScreen mainScreen].bounds.size.width)/3-22), size.height)];
    lbl.textColor = [UIColor blackColor];
    lbl.numberOfLines = 0 ;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:kRobotoRegular size:13.0];
    lbl.text = objCategoryModel.category_name;
    [cell.contentView addSubview:lbl];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionViewSelected didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionViewSelected deselectItemAtIndexPath:indexPath animated:YES];
    
    CategoryModel *objCategoryModel = nil;
    
    if (isSearching) {
        objCategoryModel = [arrSearchCategories objectAtIndex:indexPath.row];
    }
    else
        objCategoryModel= [arrCategories objectAtIndex:indexPath.row];

    
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:objCategoryModel.category_name,kCategory_name,objCategoryModel.category_id,kCategory_id, nil];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (objCategoryModel.category_name != nil)
    {
        [dict setObject:objCategoryModel.category_name forKey:kCategory_name];
    }
    [dict setObject:objCategoryModel.category_id forKey:kCategory_id];
    
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(RightControllerDelegate)] && [self.delegate respondsToSelector:@selector(selectCategory:)])
    {
        [self.delegate selectCategory:dict];
        [self.view removeFromSuperview];
    }

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
    if ([strSearchTxt length]>2)
    {
        [arrSearchCategories removeAllObjects];
        [collectionVwCategory reloadData];
        [self createDataToGetSearchCategory];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBarCategory resignFirstResponder];
}

-(void)createDataToGetSearchCategory
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:strSearchTxt forKey:kSearch_term];
    [self callWebserviceToGetSearchCategory:dict];
}

-(void)callWebserviceToGetSearchCategory:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kSearchStoreProductCategoriesURL withInput:aDict withCurrentTask:TASK_SEARCH_STORE_PRODUCT_CATEGORY andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_SEARCH_STORE_PRODUCT_CATEGORY) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseSearchCategoryData:responseObject];
        }
        else
        {
          //  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}
-(void)parseSearchCategoryData:(id)responseObject
{
    NSArray *categories = [responseObject objectForKey:@"categories"];
    
    for (NSDictionary *dict in categories) {
        
        CategoryModel *objCategoryModel = [[CategoryModel alloc]init];
        objCategoryModel.category_banner = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_banner]];
        objCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
        objCategoryModel.categroy_image_active = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategroy_image_active]];
        objCategoryModel.categroy_image_inactive = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategroy_image_inactive]];
        
        [arrSearchCategories addObject:objCategoryModel];
    }
    [collectionVwCategory reloadData];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
