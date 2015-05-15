//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UITableViewController+Red5.m $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Aman Alam
//	Created: 29-Jul-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#import "UITableViewController+SH.h"
#import "UIView+SH.h"

@implementation UITableViewController(UITableViewControllerSH)

#pragma mark -
-(UINavigationItem *)
selfNavItem
{
	UINavigationItem * navItem = self.navigationItem;
	if( !navItem || !self.navigationController)
	{
		UIView * superView = [self.tableView superview];
		UIViewController * theParentViewController = [superView selfViewController];
		navItem = theParentViewController.navigationItem;
	}
	return navItem;
}

-(UINavigationController*)
selfNavController
{
	UINavigationController * navController = self.navigationController;
	if( !navController )
	{
		UIView * superView = [self.tableView superview];
		UIViewController * theParentViewController = [superView selfViewController];
		navController = theParentViewController.navigationController;
	}
	return navController;
}

@end
