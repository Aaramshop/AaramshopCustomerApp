//
//  PreferencesViewController.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()
{
    NSMutableArray *arrNotification;
    NSMutableArray *arrLocation;
    NSMutableArray *allSections;
    NSMutableDictionary *dataDict;
}
@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrNotification = [[NSMutableArray alloc] init];
    arrLocation = [[NSMutableArray alloc] init];
    dataDict=[[NSMutableDictionary alloc]init];
    allSections =[[NSMutableArray alloc]init];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                         @"preferencesOffersIcon",@"images",
                         @"Offers",@"name",nil]];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                             @"preferencesDeleveryStatusIcon",@"images",
                             @"Delivery Status",@"name",nil]];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                             @"preferencesChatIcon",@"images",
                             @"Chat",@"name",nil]];
    
    [arrLocation addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"preferencesLocationIcon",@"images",
                                 @"9996866907",@"name",nil]];
    
    [allSections addObject:@"Notification"];
    [allSections addObject:@"Location"];
    [dataDict setObject:arrNotification forKey:@"Notification"];
    [dataDict setObject:arrLocation forKey:@"Location"];
    [self setUpNavigationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Navigation

-(void)setUpNavigationView
{
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];

    
    [navView setCustomNavigationLeftArrowImageWithImageName:@"backBtn"];
    
    navView.delegate=self;
    [self.view addSubview:navView];
    
    
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Delegates & Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    NSInteger toReturn = 1;
    
    if (allSections && allSections.count > 0)
    {
        toReturn = allSections.count;
    }
    return toReturn;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger toReturn = 0;
    NSArray *sectionArr = [dataDict objectForKey: [allSections  objectAtIndex: section]];
    
    if (sectionArr && sectionArr.count > 0)
    {
        toReturn = sectionArr.count;
    }
    return toReturn;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    PreferenceTableCell *cell = (PreferenceTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PreferenceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
    
    cell.indexPath=indexPath;
    [cell updateCellWithData: dataDic];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
