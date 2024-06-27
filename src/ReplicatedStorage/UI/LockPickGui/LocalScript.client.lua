--Made By Timme, Please Read the Comments Carefully.
local screenGui = script.Parent

local speed = 0.6

--||Parts of the lockpick gui||--
local main = screenGui:WaitForChild("Main")
local frame1 = main:WaitForChild("Frame1")
local frame2 = main:WaitForChild("Frame2")
local frame3 = main:WaitForChild("Frame3")
local frame4 = main:WaitForChild("Frame4")
local frame5 = main:WaitForChild("Frame5")

--||Services||--
local TweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local player = players.LocalPlayer or players.PlayerAdded:Wait()
local mouse = player:GetMouse()

local locksfx = script.Lock
local lockfailedsfx = script.LockFailed

--||RemoteEvents||--
local event = game.ReplicatedStorage.Events.Lockpick

--||Tweens||--(IF you want to add more, create new variables and tween for the frame and change the Xscale looking at wher you placed the frame on the gui.)
local tweeninfo = TweenInfo.new(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local frame2tween1 = TweenService:Create(frame2, tweeninfo , {Position = UDim2.new(0.169, 0,0.795, 0)})--The Xscale number is 0.169 for this frame
local frame2tween2 = TweenService:Create(frame2, tweeninfo , {Position = UDim2.new(0.169, 0,0.189, 0)})
local frame3tween1 = TweenService:Create(frame3, tweeninfo , {Position = UDim2.new(0.494, 0,0.189, 0)})
local frame3tween2 = TweenService:Create(frame3, tweeninfo , {Position = UDim2.new(0.494, 0,0.795, 0)})
local frame4tween1 = TweenService:Create(frame4, tweeninfo , {Position = UDim2.new(0.787, 0,0.795, 0)})
local frame4tween2 = TweenService:Create(frame4, tweeninfo , {Position = UDim2.new(0.787, 0,0.189, 0)})

--||Values||--
local ended = false
local Box = 1
local box1ended = false
local box2ended = false
local box3ended = false

--||Functions||--
local function checkPosition(frame, mid)--doesn't really matter what order of the parameter you sent just make sure one is the middle line(frame1) and one is the box.
 	local a1 = frame.AbsolutePosition.Y
	local b1 = mid.AbsolutePosition.Y

	local a2 = a1 + frame.AbsoluteSize.Y
	local b2 = b1 + mid.AbsoluteSize.Y

	if (b1 <= a1 and b2 <= a1) or (a2 <= b1 and a2 <= b2) then
		print('Vertical bounds do not overlap')
		return false
	else
		print('Vertical bounds overlap')
		return true
	end
end

mouse.Button1Down:Connect(function()
	if ended == false then
		if Box == 1 then
			if checkPosition(frame1,frame2) == true then
				locksfx:Play()
				Box = 2
				frame2tween1:Pause()
				frame2tween2:Pause()
				box1ended = true--Makes sure it wont keep tweening
			elseif checkPosition(frame1,frame2) == false then
				ended = true
				lockfailedsfx:Play()
				task.wait(1.5)
				screenGui:Destroy()
			end
		elseif Box == 2 then
			if checkPosition(frame1,frame3) == true then
				locksfx:Play()
				Box = 3
				frame3tween1:Pause()
				frame3tween2:Pause()
				box2ended = true--Makes sure it wont keep tweening
			elseif checkPosition(frame1,frame3) == false then
				ended = true
				lockfailedsfx:Play()
				task.wait(1.5)
				screenGui:Destroy()
			end
		elseif Box == 3 then
			if checkPosition(frame1,frame4) == true then
				ended = true
				locksfx:Play()
				Box = 1
				frame4tween1:Pause()
				frame4tween2:Pause()
				box3ended = true
				event:FireServer(screenGui.CurrentID.Value)
				task.wait(0.5)
				screenGui:Destroy()
			elseif checkPosition(frame1,frame4) == false then
				ended = true
				lockfailedsfx:Play()
				task.wait(1.5)
				screenGui:Destroy()
			end
		end
	end
end)

--||Close Button||--
frame5.TextButton.MouseButton1Down:Connect(function()
	screenGui:Destroy()
end)

--||Tween Boxes||--
local function TweenFrame2()
	repeat
		if box1ended == false then
			frame2tween1:Play()
		end
		task.wait(speed)
		if box1ended == false then
			frame2tween2:Play()
		end
		task.wait(speed)
	until ended == true or box1ended == true
end

local function TweenFrame3()
	repeat
		if box2ended == false then
			frame3tween1:Play()
		end
		task.wait(speed)
		if box2ended == false then
			frame3tween2:Play()
		end
		task.wait(speed)
	until ended == true or box2ended == true
end

local function TweenFrame4()
	repeat
		if box3ended == false then
		   frame4tween1:Play()
		end
		task.wait(speed)
		if box3ended == false then
		   frame4tween2:Play()
		end
		task.wait(speed)
	until ended == true or box3ended == true
end

--||Box Tween Animations||--
task.spawn(TweenFrame2)
task.spawn(TweenFrame3)
task.spawn(TweenFrame4)