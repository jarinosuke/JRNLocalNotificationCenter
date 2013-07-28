test:
	xcodebuild \
		-sdk iphonesimulator \
		-project DemoApp.xcodeproj \
		-target JRNLocalNotificationCenterTest \
		-configuration Debug \
		clean build \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
