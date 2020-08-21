//
//  LxmWeiTuoVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/13.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmWeiTuoVC.h"
#import "LxmFriendVC.h"
#import "LxmSubDeviceListVC.h"
#import "LxmWeiTuoTitleView.h"
#import "LxmJiaZhangModel.h"
#import "LxmFriendRequestVC.h"
#import "LxmWeiTuoManageVC.h"
#import "LxmWeiTuoJieshouVC.h"
#import "LxmBLEManager.h"
#import "CBPeripheral+MAC.h"


@interface LxmWeiTuoVC ()<LxmWeiTuoTitleViewDelegate,UIScrollViewDelegate>
{
    LxmWeiTuoTitleView *_topView;
    UIScrollView *_scrollView;
    LxmSubDeviceListVC * _subDeviceVC;
    LxmFriendVC * _friendVC;
}
@end

@implementation LxmWeiTuoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"委托";
   
    [self initTopView];
}
-(void)initTopView
{
    _topView = [[LxmWeiTuoTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, self.view.bounds.size.width, self.view.bounds.size.height-41-49)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*2.0, 0);
    [self.view addSubview:_scrollView];
    
    
    _subDeviceVC = [[LxmSubDeviceListVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    _subDeviceVC.view.frame = _scrollView.bounds;
    _subDeviceVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_scrollView addSubview:_subDeviceVC.view];
    _subDeviceVC.preVC = self;
    [_scrollView addSubview:_subDeviceVC.view];
    [self addChildViewController:_subDeviceVC];
    
    
    _friendVC = [[LxmFriendVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    _friendVC.view.frame = CGRectMake(_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    _friendVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _friendVC.preVC = self;
    [_scrollView addSubview:_friendVC.view];
    [self addChildViewController:_friendVC];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMsgInfoData) name:@"userInfo" object:nil];
}

- (void)loadMsgInfoData{
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine getMessageDetailURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"msgId":[LxmTool ShareTool].messageID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
            lxmMessageInforModel * model = [lxmMessageInforModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            switch ([model.type intValue]) {
                case 1:
                    //好友申请
                {
                    LxmFriendRequestVC * vc = [[LxmFriendRequestVC alloc] init];
                    vc.model = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                    //好友申请同意
                {
                    
                }
                    break;
                case 3:
                    //好友申请拒绝
                {
                   
                }
                    break;
                case 4:
                    //好友申请忽略
                {
                   
                }
                    break;
                case 5:
                    //委托申请
                {
                    LxmWeiTuoManageVC * vc = [[LxmWeiTuoManageVC alloc] init];
                    vc.model = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 6:
                    //委托申请接受
                {
                    LxmWeiTuoJieshouVC * vc = [[LxmWeiTuoJieshouVC alloc] init];
                    vc.model = model;
                    vc.type = LxmWeiTuoJieshouVC_type_jieshou;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 7:
                    //委托申请拒绝
                {
                    LxmWeiTuoJieshouVC * vc = [[LxmWeiTuoJieshouVC alloc] init];
                    vc.model = model;
                    vc.type = LxmWeiTuoJieshouVC_type_bujieshou;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 8:
                    //解除委托
                    if (LxmBLEManager.shareManager.master.state == CBPeripheralStateConnected) {
                        for (CBPeripheral *p in [LxmBLEManager shareManager].deviceList) {
                            if (p.state == CBPeripheralStateConnected) {
                                if ([p.tongxinId isEqualToString:model.identifier]) {
                                    [LxmNetworking networkingPOST:[LxmURLDefine getClearEntrustURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"userEquId":model.equId} success:^(NSURLSessionDataTask *task, id responseObject) {
                                        if ([[responseObject objectForKey:@"key"] integerValue] == 1) {
                                        [LxmBLEManager.shareManager delDevice:[LxmBLEManager.shareManager peripheralWithTongXinId:model.communication] fromDevice:LxmBLEManager.shareManager.master completed:^(BOOL success, NSString *tips) {
                                                if (success) {
                                                    [SVProgressHUD showSuccessWithStatus:@"已经解除委托"];
                                                }else{
                                                    [SVProgressHUD showSuccessWithStatus:@"解除委托失败"];
                                                }
                                            }];
                                        }
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                    }];
                                }
                            }else{
                                [SVProgressHUD showErrorWithStatus:@"当前委托设备未连接,暂不能进行操作"];
                            }
                            
                            
                        }
                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:@"主设备未连接"];
                    }
                    
                    
                    break;
                default:
                    break;
            }
            
            
           
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"111");
    }];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [_topView LxmLxmWeiTuoTitleViewWithTag:toN];
    }
}
- (void)LxmWeiTuoTitleView:(LxmWeiTuoTitleView *)titleView btnAtIndex:(NSInteger)index
{
    
    [_scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
    
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
