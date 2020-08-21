//
//  BaseTableViewController.h
//  ShareGo
//
//  Created by 李晓满 on 16/4/7.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

@property (nonatomic, strong, readonly) UITableView * tableView;

@end
