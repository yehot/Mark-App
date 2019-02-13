source 'git@code.aliyun.com:xhzy-ios/frameworkplatform.git'
source 'git@github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def common_pod

    # network
    pod 'APIKit', '~> 4.0.0'

    pod 'Kingfisher', '~> 4.10.1'

    # UI
    pod 'FoldingCell', '~> 4.0.2'
    pod 'PopupDialog', '~> 0.9.2'
    pod 'Toast-Swift', '~> 4.0.1'
    pod 'MJRefresh', '~> 3.1.15'            # OC
    pod 'PhotoBrowser', '~> 0.7.0'
    pod 'SkeletonView', '~> 1.4.1'
    pod 'NVActivityIndicatorView', '~> 4.6.1'

    # layout
    pod 'EasyPeasy', '~> 1.8.0'
    pod 'SnapKit', '~> 4.2.0'

    # rx
    pod 'RxSwift', '~> 4.4.0'
    pod 'RxCocoa', '~> 4.4.0'

    # utils
    pod 'SwifterSwift', '~> 4.6.0'          # tools
    pod 'SwiftyJSON', '~> 4.0.0'            # json data to json object
    pod 'HandyJSON', '~> 4.2.1'         # json to model
    pod 'Then', '~> 2.3.0'
#    pod 'MonkeyKing', '~> 1.4.2'            # social

end

target 'SHWMark' do

    common_pod
    
    target 'SHWMarkTests' do
        inherit! :search_paths
    end
end
