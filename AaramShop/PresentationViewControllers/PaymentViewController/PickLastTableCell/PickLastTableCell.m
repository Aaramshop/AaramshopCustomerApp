//
//  PickLastTableCell.m
//  AaramShop
//
//  Created by Approutes on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PickLastTableCell.h"
static NSString *strCollectionItems = @"collectionItems";

@implementation PickLastTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
        flowLayout1.minimumLineSpacing = 0.0;
        flowLayout1.minimumInteritemSpacing = 1.0f;
        [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        PickCollectionViewController* pickCollectionViewC = (PickCollectionViewController*) [storyboard instantiateViewControllerWithIdentifier :@"PickCollectionView"];
        pickCollectionViewC.collectionV.collectionViewLayout = flowLayout1;
        
        pickCollectionViewC.collectionV.allowsSelection=YES;
        pickCollectionViewC.collectionV.alwaysBounceHorizontal = YES;
        [pickCollectionViewC.collectionV setDataSource:self];
        [pickCollectionViewC.collectionV setDelegate:self];
        
        [pickCollectionViewC.collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionItems];
        pickCollectionViewC.collectionV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        pickCollectionViewC.collectionV.backgroundColor = [UIColor clearColor];
        pickCollectionViewC.collectionV.pagingEnabled = YES;
        
        CGRect pickCollectionViewRect = self.bounds;
        pickCollectionViewC.view.frame = pickCollectionViewRect;
        [subview addSubview:pickCollectionViewC.view];
        
        
    }
    return self;
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    
}
@end
