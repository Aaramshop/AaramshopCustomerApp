//
//  PickCollectionViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PickCollectionViewController.h"

@interface PickCollectionViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    AppDelegate *appDel;
}
@end

@implementation PickCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDel = APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    cmPayment = [[CMPayment alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getLastMinPick];
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
    // Adjust cell size for orientation
    
    return CGSizeMake(85.f, 96.f);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LastPickOfferCell";
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dataDic =[dataSource objectAtIndex: indexPath.row];
    
    UIImageView *imgProfilePic = (UIImageView *)[cell viewWithTag:101];
    imgProfilePic.image=[UIImage imageNamed:[dataDic objectForKey:@"profileImage"]];
    UILabel *lblFriendName = (UILabel *)[cell viewWithTag:102];
    lblFriendName.text=[dataDic objectForKey:@"FriendName"];
    
    return cell;
}


-(void)getLastMinPick
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
        [dict setObject:@"1" forKey:kStore_id];
    [dict setObject:@"1" forKey:kUserId];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
//    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
    
    [self performSelector:@selector(callWebServiceToGetLastMinPick:) withObject:dict afterDelay:0.1];
}
-(void)callWebServiceToGetLastMinPick: (NSMutableDictionary *)aDict
{
    if (![Utils isInternetAvailable])
    {
        //        [Utils stopActivityIndicatorInView:self.view];
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kURLGetPaymentPageData withInput:aDict withCurrentTask:TASK_GET_LAST_MIN_PICK andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_GET_LAST_MIN_PICK)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [self parseData:responseObject];
        }
    }
}
- (void)didFailWithError:(NSError *)error
{
    //    [Utils stopActivityIndicatorInView:self.view];
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - Parsing Data
- (void)parseData:(id)data
{
    NSArray *arrDeliverySlot = [data objectForKey:@"delivery_slot"];
    NSArray *arrLastMinPick = [data objectForKey:@"last_minute_pick"];
}
@end
