//
//  ShopListTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListCell.h"
#import "SharedUserModel.h"

@implementation ShoppingListCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [btnShare setTitleColor:[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionDelete:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ShoppingListCellDelegate)] && [self.delegate respondsToSelector:@selector(deleteShoppingList:)])
    {
        [self.delegate deleteShoppingList:_indexPath.row];
    }

}




-(void)updateCell:(ShoppingListModel *)shoppingListModel
{
    lblTitle.text = shoppingListModel.shoppingListName;
    
    if ([shoppingListModel.totalItems integerValue]>1)
    {
        lblQuantity.text = [NSString stringWithFormat:@"%@ Items",shoppingListModel.totalItems];
    }
    else
    {
        lblQuantity.text = [NSString stringWithFormat:@"%@ Item",shoppingListModel.totalItems];
    }
    
    
    ////
    
    NSString *strTime = @"";
    
    if ([shoppingListModel.reminderDate length]>0)
    {
        [btnTime setImage:[UIImage imageNamed:@"clockIconRed"] forState:UIControlStateNormal];
        [btnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.reminderDate doubleValue]]];
    }
    else
    {
        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.creationDate doubleValue]]];
    }
    
    strTime = [[[strTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"] componentsSeparatedByString:@" "] firstObject];
    
    if ([strTime hasSuffix:@","])
    {
        strTime = [strTime substringToIndex:[strTime length]-1];
    }
    
    
    [btnTime setTitle:strTime forState:UIControlStateNormal];
    
    
    
    if ([shoppingListModel.sharedBy count]>0)
    {
        
    }
    else if ([shoppingListModel.sharedWith count]>0)
    {
        
     /*
        
        NSDictionary * wordToColorMapping;// = [NSDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil]
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
        for (NSString * word in wordToColorMapping) {
            UIColor * color = [wordToColorMapping objectForKey:word];
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
            [string appendAttributedString:subString];
        }
        
        
        
        
        
        

        NSString *strText = [NSString stringWithFormat:@"Shared by you with %ld people",[shoppingListModel.sharedWith count]];
        
        
        NSMutableAttributedString *strAttrFinal = [[NSMutableAttributedString alloc] init];
        
        
        NSDictionary* textAttributes = @{
                                            NSForegroundColorAttributeName :[UIColor colorWithRed:254.0/255.0 green:56.0/255.0 blue:45.0/255.0 alpha:1.0]
                                            };

        NSAttributedString* textAttrString = [[NSAttributedString alloc] initWithString:strText attributes:textAttributes];
        
        
        
        //if ([[dicSummary valueForKey:@"priceWithDiscount"] integerValue]==0)
        {
            NSDictionary* actPriceAttributes = @{
                                                 NSForegroundColorAttributeName :[UIColor redColor]
                                                 };
            
            NSAttributedString* actPriceAttrString = [[NSAttributedString alloc] initWithString:strActualPrice attributes:actPriceAttributes];
            
            [strAttrFinal appendAttributedString:quantityAttrString];
            [strAttrFinal appendAttributedString:actPriceAttrString];
            
            lblQuantity.attributedText = strAttrFinal;
            
        }
        
        btnShare setAttributedTitle:(NSAttributedString *) forState:<#(UIControlState)#>
    }

    //*/
    
    
    
    
    ////
    
    
    // work remainig for share info..
    
    }
}

/*
 @property(nonatomic,strong) NSString * sharedBy; // temp // user model here
 @property(nonatomic,strong) NSString * sharedWith; // temp // user model here
 @property(nonatomic,strong) NSString * total_people;
 */


@end
