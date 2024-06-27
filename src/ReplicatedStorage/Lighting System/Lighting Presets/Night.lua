local Night = {
	Lighting = {
		Ambient = Color3.fromRGB(0, 0, 0);
		Brightness = 1;
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
		ColorShift_Top = Color3.fromRGB(129, 158, 255);
		EnvironmentDiffuseScale = 0.65;
		EnvironmentSpecularScale = 1;
		OutdoorAmbient = Color3.fromRGB(68, 67, 97);
		ShadowSoftness = 0.15;
		ExposureCompensation = 0.8;
	};

	Bloom = {
		Intensity = 0.05;
		Size = 56;
		Threshold = 1;
	};

	Blur = {
		Size = 2.5;
	};

	ColorCorrection = {
		Brightness = 0.05;
		Contrast = 0.15;
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
		Intensity = 0.15;
		Spread = 0.449;
	};

	Atmosphere = {
		Density = 0.6;
		Offset = 0;
		Color = Color3.fromRGB(199, 199, 199);
		Decay = Color3.fromRGB(106, 112, 125);
		Glare = 0;
		Haze = 0;
	};

	Clouds = {
		Cover = 0.603;
		Density = 0.974;
		Color = Color3.fromRGB(40, 40, 40);
	}
}

return Night
