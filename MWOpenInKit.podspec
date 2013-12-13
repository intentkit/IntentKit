Pod::Spec.new do |s|
  s.name      = 'MWOpenInKit'
  s.version   = '0.1.0'
  s.license   = { :type => 'MIT', :file => "LICENSE" }
  s.summary   = "An easier way to handle third-party URL schemes in iOS apps."
  s.homepage  = 'https://github.com/lazerwalker/MWOpenInKit'
  s.authors   = { 'Mike Walker' => 'michael@lazerwalker.com' }
  s.source    = { :git => 'https://github.com/lazerwalker/MWOpenInKit.git', :tag => '0.1.0' }
  s.requires_arc = true
  s.platform  = :ios, '7.0'

  s.source_files = 'MWOpenInKit', 'MWOpenInKit/**/*.{h,m}'

  s.subspec 'Browsers' do |ss|
    ss.subspec 'Chrome' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Chrome/*.{plist,png}" }
    end

    ss.subspec 'Safari' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Safari/*.{plist,png}" }
    end
  end

  s.subspec 'Maps' do |ss|
    ss.subspec 'Google Maps' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Google Maps/*.{plist,png}" }
    end

    ss.subspec 'Maps' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Maps/*.{plist,png}" }
    end
  end

  s.subspec 'Passwords' do |ss|
    ss.subspec '1Password' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/1Password/*.{plist,png}" }
    end
  end

  s.subspec 'Twitter' do |ss|
    ss.subspec 'Tweetbot' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Tweetbot/*.{plist,png}" }
    end

    ss.subspec 'Twitter' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Twitter/*.{plist,png}" }
    end

    ss.subspec 'Twitterrific' do |sss|
      sss.resource_bundles = { 'MWOpenInKit' => "MWOpenInKit/Apps/Twitterrific/*.{plist,png}" }
    end
  end
end
