test:
	xcodebuild \
		-sdk iphonesimulator \
		-project DemoApp.xcodeproj \
    -scheme DemoApp \
		-configuration Debug \
		clean build test\
		ONLY_ACTIVE_ARCH=NO \
