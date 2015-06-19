//
//  FlagListTableViewController.h
//  GuessThis
//
//  Created by Madhup Singh Yadav on 4/15/14.
//  Copyright (c) 2014 AppUs.in LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlagListTableViewControllerDelegate <NSObject>
@optional
-(void)updateCountryData:(CMCountryList *)objCountryData;
@end


@interface FlagListTableViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
 IBOutlet UITableView *tblCountryList;
 IBOutlet UISearchBar *searchCountry;
}
@property(nonatomic,weak) id<FlagListTableViewControllerDelegate> delegate;

@end
