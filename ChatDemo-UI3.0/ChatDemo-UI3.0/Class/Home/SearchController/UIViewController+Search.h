//
//  UIViewController+Search.h
//  DXStudio
//
//  Created by XieYajie on 22/09/2017.
//  Copyright © 2017 dxstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHSearchResultController.h"

@interface UIViewController (Search) <UISearchBarDelegate>

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) XHSearchResultController *resultController;

@property (nonatomic, strong) UINavigationController *resultNavigationController;

- (void)enableSearchController;

- (void)disableSearchController;

- (void)cancelSearch;

@end

