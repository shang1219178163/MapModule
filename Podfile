# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def common_pods
   pod 'AFNetworking’
   
   pod 'JZLocationConverter'
    
   pod 'KVOController'

   pod 'MBProgressHUD'
   pod 'MJRefresh'
   pod 'Masonry'
      
   pod 'SDWebImage'
   pod 'SVProgressHUD'
   pod 'Toast'
   
   pod 'YYCache'
   pod 'YYCategories'
   pod 'YYWebImage’
   pod 'YYModel’

   
   pod 'AMapSearch-NO-IDFA'
   pod 'AMapLocation-NO-IDFA'
   pod 'AMapNavi-NO-IDFA'
   
   # 主模块(必须)
#   pod 'mob_sharesdk'
#   pod 'mob_sharesdk/ShareSDKUI'
#   pod 'mob_sharesdk/ShareSDKExtension'# 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
#   pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
#   pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
#   pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull' #（微信sdk带支付的命令，和上面不带支付的不能共存，只能选择一个）

   pod 'NNGloble'
   pod 'NNCategoryPro'
   pod 'NNView'
#   pod 'NNTableViewCell'
#   pod 'NNCollectionView'
#   pod 'NNViewComplex'

 end

target 'MapModule' do
  # Pods for ProductTemplet
  common_pods
  
end


pre_install do |installer|
  puts "##### pre_install start #####"
  
  puts "##### pre_install end #####"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
#      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
