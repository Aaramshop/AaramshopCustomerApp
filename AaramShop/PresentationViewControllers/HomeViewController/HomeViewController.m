//
//  HomeViewController.m
//  AaramShop
//
//  Created by Pradeep Singh on 12/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationEnterViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    [self setUpNavigationView];
    [self showLocationScreen];
    dataSource = [[NSMutableArray alloc]init];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"imageOne",@"imgProfilePic",
                           @"Food Plaza",@"name",
                           @"homeStoreIcon",@"userChoice",
                           @"addToCardNoBox",@"paid",nil]];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"imageTwo",@"imgProfilePic",
                           @"Dominoz",@"name",
                           @"homeStoreIcon",@"userChoice",
                           @"addToCardNoBox",@"paid", nil]];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"imageThree",@"imgProfilePic",
                           @"Big Mart",@"name",
                           @"favourateIcon",@"userChoice",
                           @"addToCardNoBox",@"paid", nil]];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"imageOne",@"imgProfilePic",
                           @"Food Plaza",@"name",
                           @"favourateIcon",@"userChoice",
                           @"addToCardNoBox",@"paid", nil]];
    

}
-(void)showLocationScreen
{
    LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:locationScreen];
    [self presentViewController:locationScreen animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Navigation

-(void)setUpNavigationView
{
    //.view.backgroundColor =kCommonScreenBackgroundColor;
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    //  [navView setCustomNavigationLeftButtonText:NSLocalizedString(kCommonNavButtonCancelText, nil)];
    // [navView setCustomNavigationRightButtonText:NSLocalizedString(kCommonNavButtonSaveText, nil)];
//    [navView setCustomNavigationTitle:NSLocalizedString(@"Your LineJump", nil)];
//    //    [navView setCustomNavigationLeftArrowImage];
//    [navView removeCustomNavigationLeftArrowImage];
    
    [navView setCustomNavigationLeftArrowImageWithImageName:@"menuIcon.png"];
    [navView setCustomNavigationRightArrowImage];
    
        navView.delegate=self;
    [self.view addSubview:navView];
    
    
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.sideBar show];
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    
    
    [self.navigationController pushViewController:viewC animated:YES];
    
}
#pragma mark - TableView Datasource & Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 168;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * secView=[[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,168)];
    secView.backgroundColor=[UIColor whiteColor];
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,168)];
    scrollView.pagingEnabled=YES;
    
    NSMutableArray* pageImages = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"homePageBannerImage"],[UIImage imageNamed:@"homePageBannerImageFour"],[UIImage imageNamed:@"homePageBannerImageThree"],[UIImage imageNamed:@"homePageBannerImageTwo"], nil];
    
    
    // [scrollView setBackgroundColor:[UIColor redColor]];
    scrollView.alwaysBounceVertical = NO;
    scrollView.bounces=NO;
    NSLog(@"scrol %f",scrollView.bounds.size.height);
    // scrollView view
    //    scrollViewView.bac kgroundColor=[UIColor grayColor];
    for (int i=0; i<4; i++)
    {
        CGRect frame = CGRectMake(scrollView.frame.size.width * i,
                                  0,
                                  scrollView.frame.size.width,
                                  [Utils isIPhone5]?168:168);
        //        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.font = [UIFont systemFontOfSize:144.0];
        //        label.text = [NSString stringWithFormat:@"%d", i];
        
        UIImageView *imgCover=[[UIImageView alloc]initWithFrame:frame];
        [imgCover setClipsToBounds:YES];
        
        imgCover.image = [pageImages objectAtIndex:i];
        
        [scrollView addSubview:imgCover];
        
        
    }
    scrollView.contentSize = CGSizeMake(1280, [Utils isIPhone5]?168:168);
    
    scrollView.delegate = self;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    
    
//    imgBackground.image=[UIImage imageNamed:@"homePageBannerImage"];
    
    
    UIImageView *imgTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, 147, 49)];
    imgTag.image = [UIImage imageNamed:@"homeOfferBox"];
    
    UILabel *lblOff = [[UILabel alloc]initWithFrame:CGRectMake((imgTag.frame.size.width - 112)/2, 4, 112, 25 )];
    lblOff.font = [UIFont fontWithName:kMyriadProRegular size:26];
    lblOff.text = @"20% OFF";
    
    UILabel *brandName = [[UILabel alloc]initWithFrame:CGRectMake((lblOff.frame.size.width - 112)/2, lblOff.frame.size.height + lblOff.frame.origin.y - 2, 112, 19)];
    brandName.font= [UIFont fontWithName:kMyriadProRegular size:15];
    brandName.textAlignment=NSTextAlignmentRight;
    brandName.text = @"Food Plaza";
    
    
    [secView addSubview:scrollView];
    [secView addSubview:imgTag];
    [imgTag addSubview:lblOff];
    [imgTag addSubview:brandName];
    
    return secView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell=nil;
    HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dataDic = [dataSource objectAtIndex: indexPath.row];
    cell.indexPath=indexPath;
    [cell updateCellWithData: dataDic];
    
    
    
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
