-- Madonox
-- 2023

-- Basic service used for world queries.

local QueryService = setmetatable({},{__tostring=function()
	return "AnticheatService"
end})

local Params = OverlapParams.new()
Params.MaxParts = 500
Params.FilterType = Enum.RaycastFilterType.Blacklist

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

function QueryService:PartsInRange(origin:Vector3,radius:number,customIgnore)
	Params.FilterDescendantsInstances = customIgnore
	return workspace:GetPartBoundsInRadius(origin,radius,Params)
end

function QueryService:RaycastDistance(origin:Vector3,direction:Vector3,distance:number,customIgnore)
	local unit = direction.Unit
	RayParams.FilterDescendantsInstances = customIgnore
	return workspace:Raycast(origin,direction*distance,RayParams) or {
		Position = origin+unit*distance
	}
end

return QueryService