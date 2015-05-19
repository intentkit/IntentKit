Pod::Spec.new do |s|
  s.name      = 'IntentKit'
  s.version   = '0.7.1'
  s.license   = { :type => 'MIT', :file => "LICENSE" }
  s.summary   = "An easier way to handle third-party URL schemes in iOS apps."
  s.homepage  = 'https://github.com/intentkit/IntentKit'
  s.authors   = { 'Mike Walker' => 'michael@lazerwalker.com' }
  s.source    = { :git => 'https://github.com/intentkit/IntentKit.git', :tag => "0.7.1" }
  s.requires_arc = true
  s.platform  = :ios, '7.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'IntentKit', 'IntentKit/Core/**/*.{h,m}', "IntentKit/Handlers/INKBrowserHandler.{h,m}", 'IntentKit/Apps/INKWebView/*.{h,m}'
    ss.dependency "MWLayoutHelpers"
    ss.resource_bundles = { 'IntentKit' => 'IntentKit/{**/*.strings,Images/*.png}',
                            'IntentKit-Defaults' => "IntentKit/Apps/Defaults/*.{plist,png}",
                            'IntentKit-INKBrowserHandler' => "IntentKit/Apps/{Chrome,Safari,1Password,INKWebView}/*.{plist,png}" }
    ss.requires_arc = true
  end

  s.subspec 'Twitter' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKTwitterHandler.{h,m}', 'IntentKit/Apps/INKTweetSheet/*.{h,m}'
    ss.resource_bundles = { 'IntentKit-INKTwitterHandler' => "IntentKit/Apps/{Twitter,Twitterrific,Tweetbot,INKTweetSheet}/*.{plist,png}" }
    ss.framework = "Twitter"
    ss.requires_arc = true
  end

  s.subspec 'Maps' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKMapsHandler.{h,m}'
    ss.resource_bundles = { 'IntentKit-INKMapsHandler' => "IntentKit/Apps/{Maps,Google Maps,Waze}/*.{plist,png}" }
    ss.requires_arc = true
  end

  s.subspec 'Mail' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKMailHandler.{h,m}', "IntentKit/Apps/INKMailSheet/*.{h,m}"
    ss.resource_bundles = { 'IntentKit-INKMailHandler' => "IntentKit/Apps/{Mail,Gmail,INKMailSheet}/*.{plist,png}" }
    ss.framework = "MessageUI"
    ss.requires_arc = true
  end

  s.subspec 'Facebook' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKFacebookHandler.{h,m}'
    ss.resource_bundles = { 'IntentKit-INKFacebookHandler' => "IntentKit/Apps/Facebook/*.{plist,png}" }
    ss.requires_arc = true
  end

  s.subspec 'GPlus' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKGPlusHandler.{h,m}'
    ss.resource_bundles = { 'IntentKit-INKGPlusHandler' => "IntentKit/Apps/Google+/*.{plist,png}" }
    ss.requires_arc = true
  end

  s.subspec 'Message' do |ss|
    ss.dependency 'IntentKit/Core'
    ss.source_files = 'IntentKit/Handlers/INKMessageHandler.{h,m}'
    ss.resource_bundles = { 'IntentKit-INKMessageHandler' => "IntentKit/Apps/{Phone,Messanger}/*.{plist,png}" }
    ss.requires_arc = true
  end
end
