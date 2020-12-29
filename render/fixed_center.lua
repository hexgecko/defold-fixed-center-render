local M = {
	pick_matrix = vmath.matrix4(),
	rect
}

function M.calc_pick_matrix(proj, view, width, height)
	local n = vmath.matrix4()
	n.m00 = 2/width
	n.m03 = -1
	n.m11 = 2/height
	n.m13 = -1
	n.m22 = 2
	n.m23 = -1
	M.pick_matrix = vmath.inv(proj * view) * n;
end

function M.frame_to_world(x, y)
	local p = M.pick_matrix * vmath.vector4(x, y, 0, 1)
	return p.x, p.y
end

function M.set_rect(left, top, right, bottom)
	M.rect = { left, top, right, bottom }
end

function M.get_rect()
	return unpack(M.rect)
end

return M
