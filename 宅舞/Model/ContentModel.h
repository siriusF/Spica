//
//  ContentModel.h
//  宅舞
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 beizi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject


@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *idMark;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSString *creatDate;
@property (nonatomic, copy) NSString *playTimes;
@property (nonatomic, copy) NSString *smallThumbUrl;

@end
