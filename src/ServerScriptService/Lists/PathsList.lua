local properties = workspace.Properties

local PathsList = {
	['101'] = {
		['tenant1'] = {
			['firstLaunch'] = true,
			['name'] = 'biggy',
			['hearingDistance'] = 5,
			['routines'] = {
				['15:00:00'] = {
					['title'] = 'Kitchen',
					['waypoint'] = Vector3.new(-207.474, 6.362, 134.033),
					['action'] = 'idle',
					['actionObject'] = nil,
				},
				['15:30:00'] = {
					['title'] = 'Bedroom',
					['waypoint'] = Vector3.new(-228.543, 17.77, 154.605),
					['action'] = 'idle',
					['actionObject'] = nil,
				},
				['16:00:00'] = {
					['title'] = 'Living room',
					['waypoint'] = Vector3.new(-186.003, 6.959, 170.558),
					['action'] = 'sit',
					['actionObject'] = workspace.Properties["101"].Seats.Livingroom.Couch1,
				},
			},
		},
		['tenant2'] = {
			['firstLaunch'] = true,
			['name'] = 'biggy',
			['hearingDistance'] = 5,
			['routines'] = {
				['15:00:00'] = {
					['title'] = 'Bedroom',
					['waypoint'] = Vector3.new(-228.543, 17.77, 154.605),
					['action'] = 'idle',
					['actionObject'] = nil,
				},
				['15:30:00'] = {
					['title'] = 'Living room',
					['waypoint'] = Vector3.new(-186.003, 6.959, 170.558),
					['action'] = 'sit',
					['actionObject'] = workspace.Properties["101"].Seats.Livingroom.Couch1,
				},
				['16:00:00'] = {
					['title'] = 'Kitchen',
					['waypoint'] = Vector3.new(-207.474, 6.362, 134.033),
					['action'] = 'idle',
					['actionObject'] = nil,
				},
			},
		}
	}
}

return PathsList
