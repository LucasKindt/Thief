local MorningGoldenHour = {
	Lighting = {
		Ambient = Color3.fromRGB(84, 74, 99);
		Brightness = 5;
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
		ColorShift_Top = Color3.fromRGB(223, 158, 211);
		EnvironmentDiffuseScale = 1;
		EnvironmentSpecularScale = 1;
		OutdoorAmbient = Color3.fromRGB(123, 125, 158);
		ShadowSoftness = 0.15;
		ExposureCompensation = 0.45;
	};

	Bloom = {
		Intensity = 0.1;
		Size = 20;
		Threshold = 1;
	};

	Blur = {
		Size = 2;
	};

	ColorCorrection = {
		Brightness = 0.03;
		Contrast = 0.05;
		Saturation = 0;
		TintColor = Color3.fromRGB(255, 241, 208);
	};

	DepthOfField = {
		FarIntensity = 0.05;
		FocusDistance = 47.36;
		InFocusRadius = 46;
		NearIntensity = 0.21;
	};

	SunRays = {
		Intensity = 0.07;
		Spread = 0.449;
	};

	Atmosphere = {
		Density = 0.32;
		Offset = 0;
		Color = Color3.fromRGB(199, 199, 199);
		Decay = Color3.fromRGB(106, 112, 125);
		Glare = 0;
		Haze = 0;
	};

	Clouds = {
		Cover = 0.603;
		Density = 0.974;
		Color = Color3.fromRGB(208, 206, 208);
	}
}

return MorningGoldenHour
