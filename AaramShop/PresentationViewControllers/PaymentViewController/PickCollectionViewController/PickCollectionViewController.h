//
//  PickCollectionViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPayment.h"
@interface PickCollectionViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    NSMutableArray *dataSource;
    
    __weak IBOutlet UICollectionView *collectionV;
    CMPayment *cmPayment;
}
@end
