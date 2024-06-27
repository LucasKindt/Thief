local Day = {
	Lighting = {
		Ambient = Color3.fromRGB(113, 113, 81);
		Brightness = 4;
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
		ColorShift_Top = Color3.fromRGB(125, 123, 90);
		EnvironmentDiffuseScale = 1;
		EnvironmentSpecularScale = 1;
		OutdoorAmbient = Color3.fromRGB(0, 0, 0);
		ShadowSoftness = 0.15;
		ExposureCompensation = 0.3;
	};

	Bloom = {
		Intensity = 0.4;
		Size = 56;
		Threshold = 1;
	};

	Blur = {
		Size = 1;
	};

	ColorCorrection = {
		Brightness = 0.03;
		Contrast = 0.05;
		Saturation = 0;
		TintColor = Color3.fromRGB(255, 255, 255);
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
		Density = 0.31;
		Offset = 0;
		Color = Color3.fromRGB(199, 199, 199);
		Decay = Color3.fromRGB(106, 112, 125);
		Glare = 0;
		Haze = 0;
	};

	Clouds = {
		Cover = 0.603;
		Density = 0.974;
		Color = Color3.fromRGB(255, 255, 255);
	}
}
	
return Day
