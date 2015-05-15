

#import <UIKit/UIKit.h>

@interface ChatCustomCell : UITableViewCell{
	UILabel      *dateLabel;

}

@property (nonatomic, retain) IBOutlet UILabel     *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel      *nameLabel;


@end
