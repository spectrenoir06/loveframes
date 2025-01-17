--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

return function(loveframes)
---------- module start ----------

-- panel object
local newobject = loveframes.NewObject("map", "loveframes_object_map", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "map"
	self.width = 200
	self.height = 50
	self.internal = false
	self.children = {}
	self.OnMousePressed = nil
	self.OnPixelClick = nil

	self:SetDrawFunc()
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the element
--]]---------------------------------------------------------
function newobject:update(dt)

	local state = loveframes.state
	local selfstate = self.state

	if state ~= selfstate then
		return
	end

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate

	if not visible then
		if not alwaysupdate then
			return
		end
	end

	local children = self.children
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update

	-- move to parent if there is a parent
	if parent ~= base and parent.type ~= "list" then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end

	self:CheckHover()

	for k, v in ipairs(children) do
		v:update(dt)
	end

	if update then
		update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)
	-- print(x,y, button)
	local state = loveframes.state
	local selfstate = self.state

	if state ~= selfstate then
		return
	end

	local visible = self.visible

	if not visible then
		return
	end

	local children = self.children
	local hover = self.hover

	if hover and button == 1 then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	end

	for k, v in ipairs(children) do
		v:mousepressed(x, y, button)
	end

	if self.OnMousePressed then
		self:OnMousePressed(x,y,button)
	end

	local mx, my = love.mouse.getPosition()
	local selfcol = loveframes.BoundingBox(mx, self.x, my, self.y, 1, self.width, 1, self.height)

	if self.OnPixelClick and selfcol then
		local px = math.floor((x - self:GetX())/24)
		local py = math.floor((y - self:GetY())/24)
		print(px,py)
		self:OnPixelClick(px, py)
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)

	local state = loveframes.state
	local selfstate = self.state

	if state ~= selfstate then
		return
	end

	local visible  = self.visible
	local children = self.children

	if not visible then
		return
	end

	for k, v in ipairs(children) do
		v:mousereleased(x, y, button)
	end

end

---------- module end ----------
end
