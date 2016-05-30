//
//  Spica_RootViewController.h
//  宅舞
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 beizi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Spica_RootViewControllerType){
    Tweet_RootViewControllerTypeOne = 0,
    Tweet_RootViewControllerTypeTwo,
    Tweet_RootViewControllerTypeThree,
    Tweet_RootViewControllerTypeFour
};

@interface Spica_RootViewController : BaseViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

+ (instancetype)newTweetVCWithType:(Spica_RootViewControllerType)type;

@end
