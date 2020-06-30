//
//  XMCalendarCell.m
//  日历
//
//  Created by RenXiangDong on 17/3/27.
//  Copyright © 2017年 RenXiangDong. All rights reserved.
//

#import "XMCalendarCell.h"

@interface XMCalendarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *currentDataImgView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarLabel;
@property (weak, nonatomic)XMCalendarModel * linModel;

@end
@implementation XMCalendarCell

+ (instancetype)cellWithCalendarModel:(XMCalendarModel *)model collectionView:(UICollectionView *)collectionVeiw indexpath:(NSIndexPath *)indexPath{
    static NSString *ID = @"XMCalendarCell";
    XMCalendarCell *cell = [collectionVeiw dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.currentDataImgView.layer.cornerRadius = 5;
    cell.currentDataImgView.layer.masksToBounds = YES;
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    cell.model = model;
    return cell;
}
- (void)setModel:(XMCalendarModel *)model {
    _linModel = model;
    self.lunarLabel.layer.cornerRadius = 3;
    self.lunarLabel.layer.masksToBounds = YES;
    self.lunarLabel.backgroundColor = [UIColor colorWithRed:250/255.0 green:208/255.0 blue:110/255.0 alpha:1];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",model.dateNumber];
    self.dayLabel.hidden = NO;
    NSLog(@"%@---有距离--%d,-----有计步----%d", model.date,model.isHaveDistanceDate,model.isHaveJiBuDate);
    if (model.type.intValue == 1) {//距离数据
        self.lunarLabel.hidden = !model.isHaveDistanceDate;
    } else {
        self.lunarLabel.hidden = !model.isHaveJiBuDate;
    }
    
    self.userInteractionEnabled = YES;
    self.selected = model.isCurrent;
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year1 = (int)[dateComponent year];
    int month1 = (int)[dateComponent month];
    int day1 = (int)[dateComponent day];

    NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:model.date];
    int year2 = (int)[dateComponent1 year];
    if (day1 == model.dateNumber && month1 == model.month && year1 == year2) {
        self.currentDataImgView.backgroundColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    }else{
        self.currentDataImgView.backgroundColor = UIColor.clearColor;
    }
    
//    if (model.isEmpty) {
////        self.dayLabel.hidden = YES;
////        self.lunarLabel.hidden = YES;
////        self.userInteractionEnabled = NO;
//
////        self.dayLabel.textColor = CharacterLightGrayColor;
////        self.lunarLabel.hidden = YES;
////        self.userInteractionEnabled = NO;
//
//    } else {
////        self.dayLabel.hidden = NO;
////        self.lunarLabel.hidden = NO;
////        self.userInteractionEnabled = YES;
////        if (model.holidayName != nil) {
//////            self.lunarLabel.text = model.holidayName;
////            self.lunarLabel.textColor = [UIColor colorWithRed:33/255.0 green:148/255.0 blue:202/255.0 alpha:1];
////        } else if (model.chinesDateNumber == 1) {
//////            self.lunarLabel.text = model.chinesMonthStr;
////            self.lunarLabel.textColor = [UIColor blackColor];
////        } else {
//////            self.lunarLabel.text = model.chinesDateStr;
////            self.lunarLabel.textColor = [UIColor blackColor];
////        }
//
//        NSDate *now = [NSDate date];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
//        int year1 = (int)[dateComponent year];
//        int month1 = (int)[dateComponent month];
//        int day1 = (int)[dateComponent day];
//
//        NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:model.date];
//        int year2 = (int)[dateComponent1 year];
//        if (day1 == model.dateNumber && month1 == model.month && year1 == year2) {
//            self.selected = YES;
//        }else{
//            self.selected = NO;
//        }
//    }
}

- (void)setSelected:(BOOL)selected {
    self.dayLabel.textColor = [UIColor whiteColor];
    self.lunarLabel.textColor = [UIColor whiteColor];
    
    if (selected) {
        self.currentDataImgView.image = [UIImage imageNamed:@"bg_riqi"];
        
    } else {
        self.currentDataImgView.image = [UIImage imageNamed:@""];
        
//        //改变周末字体颜色
//        if (_linModel.weakNumber == 7 || _linModel.weakNumber == 1) {
//            self.dayLabel.textColor = BlueColor;
//            self.lunarLabel.textColor = BlueColor;
//        }else{
//            self.dayLabel.textColor = [UIColor blackColor];
//            self.lunarLabel.textColor = [UIColor blackColor];
//        }

    }
}


@end
