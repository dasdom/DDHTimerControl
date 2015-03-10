#DDHTimerControl

A control to input minutes or seconds.

![](https://raw.githubusercontent.com/dasdom/DDHTimerControl/master/what.gif)


##Usage

    DDHTimerControl *timerControl = [DDHTimerControl timerControlWithType:DDHTimerTypeEqualElements];
    timerControl.translatesAutoresizingMaskIntoConstraints = NO;
    timerControl.color = [UIColor orangeColor];
    timerControl.highlightColor = [UIColor redColor];
    timerControl.minutesOrSeconds = 11;
    timerControl.titleLabel.text = @"min";
    timerControl.userInteractionEnabled = NO;
    [contentView addSubview:timerControl];
    

Currently there are three types supported:

    /**
     *  Type of the timer ring
     */
    typedef NS_ENUM(NSUInteger, DDHTimerType) {
        /**
         *  The ring looks like a clock
         */
        DDHTimerTypeElements = 0,
        /**
         *  All the elements are equal
         */
        DDHTimerTypeEqualElements,
        /**
         *  The ring is a solid line
         */
        DDHTimerTypeSolid,
        /**
         *  The number of the different types
         */
        DDHTimerTypeNumberOfTypes
    };

    
##Requirements

ARC and iOS7

##Installation

### Using CocoaPods

DDHTimerControl is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "DDHTimerControl"

### Manual

Download the project and add the files `DDHTimerControl.{h,m}` to your project.

## Author

Dominik Hauser, dominik.hauser@dasdom.de

## License

DDHTimerControl is available under the MIT license. See the LICENSE file for more info.


