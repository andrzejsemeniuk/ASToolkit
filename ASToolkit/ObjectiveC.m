//
//  ObjectiveC.m
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/29/18.
//  Copyright © 2018 Andrzej Semeniuk. All rights reserved.
//

#import "ObjectiveC.h"

#import "ObjectiveC.h"

@implementation ObjectiveC

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
