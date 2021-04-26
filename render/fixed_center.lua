local M = {
	__pick_matrix = vmath.matrix4(),
	__world_to_gui_matrix = vmath.matrix4(),
	__viewport_rect,
	__window_size,
	__window_listener_list = {}
}

function M.get_viewport_rect()
	return unpack(M.__viewport_rect)
end

function M.window_to_world(x, y)
	local p = M.__pick_matrix * vmath.vector4(x, y, 0, 1)
	return p.x, p.y
end

function M.world_to_gui(x, y)
	local p = M.__world_to_gui_matrix * vmath.vector4(x, y, 0, 1)
	return p.x, p.y
end

function M.add_window_listener(url)
	M.__window_listener_list[tostring(url)] = url

	local left, top, right, bottom = M.get_viewport_rect()
	local bar_width, bar_height = 0, 0
	if left < 0 then
		bar_width = -left
		left = 0
		right = LOGICAL_WIDTH
	end
	if bottom < 0 then
		bar_height = -bottom
		bottom = 0
		top = LOGICAL_HEIGHT
	end

	local window_width, window_height = unpack(M.__window_size)
	msg.post(url, hash("window_update"), {
		window = {
			width = window_width,
			hieght = window_height
		},
		viewport = {
			left = left,
			top = top,
			right = right,
			bottom = bottom
		},
		bar = {
			width = bar_width,
			height = bar_height
		}
	})
end

function M.remove_window_listener(url)
	M.__window_listener_list[tostring(url)] = nil
end

function M.__set_viewport_rect_and_window_size(left, top, right, bottom, width, heitgh)
	M.__viewport_rect = { left, top, right, bottom }
	M.__window_size = { width, height }
end

function M.__calc_matrix(proj, view, width, height)
	local n = vmath.matrix4()
	n.m00 = 2/width
	n.m03 = -1
	n.m11 = 2/height
	n.m13 = -1
	n.m22 = 2
	n.m23 = -1
	M.__pick_matrix = vmath.inv(proj * view) * n
	M.__world_to_gui_matrix = vmath.inv(M.__pick_matrix)
end

return M
