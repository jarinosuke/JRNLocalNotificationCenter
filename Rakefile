DESTINATION = "name=iPhone 6,OS=8.1"
JRN_PROJECT    = "DemoApp.xcodeproj"
JRN_TEST_TARGET= "DemoAppTests"
JRN_SCHEME     = "DemoApp"

desc "unit test"
task :default do
  sh "xcodebuild clean test -sdk iphonesimulator -scheme #{JRN_SCHEME} -destination \"#{DESTINATION}\" -configuration Debug OBJROOT=build | bundle exec xcpretty -c && exit ${PIPESTATUS[0]}"
end
