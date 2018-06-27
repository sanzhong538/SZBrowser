//
//  MainTableView.m
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "MainTableView.h"

@implementation MainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return self.canSlip;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return self.stopSubViewSlip;
}

@end
