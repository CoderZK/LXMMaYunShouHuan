//
//  LxmFindFriendVC.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/6.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmFindFriendVC.h"
#import "LxmSubOtherBabyCell.h"
#import "LxmFriendRequestVC.h"
#import "LxmJiaZhangModel.h"
#import "LxmSendLimitRequestVC.h"

@interface LxmFindFriendVC ()<UITextFieldDelegate>
{
    UITextField *_tf;
    UILabel *_label1;
    UIImageView *_imgView2;
//    lxmFriendModel * _model;
    NSMutableArray * _dataArr;
}
@end

@implementation LxmFindFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    _dataArr = [NSMutableArray array];
    
}

- (void)initNav
{
    UIView * titleBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 34)];
    if (ScreenW<375) {
        titleBtn.frame = CGRectMake(0, 0, 180, 34);
    }else{
        titleBtn.frame = CGRectMake(0, 0, 230, 34);
    }
    self.navigationItem.titleView=titleBtn;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(-20, 0, CGRectGetWidth(titleBtn.frame), 30)];
    tf.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    tf.layer.cornerRadius = 8;
    tf.layer.masksToBounds = YES;
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    _tf = tf;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [titleBtn addSubview:imgView];
    
    UIImageView *imgView1= [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    imgView1.image = [UIImage imageNamed:@"ico_sousuo"];
    [imgView addSubview:imgView1];
    
    tf.leftView = imgView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号查找您的好友" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    tf.font = [UIFont systemFontOfSize:15];
    tf.textColor = [UIColor whiteColor];
    tf.textAlignment = NSTextAlignmentLeft;
    [titleBtn addSubview:tf];
    
    UIButton * rightBtnItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBtnItem addTarget:self action:@selector(rightBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    rightBtnItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _imgView2= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    _imgView2.image = [UIImage imageNamed:@"white"];
//    _imgView2.userInteractionEnabled = YES;
    [rightBtnItem addSubview:_imgView2];
    
    _label1= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    _label1.text = @"搜索";
//    _label1.userInteractionEnabled = YES;
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.textColor = CharacterDarkColor;
    _label1.font = [UIFont systemFontOfSize:15];
    [rightBtnItem addSubview:_label1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnItem];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count>=1) {
        return _dataArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LxmSubOtherBabyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSubOtherBabyCell"];
    if (!cell)
    {
        cell = [[LxmSubOtherBabyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSubOtherBabyCell"];
    }
    cell.foreverBtn.hidden = YES;
    lxmFriendModel * model = [_dataArr objectAtIndex:indexPath.row];
    if ([model.isFriend integerValue] == 1) {
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:model.realname];
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.bounds = CGRectMake(5, -2, 15, 15);//y可以控制对齐
        textAttachment.image = [UIImage imageNamed:@"bg_you"];
        //用图片资源初始化一个imgAtt
        NSAttributedString * imgAtt = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把imgAtt 插入到 att的前面
        [att insertAttributedString:imgAtt atIndex:model.realname.length];
        cell.nameLab.attributedText = att;
    }
    else
    {
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.realname];
    }

    [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_img_URL,model.headimg]] placeholderImage:[UIImage imageNamed:@"touxiang_moren"] options:SDWebImageRetryFailed];
    
    cell.phoneLab.text = [NSString stringWithFormat:@"%@",model.tel];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    lxmFriendModel * model = [_dataArr objectAtIndex:indexPath.row];
    if ([model.isFriend intValue] == 2) {
        UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"他还不是您的好友，请添加为您的好友" preferredStyle:UIAlertControllerStyleAlert];
        [controller1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [controller1 addAction:[UIAlertAction actionWithTitle:@"添加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD show];
            [LxmNetworking networkingPOST:[LxmURLDefine getApplyFriendURL] parameters:@{@"token":[LxmTool ShareTool].session_token,@"otherUserId":model.userId} success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];
                if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"请求发送成功"];
                }else{
                      [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        }]];
        [self presentViewController:controller1 animated:YES completion:nil];
    }else
    {
        if (self.starStr&&self.endTimeStr) {
            //限时委托
            LxmSendLimitRequestVC * vc = [[LxmSendLimitRequestVC alloc] init];
            vc.model = model;
            vc.childName = self.childName;
            vc.equId = self.equId;
            vc.starStr = self.starStr;
            vc.endTimeStr = self.endTimeStr;
            vc.authorizeType = @1;
            [self.navigationController pushViewController:vc animated:YES];

//
        }else{
            //永久委托
//            [dict setObject:@2 forKey:@"authorizeType"];
            LxmSendLimitRequestVC * vc = [[LxmSendLimitRequestVC alloc] init];
            vc.model = model;
            vc.authorizeType = @2;
            vc.childName = self.childName;
            vc.equId = self.equId;
            [self.navigationController pushViewController:vc animated:YES];

        }
       
    
    }
}

#pragma 搜索
- (void)rightBtnItem:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (_tf.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请输入搜索的手机号"];
            btn.selected = NO;
            return;
        }else{
            _label1.text = @"取消";
            _label1.textColor = [UIColor whiteColor];
            _imgView2.hidden = YES;
            [self loadData];
        }

    }else{
        _tf.text = nil;
        [_dataArr removeAllObjects];
        _label1.text = @"搜索";
        _label1.textColor = CharacterDarkColor;
        _imgView2.hidden = NO;
        [self.tableView reloadData];
    }
}

-(void)loadData
{
    [_tf endEditing:YES];
    NSString * str = [LxmURLDefine getSearchUserURL];
    NSDictionary * dic = @{@"token":[LxmTool ShareTool].session_token,@"search":_tf.text};
    [SVProgressHUD show];
    [_dataArr removeAllObjects];
    [LxmNetworking networkingPOST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            NSArray * arr = [responseObject objectForKey:@"result"];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary * dict in arr) {
                    lxmFriendModel * model = [lxmFriendModel mj_objectWithKeyValues:dict];
                    [_dataArr addObject:model];
                }
                
            }
            [self.tableView reloadData];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"] atVC:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];

}
#pragma 搜索代理事情
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当按下键盘上的return剑时调用这个delegate方法
    if (!(textField.text == nil || [textField.text isEqualToString:@""]))
    {
        [textField endEditing:YES];
        [self loadData];
       
    }
    return YES;
}


@end
