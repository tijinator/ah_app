#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AWSDynamoDB.h"
#import "AWSDynamoDBModel.h"
#import "AWSDynamoDBObjectMapper.h"
#import "AWSDynamoDBResources.h"
#import "AWSDynamoDBService.h"

FOUNDATION_EXPORT double AWSDynamoDBVersionNumber;
FOUNDATION_EXPORT const unsigned char AWSDynamoDBVersionString[];

