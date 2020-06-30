//
//  AppDelegate.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/12.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
@property(nonatomic,strong)NSData * pushToken;

@end

