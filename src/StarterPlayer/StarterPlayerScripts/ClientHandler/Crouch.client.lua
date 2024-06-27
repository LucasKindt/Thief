local PCInput = Enum.KeyCode.C
local ConsoleInput = Enum.KeyCode.ButtonB

local IsCrouching = false

local plr = game:GetService("Players").LocalPlayer
local Character = plr.Character or plr.CharacterAdded:Wait()

local AnimationID = "rbxassetid://18117403395" -- paste your id for animation here
local Animation  = Instance.new("Animation")
Animation.Parent = Character
Animation.AnimationId = AnimationID
Animation.Name = "CrouchAnimation"

local HM = Character:WaitForChild("Humanoid")

local LoadedAnimation = Character:WaitForChild("Humanoid"):LoadAnimation(Animation)

local UIS = game:GetService("UserInputService") -- User input service for detecting input

UIS.InputBegan:Connect(function(input, gpe)

	if input.UserInputType == Enum.UserInputType.Keyboard then

		if input.KeyCode == PCInput then

			IsCrouching = not IsCrouching

			if IsCrouching then

				HM.CameraOffset = HM.CameraOffset - Vector3.new(0,2,0)

			elseif IsCrouching == false then

				HM.CameraOffset = HM.CameraOffset - Vector3.new(0,-2,0)

			end

		end

	elseif input.UserInputType == Enum.UserInputType.Gamepad1 then

		if input.KeyCode == ConsoleInput then

			IsCrouching = not IsCrouching

			if IsCrouching then

				LoadedAnimation:Play()

			elseif IsCrouching == false then

				LoadedAnimation:Stop()

			end

		end		

	end

end)