-- Connected be451-masterpisuncikov-svg
local positioning = {
	["Top"] = UDim2.new(0,0,-0.205,0),
	["Bottom"] = UDim2.new(0,0,0.205,0),
	["Left-bottom"] = UDim2.new(-0.09, 0, 0.1, 0),
	["Right-bottom"] = UDim2.new(0.09, 0, 0.1, 0),
	["Left-top"] = UDim2.new(-0.09, 0, -0.1, 0),
	["Right-top"] = UDim2.new(0.09, 0, -0.1, 0),
	["Center"] = UDim2.new(0.5,0,0.5,0)
}

local SkillTreeConfiguration = require(game.ReplicatedStorage.configs.SkillTreeConfiguration)
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local tree = {}
tree.__index = tree

function tree.init()
	local meta = setmetatable(tree, {})
	meta.buyed = {}
	meta.slots = {}
	meta.hoverConnections = {}
	meta.pulseConnections = {}
	meta.glowTweens = {}
	return meta
end -- creating metatble

function tree:animate(slot, property, duration, style, direction)
	local info = TweenInfo.new(duration or 0.1, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.InOut)
	local tween = TweenService:Create(slot, info, property)
	tween:Play()
	return tween
end -- animate function so i can animate gui faster

function tree:animateSplash(slot, property)
	local tween = TweenService:Create(slot, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), property)
	tween:Play()
	tween.Completed:Connect(function()
		task.wait(1)
		local tween2 = TweenService:Create(slot, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {ImageTransparency = 1})
		tween2:Play()
		tween2.Completed:Connect(function()
			slot:Destroy()
		end)
	end)
end -- splash animation

function tree:pulse(slot, originalsize)
	if self.pulseConnections[slot] then
		self.pulseConnections[slot]:Disconnect()
		self.pulseConnections[slot] = nil
	end
	
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if not slot or not slot.Parent then
			connection:Disconnect()
			return
		end
		local pulse = math.sin(tick() * 3) * 0.004
		slot.Size = originalsize + UDim2.new(pulse, 0, pulse * 2, 0)
	end)
	self.pulseConnections[slot] = connection
end -- pulse animation

function tree:stopPulse(slot)
	if self.pulseConnections[slot] then
		self.pulseConnections[slot]:Disconnect()
		self.pulseConnections[slot] = nil
	end
end -- stopping pulse animanion

function tree:glow(slot)
	local glow = script.Parent.UIShadow:Clone()
	glow.Parent = slot
	local tween = TweenService:Create(glow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.8})
	tween:Play()
	self.glowTweens[slot] = tween
	return glow
end -- glow

function tree:removeGlow(slot)
	if self.glowTweens[slot] then
		self.glowTweens[slot]:Cancel()
		self.glowTweens[slot] = nil
	end
	local glow = slot:FindFirstChild("GlowEffect")
	if glow then
		glow:Destroy()
	end
end -- no glow

function tree:shake(slot)
	local originalPos = slot.Position
	local shakeTween = TweenService:Create(slot, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = originalPos + UDim2.new(0.005, 0, 0, 0)})
	shakeTween:Play()
	shakeTween.Completed:Connect(function()
		local shakeTween2 = TweenService:Create(slot, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = originalPos - UDim2.new(0.005, 0, 0, 0)})
		shakeTween2:Play()
		shakeTween2.Completed:Connect(function()
			local shakeTween3 = TweenService:Create(slot, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = originalPos})
			shakeTween3:Play()
		end)
	end)
end -- shaking animation

function tree:flash(slot)
	local flash = script.Parent.flash:Clone()
	flash.ZIndex = slot.ZIndex + 5
	flash.Parent = slot
	local tween = TweenService:Create(flash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
	tween:Play()
	tween.Completed:Connect(function()
		flash:Destroy()
	end)
end -- flash animation

function tree:rotate(slot)
	local rotateTween = TweenService:Create(slot, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 5})
	rotateTween:Play()
	rotateTween.Completed:Connect(function()
		local rotateTween2 = TweenService:Create(slot, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0})
		rotateTween2:Play()
	end)
end -- rotate anim

function tree:scaleBounce(slot, originalsize)
	local bounceTween = TweenService:Create(slot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = originalsize + UDim2.new(0.02, 0, 0.04, 0)})
	bounceTween:Play()
	bounceTween.Completed:Connect(function()
		local bounceTween2 = TweenService:Create(slot, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalsize})
		bounceTween2:Play()
	end)
end -- scale bounce anim

function tree:appear(slot, originalsize)
	slot.Size = UDim2.new(0, 0, 0, 0)
	slot.Rotation = -10
	local appearTween = TweenService:Create(slot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalsize, Rotation = 0})
	appearTween:Play()
	return appearTween
end -- appear animation

function tree:disappear(slot)
	local disappearTween = TweenService:Create(slot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Rotation = 10})
	disappearTween:Play()
	disappearTween.Completed:Connect(function()
		slot:Destroy()
	end)
end -- and dissapear

function tree:show(position, parented, name, isHidden)
	local template = script.Parent.Slot:Clone()
	local originalsize = template.Size
	local hover: TextButton = template.Hover
	template.Parent = script.Parent.Parent.Frame.Slots
	template.Name = name
	template.cashAmount.Text = SkillTreeConfiguration.SkillTree.Slots[tonumber(name)].cost
	template.Title.Text = SkillTreeConfiguration.SkillTree.Slots[tonumber(name)].title -- setting template config
	if parented then
		template.Position = parented.Position + positioning[position]
	else
		template.Position = positioning[position]
	end -- positioning
	template.Visible = true
	self.slots[#self.slots + 1] = template
	self:appear(template, originalsize)
	if name == "1" then
		self:showChild(template)
	end
	
	hover.MouseEnter:Connect(function()
		self:hover(template, originalsize)
	end)
	
	hover.MouseLeave:Connect(function()
		self:unhover(template, originalsize)
	end)
	
	hover.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			self:hold(template, originalsize)
		end
	end) -- hold function
	
	hover.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			self:unhold(template, originalsize)
		end
	end) -- unhold function
	
	if isHidden then
		for i, v in pairs(template:GetChildren()) do
			if v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then
				v.Visible = false
			end
		end
		template.Image = "rbxassetid://131157804052950" -- changes image
		self:pulse(template, originalsize) -- pulses
	end
end -- showing skill

function tree:showChild(slot)
	for i, v in pairs(SkillTreeConfiguration.SkillTree.Slots) do
		if v.parented == slot.Name then
			local existing = script.Parent.Parent.Frame.Slots:FindFirstChild(v.name)
			if not existing then
				self:show(v.positioned, slot, v.name, true)
			end -- showing child if parent exists
		end
	end
end

function tree:revealChild(slot)
	if not slot then return end
	self:stopPulse(slot)
	slot.Image = "rbxassetid://122088365772491"
	for i, v in pairs(slot:GetChildren()) do
		if v:IsA("ImageLabel") or v:IsA("TextLabel") or v:IsA("TextButton") then
			v.Visible = true
		end
	end
	self:scaleBounce(slot, slot.Size)
	self:flash(slot)
	self:showChild(slot)
end -- revealing skill

function tree:buySlot(slot)
	if table.find(self.buyed, slot.Name) then
		return true
	end
	local success = game.ReplicatedStorage.Remotes.Functions.buy:InvokeServer(slot.Name)
	if success then
		table.insert(self.buyed, slot.Name) -- inserting buyed skill into table
	end
	return success
end -- buying

function tree:hover(slot, size)
	self:animate(slot, {Size = size + UDim2.new(0.013,0,0.03,0)}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	self:glow(slot)
end

function tree:unhover(slot, size)
	self:animate(slot, {Size = size}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	self:removeGlow(slot)
end

function tree:hold(slot, size)
	self:animate(slot, {Size = size - UDim2.new(0.008,0,0.008,0)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function tree:cashSplash(slot)
	for i = 6, 10 do
		local clone = script.Parent.cash:Clone()
		clone.Parent = slot
		clone.Position = slot.Cash.Position
		self:animateSplash(clone, {Position = clone.Position + UDim2.new(0, math.random(-35,35),0,math.random(-25,25))})
	end
end -- anim

function tree:unhold(slot, size)
	self:animate(slot, {Size = size}, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local alreadyBuyed = table.find(self.buyed, slot.Name) ~= nil
	
	if self:buySlot(slot) then -- if slot buy succes
		slot.Image = "rbxassetid://93610990442351"
		self:scaleBounce(slot, size)
		self:rotate(slot)
		self:flash(slot)
		self:cashSplash(slot)
		
		if not alreadyBuyed then
			for i, v in pairs(SkillTreeConfiguration.SkillTree.Slots) do
				if v.parented == slot.Name then
					self:revealChild(script.Parent.Parent.Frame.Slots:FindFirstChild(v.name))
				end
			end
		end
	else
		self:shake(slot)
		warn("purchase failed")
	end
	
end

function tree:restore(purchasedSkills)
	for _, slotName in ipairs(purchasedSkills) do
		
		if not table.find(self.buyed, slotName) then
			table.insert(self.buyed, slotName)
		end
		
		local slot = script.Parent.Parent.Frame.Slots:FindFirstChild(slotName)
		
		if slot then
			self:stopPulse(slot)
			slot.Image = "rbxassetid://93610990442351"
			for _, v in pairs(SkillTreeConfiguration.SkillTree.Slots) do
				if v.parented == slotName then
					self:revealChild(script.Parent.Parent.Frame.Slots:FindFirstChild(v.name))
				end
			end
		end
		
	end
end -- data store function, restoring skill tree

return tree
