//
//  LxmSetSubInfoVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/19.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmSetSubInfoVC.h"
#import "LxmTextTFView.h"
#import "LxmTextBtnImgView.h"
#import "LxmStyleSelectView.h"
#import "LxmDataManager.h"
#import "LxmBLEManager.h"
#import "Device.h"
#import "UIViewController+OpenImagePicker.h"
#import "TabBarController.h"
#import "LxmBangDingSuccessVC.h"
#import "LxmConnectedVC.h"
#import "CBPeripheral+MAC.h"
#import "UIImage+GIF.h"

@interface LxmSetSubInfoVC ()<CBPeripheralDelegate,LxmStyleSelectView,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    NSInteger _alertType;
    CBCharacteristic *_chara;
    UIImageView * _headerImgView;
    LxmTextTFView * _jixingView;
    LxmTextTFView * _nickNameView;
    LxmTextTFView * _distanceView;
    
    LxmTextTFView * _phoneView;
    
    LxmTextBtnImgView * _styleView;
    LxmStyleSelectView * _selectView;
    UIImageView * _typeImgView;
    UIImageView * _gifImgView;
    NSString *_safeDistance;
    NSString *_phoneText;
}
@end

@implementation LxmSetSubInfoVC

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
//                                                name:UITextFieldTextDidChangeNotification object:nil];
    
    self.navigationItem.title = @"添加信息";

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW*0.5-50, 25, 100, 100)];
    _headerImgView.image = [UIImage imageNamed:@"pic_1"];
    _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgView.layer.cornerRadius = 50;
    _headerImgView.tag = 33;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touxiangBtnClick)];
    [_headerImgView addGestureRecognizer:tapGesturRecognizer];
    [headerView addSubview:_headerImgView];

    
    _jixingView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 50)];
    _jixingView.backgroundColor = [UIColor whiteColor];
    _jixingView.leftLab.text = @"机型";
    _jixingView.rightTF.text = @"子机";
    _jixingView.rightTF.enabled = NO;
    [self.tableView addSubview:_jixingView];
    
    
    _nickNameView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 200.5, ScreenW, 50)];
    _nickNameView.backgroundColor = [UIColor whiteColor];
    _nickNameView.leftLab.text = @"设备昵称";
    _nickNameView.rightTF.placeholder = @"请输入设备昵称";
    _nickNameView.rightTF.delegate = self;
    _nickNameView.rightTF.tag = 100;
    [self.tableView addSubview:_nickNameView];
    
    _phoneView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 251, ScreenW, 50)];
    _phoneView.backgroundColor = [UIColor whiteColor];
    _phoneView.leftLab.text = @"紧急电话";
    _phoneView.rightTF.placeholder = @"请输入紧急电话";
    _phoneView.rightTF.delegate = self;
    _phoneView.rightTF.tag = 100;
    _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.tableView addSubview:_phoneView];
    
    UIImageView * typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_styleView.rightBtn.frame.size.width-40, 0, 40, 40)];
    _typeImgView = typeImgView;
    typeImgView.image = [UIImage imageNamed:@"ico_9_xia"];
    [_styleView.rightBtn addSubview:typeImgView];
    
    _distanceView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 301.5, ScreenW, 50)];
    _distanceView.backgroundColor = [UIColor whiteColor];
    _distanceView.leftLab.text = @"安全距离";
    _distanceView.rightTF.placeholder = @"请输入和主机的安全距离(1-50m)";
    _distanceView.rightTF.font = [UIFont systemFontOfSize:15];
    _distanceView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.tableView addSubview:_distanceView];
    
    
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 370, ScreenW, 56)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview: footerView];
  
    
    UIButton * addSubBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, ScreenW-30, 40)];
    addSubBtn.tag = 100;
    [addSubBtn setBackgroundImage:[UIImage imageNamed:@"bg_8"] forState:UIControlStateNormal];
    [addSubBtn setTitle:@"添加设备" forState:UIControlStateNormal];
    [addSubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addSubBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addSubBtn.layer.cornerRadius = 10;
    addSubBtn.layer.masksToBounds = YES;
    [footerView addSubview:addSubBtn];
  
    
    _selectView = [[LxmStyleSelectView alloc] initWithFrame:self.view.bounds];
    _selectView.str = @"1";
    _selectView.delegate = self;
    
    _gifImgView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenW *0.5-50, ScreenH*0.5-50-64 , 100, 100)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gifTest" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    _gifImgView.image = image;
    _gifImgView.hidden = YES;
    [self.tableView addSubview:_gifImgView];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger length = [newString charactorNumber];//转换过的长度
    NSLog(@"%@------长度: %ld",newString,length);

    if (textField.tag == 100) {
        if (length >4) {
            return NO;
        }else {
            return YES;
        }
    }else if (textField.tag == 101) {
        if (length > 11) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

//- (void)textFiledEditChanged:(id)notification {
//    UITextRange *selectedRange = _nickNameView.rightTF.markedTextRange;
//    //过滤非汉字字符
//    UITextPosition *position = [_nickNameView.rightTF positionFromPosition:selectedRange.start offset:0];
//    if (!position) {
//        _nickNameView.rightTF.text = [self filterCharactor:_nickNameView.rightTF.text withRegex:@"[^\u4e00-\u9fa5]"];
//        if (_nickNameView.rightTF.text.length >= 2) {
//            _nickNameView.rightTF.text = [_nickNameView.rightTF.text substringToIndex:2];
//        }
//    }
//}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

-(void)LxmStyleSelectViewWillDismiss:(LxmStyleSelectView *)view
{
    _typeImgView.transform = CGAffineTransformIdentity;
    _styleView.rightBtn.selected = NO;
    [view dismiss];
}

-(void)LxmStyleSelectView:(LxmStyleSelectView *)view text:(NSString *)text index:(NSInteger)index
{
    //报警方式选择的代理
    _typeImgView.transform = CGAffineTransformIdentity;
    _styleView.rightBtn.selected = NO;
    [_selectView dismiss];
    _alertType = index;
    _styleView.rightLab.text = text;
    
}
- (void)addBtnClick:(UIButton *)btn
{
    if (btn.tag == 99) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            _typeImgView.transform = CGAffineTransformMakeRotation(M_PI);
            [_selectView show];
        }
        else{
            _typeImgView.transform = CGAffineTransformIdentity;
            [_selectView dismiss];
            _styleView.rightBtn.selected = NO;
        }
    } else {
        [self.tableView endEditing:YES];
        if (!self.isConnectWork) {
          [SVProgressHUD showErrorWithStatus:@"当前无互联网连接!"];
          return;
        }
        if (_headerImgView.tag == 33) {
            [SVProgressHUD showErrorWithStatus:@"请上传设备头像"];
            return;
        }
        if (_nickNameView.rightTF.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入1~2汉字的设备名称"];
            return;
        }
        
//        if (_nickNameView.rightTF.text.length != 2) {
//            [SVProgressHUD showErrorWithStatus:@"请输入2个字设备名称"];
//            return;
//        }
        
        if (_nickNameView.rightTF.text.length > 2) {
            [SVProgressHUD showErrorWithStatus:@"请输入1~2汉字的设备名称"];
            return;
        }
        if (_phoneView.rightTF.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入11位的联系电话"];
            return;
        }
        if (_distanceView.rightTF.text.length < 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入报警距离"];
            return;
        }
        if (_distanceView.rightTF.text.floatValue < 0 || _distanceView.rightTF.text.floatValue > 50) {
            [SVProgressHUD showErrorWithStatus:@"报警距离在0~50m之间"];
            return;
        }
        
        if (LxmBLEManager.shareManager.isTongbuStep || LxmBLEManager.shareManager.isTongbuDistance) {
            [SVProgressHUD showErrorWithStatus:@"正在同步硬件数据!,所有硬件相关操作暂不能执行!"];
            return;
        }
        
        NSString *tongxinId = self.peripheral.tongxinId;
        
        // 添加子机步骤
        // 1.设置子机紧急联系电话
        if (self.peripheral.state != CBPeripheralStateConnected) {
            [SVProgressHUD showErrorWithStatus:@"设备已断开连接!"];
            return;
        }
        
        btn.userInteractionEnabled = NO;
        WeakObj(self);
        
        void(^addInfo)(void) = ^(void) {
            NSLog(@"token:%@",[LxmTool ShareTool].session_token);
            // 5.获取版本号
            NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,
                                   @"nickname":_nickNameView.rightTF.text,
                                   @"communication":tongxinId,
                                   @"safeDistance":@([_distanceView.rightTF.text intValue]),
                                   @"hVersion":selfWeak.peripheral.hVersion ? selfWeak.peripheral.hVersion :@"",
                                   @"fVersion":selfWeak.peripheral.fVersion ? selfWeak.peripheral.fVersion : @"",
                                   @"identifier":tongxinId,
                                   @"parentId":selfWeak.parentId,
                                   @"criticalTel": _phoneView.rightTF.text
                                   };
            NSString * str = [LxmURLDefine getsubDeviceInfoURL];
            [LxmNetworking NetWorkingUpLoad:str image:_headerImgView.image image1:nil parameters:dic name:@"equHead" name1:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                _gifImgView.hidden = YES;
                btn.userInteractionEnabled = YES;
                
                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingListChanged" object:nil];
                    [LxmEventBus sendEvent:@"subdeviceBandSuccess" data:nil];
                    
                    BOOL ishave = NO;
                    UIViewController *tempVC;
                    NSArray *temArray = self.navigationController.viewControllers;
                    for (UIViewController *temVC in temArray) {
                        if ([temVC isKindOfClass:[LxmConnectedVC class]]){
                            ishave = YES;
                            tempVC = temVC;
                            break;
                        }
                    }
                    if (ishave) {
                         [self.navigationController popToViewController:tempVC animated:YES];
                    } else {
                        LxmBangDingSuccessVC * vc = [[LxmBangDingSuccessVC alloc] init];
                        vc.deviceType = @"子机";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                btn.userInteractionEnabled = YES;
                _gifImgView.hidden = YES;
            }];
        };
        
        void(^setSubInfoBlock)(void) = ^(void) {
            // 1.添加子机到母机列表
            WeakObj(self);
            _gifImgView.hidden = NO;
            [LxmBLEManager.shareManager addDevice:selfWeak.peripheral deviceName:_nickNameView.rightTF.text toDevice:LxmBLEManager.shareManager.master completed:^(BOOL success, NSString *tips) {
                     if (success) {
                         // 1.添加母机到子机列表
                         [LxmBLEManager.shareManager addDevice:LxmBLEManager.shareManager.master deviceName:_nickNameView.rightTF.text toDevice:selfWeak.peripheral completed:^(BOOL success, NSString *tips) {
                             if (success) {
                                 addInfo();
                                 [LxmBLEManager.shareManager setSubDevicePhone:self.peripheral phone:_phoneView.rightTF.text completed:^(BOOL success, NSString *tips) {
                                     if (success) {
                                         // 4.设置子机安全距离
                                         [[LxmBLEManager shareManager] setDistance:selfWeak.peripheral.tongxinId distance:_distanceView.rightTF.text.intValue completed:^(BOOL success, NSString *tips) {
                                             if (success) {
                                                 selfWeak.peripheral.safeDistance = @([_distanceView.rightTF.text intValue]).stringValue;
                                                 _safeDistance = @([_distanceView.rightTF.text intValue]).stringValue;
                                              
                                             } else {
                                                 btn.userInteractionEnabled = YES;
                                                 _gifImgView.hidden = YES;
                                                 [SVProgressHUD showErrorWithStatus:tips];
                                                 selfWeak.peripheral.safeDistance = @(0).stringValue;
                                                 _safeDistance = selfWeak.peripheral.safeDistance = @(0).stringValue;
                                             }
                                         }];
                                           
                                     } else {
                                         btn.userInteractionEnabled = YES;
                                         _gifImgView.hidden = YES;
                                         [SVProgressHUD showErrorWithStatus:tips];
                                         selfWeak.peripheral.safeDistance = @(0).stringValue;
                                         _safeDistance = selfWeak.peripheral.safeDistance = @(0).stringValue;
                                     }
                                 }];
                             } else {
                                 [SVProgressHUD showErrorWithStatus:@"添加子机到主机列表失败!"];
                                  btn.userInteractionEnabled = YES;
                                  _gifImgView.hidden = YES;
                                 [LxmBLEManager.shareManager delDevice:selfWeak.peripheral fromDevice:LxmBLEManager.shareManager.master completed:^(BOOL success, NSString *tips) {}];
                             }
                         }];
                     } else {
                         [SVProgressHUD showErrorWithStatus:@"添加子机到主机列表失败!"];
                         btn.userInteractionEnabled = YES;
                         _gifImgView.hidden = YES;
                        [SVProgressHUD showErrorWithStatus:tips];
                     }
                  }];
        };
        
        void(^subdeBlock)(void) = ^(void){
            CBPeripheral *master = LxmBLEManager.shareManager.master;
            if (master.state != CBPeripheralStateConnected) {
               [[LxmBLEManager shareManager] connectPeripheral:LxmBLEManager.shareManager.master completed:^(BOOL success, CBPeripheral *per) {
                   [SVProgressHUD dismiss];
                   if (success) {
                       setSubInfoBlock();
                   } else {
                       [SVProgressHUD showErrorWithStatus:@"母机连接失败"];
                   }
               }];
            } else {
                setSubInfoBlock();
            }
        };
        
        
        // 2.添加子机到母鸡列表
        if (selfWeak.peripheral.state != CBPeripheralStateConnected) {
            [[LxmBLEManager shareManager] connectPeripheral:selfWeak.peripheral completed:^(BOOL success, CBPeripheral *per) {
                if (success) {
                    subdeBlock();
                } else {
                    [SVProgressHUD showErrorWithStatus:@"子机连接失败"];
                }
            }];
        } else {
            subdeBlock();
        };
    }
}

-(void)touxiangBtnClick
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_xiangce completed:^(UIImage *image, NSString *filePath) {
            _headerImgView.image = image;
            _headerImgView.tag = 22;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerWithAction:OpenImagePickerAction_paizhao completed:^(UIImage *image, NSString *filePath) {
            _headerImgView.image = image;
            _headerImgView.tag = 22;
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
