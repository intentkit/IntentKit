task :default => :test

task :test do
  sh 'xcodebuild clean test -workspace IntentKitDemo.xcworkspace -scheme IntentKitDemo -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO | xcpretty -tc && exit ${PIPESTATUS[0]}'
end
