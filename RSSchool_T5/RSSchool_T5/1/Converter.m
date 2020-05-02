#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSString *result = @"";
    NSDictionary *dictOfNumFormat = @{@"7": @"RU", @"77": @"KZ", @"373": @"MD", @"374": @"AM", @"375": @"BY", @"380": @"UA", @"992": @"TJ", @"993": @"TM", @"994": @"AZ", @"996": @"KG", @"998": @"UZ"};
    NSMutableString *mutString = [[NSMutableString alloc] initWithString:string];
    NSArray<NSDictionary *> *arr = @[ @{@3: @" (", @5: @") ", @8: @"-"},
                                      @{@3: @" (", @5: @") ", @8: @"-", @10: @"-"},
                                      @{@1: @" (", @4: @") ", @7: @"-", @9: @"-"}];
    
    NSString *country = @"";
    
    if ([[mutString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"]) {
        [mutString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    if (mutString.length > 1 && (country = dictOfNumFormat[[mutString substringWithRange:NSMakeRange(0, 2)]]) != nil) {
        mutString = mutString.length-1 > 10 ? (NSMutableString *)[mutString substringWithRange:NSMakeRange(0, 11)] : mutString;
        result = [self setFormat:mutString formatNum:arr[2]];
    } else if ((country = dictOfNumFormat[[mutString substringWithRange:NSMakeRange(0, 1)]]) != nil) {
        mutString = mutString.length-1 > 10 ? (NSMutableString *)[mutString substringWithRange:NSMakeRange(0, 11)] : mutString;
        result = [self setFormat:mutString formatNum:arr[2]];
    } else if (mutString.length <= 3 && dictOfNumFormat[mutString] == nil) {
        [mutString insertString:@"+" atIndex:0];
        result = mutString;
        country = @"";
    } else if ([[mutString substringWithRange:NSMakeRange(0, 3)] isEqualToString: @"373"] ||
               [[mutString substringWithRange:NSMakeRange(0, 3)] isEqualToString: @"374"] ||
               [[mutString substringWithRange:NSMakeRange(0, 3)] isEqualToString: @"993"]) {
        mutString = mutString.length-3 > 9 ? (NSMutableString *)[mutString substringWithRange:NSMakeRange(0, 11)] : mutString;
        
        country = dictOfNumFormat[[mutString substringWithRange:NSMakeRange(0, 3)]];
        result = [self setFormat:mutString formatNum:arr[0]];
    } else if (dictOfNumFormat[[mutString substringWithRange:NSMakeRange(0, 3)]] == nil) {
        [mutString insertString:@"+" atIndex:0];
        mutString = mutString.length-3 > 12 ? (NSMutableString *)[mutString substringWithRange:NSMakeRange(0, 13)] : mutString;
        result = mutString;
        country = @"";
        
    } else {
        mutString = mutString.length-3 > 9 ? (NSMutableString *)[mutString substringWithRange:NSMakeRange(0, 12)] : mutString;
        country = dictOfNumFormat[[mutString substringWithRange:NSMakeRange(0, 3)]];
        result = [self setFormat:mutString formatNum:arr[1]];
    }
    
    
    return @{KeyPhoneNumber: result,
             KeyCountry: country};
}


- (NSMutableString *)setFormat:(NSMutableString *)input formatNum:(NSDictionary *)format {
    NSMutableString* buff = [[NSMutableString alloc] initWithString:@"+"];
    NSString *fh = @"";
    for (long i = 0; i < input.length; i++) {
        
        if ((fh = format[[NSNumber numberWithInteger:i]]) != nil) {
            [buff appendFormat:@"%@", fh];
        }
        
        [buff appendFormat:@"%@", [input substringWithRange:NSMakeRange(i, 1)]];
        
    }
    return buff;
}


@end
