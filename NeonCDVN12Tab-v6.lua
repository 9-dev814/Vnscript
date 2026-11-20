-- Neon 12 Tab VN // Password Lock ("menu cdvn") - Client-side
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local guiParent = (gethui and gethui()) or CoreGui
local oldGui = guiParent:FindFirstChild("NeonCDVNMenu")
if oldGui then oldGui:Destroy() end

local espFolder = guiParent:FindFirstChild("NeonCDVNEsp")
if espFolder then espFolder:Destroy() end
espFolder = Instance.new("Folder")
espFolder.Name = "NeonCDVNEsp"
espFolder.Parent = guiParent

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonCDVNMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then pcall(syn.protect_gui, ScreenGui) end
local okParent = pcall(function() ScreenGui.Parent = guiParent end)
if not okParent or not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

local REQUIRED_PASS = "menu cdvn"
local unlocked = false
local conns = {}
local strokes = {}
local labels = {}

local function regConn(c)
	table.insert(conns, c)
	return c
end

local function regStroke(inst, phase)
	local s = Instance.new("UIStroke")
	s.Thickness = 1.5
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
	table.insert(strokes, {s = s, p = phase or 0})
	return s
end

local function regLabel(lbl, phase)
	table.insert(labels, {l = lbl, p = phase or 0})
	return lbl
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 92, 0, 25)
ToggleBtn.Position = UDim2.new(0, 10, 0.28, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "CDVN MENU"
ToggleBtn.TextSize = 9
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
regStroke(ToggleBtn, 0).Thickness = 1.8
regLabel(ToggleBtn, 0)

local LockFrame = Instance.new("Frame")
LockFrame.Size = UDim2.new(0, 250, 0, 132)
LockFrame.Position = UDim2.new(0.5, -125, 0.5, -66)
LockFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 17)
LockFrame.BorderSizePixel = 0
LockFrame.Visible = false
LockFrame.Parent = ScreenGui
Instance.new("UICorner", LockFrame).CornerRadius = UDim.new(0, 8)
regStroke(LockFrame, 0.1).Thickness = 2.0

local LockTitle = Instance.new("TextLabel")
LockTitle.Size = UDim2.new(1, -16, 0, 24)
LockTitle.Position = UDim2.new(0, 8, 0, 6)
LockTitle.BackgroundTransparency = 1
LockTitle.Text = "KHOA TRUY CAP // NHAP MAT KHAU"
LockTitle.TextSize = 9
LockTitle.Font = Enum.Font.GothamBlack
LockTitle.TextXAlignment = Enum.TextXAlignment.Left
LockTitle.Parent = LockFrame
regLabel(LockTitle, 0.15)

local PassBox = Instance.new("TextBox")
PassBox.Size = UDim2.new(1, -16, 0, 28)
PassBox.Position = UDim2.new(0, 8, 0, 34)
PassBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
PassBox.TextColor3 = Color3.fromRGB(130, 255, 235)
PassBox.PlaceholderText = "Nhap mat khau..."
PassBox.Text = ""
PassBox.ClearTextOnFocus = false
PassBox.TextSize = 9
PassBox.Font = Enum.Font.GothamBold
PassBox.Parent = LockFrame
Instance.new("UICorner", PassBox).CornerRadius = UDim.new(0, 5)

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0.46, 0, 0, 26)
UnlockBtn.Position = UDim2.new(0, 8, 0, 68)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 36)
UnlockBtn.Text = "MO KHOA"
UnlockBtn.TextSize = 9
UnlockBtn.Font = Enum.Font.GothamBlack
UnlockBtn.Parent = LockFrame
Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0, 5)
regStroke(UnlockBtn, 0.25)
regLabel(UnlockBtn, 0.3)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(0.50, -8, 0, 26)
StatusLbl.Position = UDim2.new(0.50, 0, 0, 68)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Cho xac thuc"
StatusLbl.TextSize = 8
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextXAlignment = Enum.TextXAlignment.Right
StatusLbl.Parent = LockFrame
regLabel(StatusLbl, 0.4)

local CancelLockBtn = Instance.new("TextButton")
CancelLockBtn.Size = UDim2.new(1, -16, 0, 20)
CancelLockBtn.Position = UDim2.new(0, 8, 0, 98)
CancelLockBtn.BackgroundColor3 = Color3.fromRGB(165, 28, 52)
CancelLockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelLockBtn.Text = "DONG"
CancelLockBtn.TextSize = 8
CancelLockBtn.Font = Enum.Font.GothamBold
CancelLockBtn.Parent = LockFrame
Instance.new("UICorner", CancelLockBtn).CornerRadius = UDim.new(0, 4)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 316, 0, 360)
Main.Position = UDim2.new(0.5, -158, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
regStroke(Main, 0.12).Thickness = 2.0

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 26)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -54, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CDVN // 12 TAB NEON"
Title.TextSize = 9
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
regLabel(Title, 0.2)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -22, 0.5, -9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(195, 30, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextSize = 9
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local function normalizePass(raw)
	return tostring(raw or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
end

local function tryUnlock()
	if normalizePass(PassBox.Text) == REQUIRED_PASS then
		unlocked = true
		LockFrame.Visible = false
		Main.Visible = true
	else
		StatusLbl.Text = "Sai mat khau!"
	end
end

UnlockBtn.MouseButton1Click:Connect(tryUnlock)
PassBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then tryUnlock() end
end)
CancelLockBtn.MouseButton1Click:Connect(function() LockFrame.Visible = false end)

ToggleBtn.MouseButton1Click:Connect(function()
	if unlocked then
		Main.Visible = not Main.Visible
	else
		LockFrame.Visible = not LockFrame.Visible
		StatusLbl.Text = "Mat khau: menu cdvn"
	end
end)

regConn(RunService.RenderStepped:Connect(function()
	local h = (tick() * 0.35) % 1
	for _, it in ipairs(strokes) do
		if it.s and it.s.Parent then
			it.s.Color = Color3.fromHSV((h + it.p) % 1, 0.95, 1)
		end
	end
	for _, it in ipairs(labels) do
		if it.l and it.l.Parent then
			it.l.TextColor3 = Color3.fromHSV((h + it.p) % 1, 0.85, 1)
		end
	end
end))

local function makeDraggable(frame, handle)
	local dragging = false
	local dragStart, startPos
	regConn(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end))
	regConn(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))
	regConn(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))
end
makeDraggable(Main, TopBar)
makeDraggable(LockFrame, LockTitle)
makeDraggable(ToggleBtn, ToggleBtn)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(1, -8, 0, 24)
TabBar.Position = UDim2.new(0, 4, 0, 30)
TabBar.BackgroundTransparency = 1
TabBar.CanvasSize = UDim2.new(0, 1020, 0, 0)
TabBar.ScrollBarThickness = 2
TabBar.Parent = Main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = TabBar

local tabNames = {
	"1. Di Chuyen", "2. Tu Do CS", "3. Chon Team", "4. Kho Do",
	"5. Toc Do", "6. Dich Chuyen", "7. ESP", "8. Xe Co",
	"9. Chi So Ao", "10. Tuong Tac", "11. Anh Sang", "12. He Thong"
}

local pages = {}
for i = 1, 12 do
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, -8, 1, -60)
	page.Position = UDim2.new(0, 4, 0, 56)
	page.BackgroundTransparency = 1
	page.CanvasSize = UDim2.new(0, 0, 0, 480)
	page.ScrollBarThickness = 2
	page.Visible = (i == 1)
	page.Parent = Main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.Parent = page
	pages[i] = page

	local tBtn = Instance.new("TextButton")
	tBtn.Size = UDim2.new(0, 80, 1, -2)
	tBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	tBtn.Text = tabNames[i]
	tBtn.TextSize = 8
	tBtn.Font = Enum.Font.GothamBold
	tBtn.Parent = TabBar
	Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 5)
	regStroke(tBtn, i * 0.07)
	regLabel(tBtn, i * 0.07 + 0.2)

	tBtn.MouseButton1Click:Connect(function()
		for idx, p in ipairs(pages) do
			p.Visible = (idx == i)
		end
	end)
end

local function addBtn(parent, text, phase, fn)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 27)
	b.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
	b.Text = text
	b.TextSize = 9
	b.Font = Enum.Font.GothamBold
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	regStroke(b, phase)
	regLabel(b, phase + 0.15)
	b.MouseButton1Click:Connect(fn)
	return b
end

local function addBox(parent, labelText, defaultVal, phase, onVal)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -4, 0, 29)
	row.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
	regStroke(row, phase)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, -6, 1, 0)
	lbl.Position = UDim2.new(0, 6, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextSize = 9
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	regLabel(lbl, phase)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.40, 0, 0, 21)
	box.Position = UDim2.new(0.57, 0, 0.5, -10)
	box.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
	box.TextColor3 = Color3.fromRGB(120, 255, 230)
	box.Text = tostring(defaultVal)
	box.TextSize = 9
	box.Font = Enum.Font.GothamBold
	box.Parent = row
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	box.FocusLost:Connect(function()
		onVal(box.Text)
	end)
	return box
end

local function smoothTp(cf)
	local ch = LocalPlayer.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	if not hrp then return end
	if hum and hum.SeatPart then
		hum.Sit = false
		task.wait(0.05)
	end
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	local startCF = hrp.CFrame
	local dist = (cf.Position - startCF.Position).Magnitude
	local steps = math.clamp(math.ceil(dist / 25), 1, 20)
	for i = 1, steps do
		if not hrp or not hrp.Parent then return end
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CFrame = startCF:Lerp(cf, i / steps)
		RunService.Heartbeat:Wait()
	end
	hrp.CFrame = cf
	hrp.AssemblyLinearVelocity = Vector3.zero
end

local noclip = false
local fly = false
local doorPass = false
local speedOn = false
local espOn = false
local targetSpeed = 48
local targetJump = 80
local savedCF = nil

regConn(RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end
	if doorPass then
		for _, o in ipairs(Workspace:GetDescendants()) do
			local n = o.Name:lower()
			if n:find("door", 1, true) or n:find("gate", 1, true) or n:find("cua", 1, true) or n:find("barrier", 1, true) then
				if o:IsA("BasePart") then o.CanCollide = false
				elseif o:IsA("Model") then
					for _, p in ipairs(o:GetDescendants()) do
						if p:IsA("BasePart") then p.CanCollide = false end
					end
				end
			end
		end
	end
end))

regConn(RunService.RenderStepped:Connect(function(dt)
	local ch = LocalPlayer.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local cam = Workspace.CurrentCamera

	if fly and hrp and cam then
		local bv = hrp:FindFirstChild("CDVNFlyVel") or Instance.new("BodyVelocity")
		bv.Name = "CDVNFlyVel"
		bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bv.Parent = hrp
		local bg = hrp:FindFirstChild("CDVNFlyGyro") or Instance.new("BodyGyro")
		bg.Name = "CDVNFlyGyro"
		bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
		bg.CFrame = cam.CFrame
		bg.Parent = hrp
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		bv.Velocity = dir.Magnitude > 0 and dir.Unit * 55 or Vector3.zero
	elseif hrp then
		if hrp:FindFirstChild("CDVNFlyVel") then hrp.CDVNFlyVel:Destroy() end
		if hrp:FindFirstChild("CDVNFlyGyro") then hrp.CDVNFlyGyro:Destroy() end
	end

	if speedOn and hrp and hum and hum.MoveDirection.Magnitude > 0 then
		local step = hum.MoveDirection.Unit * (targetSpeed * 0.25) * math.min(dt * 60, 2)
		hrp.CFrame = hrp.CFrame + Vector3.new(step.X, 0, step.Z)
	end

	if espOn then
		local active = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				active[plr.Name] = true
				local tag = espFolder:FindFirstChild(plr.Name)
				if not tag then
					tag = Instance.new("BillboardGui")
					tag.Name = plr.Name
					tag.AlwaysOnTop = true
					tag.Size = UDim2.new(0, 100, 0, 18)
					tag.StudsOffset = Vector3.new(0, 3, 0)
					tag.Adornee = plr.Character.HumanoidRootPart
					tag.Parent = espFolder
					local l = Instance.new("TextLabel")
					l.Size = UDim2.new(1, 0, 1, 0)
					l.BackgroundTransparency = 1
					l.TextColor3 = Color3.fromRGB(255, 80, 170)
					l.TextStrokeTransparency = 0
					l.TextSize = 9
					l.Font = Enum.Font.GothamBold
					l.Parent = tag
				else
					tag.Adornee = plr.Character.HumanoidRootPart
				end
				local dist = hrp and math.floor((plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
				local l = tag:FindFirstChildOfClass("TextLabel")
				if l then l.Text = plr.Name .. " [" .. dist .. "m]" end
			end
		end
		for _, chObj in ipairs(espFolder:GetChildren()) do
			if not active[chObj.Name] then chObj:Destroy() end
		end
	end
end))

-- TAB 1: Di Chuyen
local flyBtn
flyBtn = addBtn(pages[1], "Bay Tu Do WASD: TAT", 0.05, function()
	fly = not fly
	flyBtn.Text = fly and "Bay Tu Do WASD: BAT" or "Bay Tu Do WASD: TAT"
end)
local ncBtn
ncBtn = addBtn(pages[1], "Di Xuyen Tuong: TAT", 0.12, function()
	noclip = not noclip
	ncBtn.Text = noclip and "Di Xuyen Tuong: BAT" or "Di Xuyen Tuong: TAT"
end)
addBtn(pages[1], "Dung Yen Van Toc", 0.19, function()
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if r then r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end
end)

-- TAB 2: Tu Do Canh Sat
local function isPoliceObj(name)
	local s = name:lower()
	for _, kw in ipairs({"police", "cop", "canh sat", "cong an", "tu do", "locker", "armory", "cscd", "csgt"}) do
		if s:find(kw, 1, true) then return true end
	end
	return false
end

addBtn(pages[2], "Mo Tu Do / Prompt Canh Sat", 0.08, function()
	for _, g in ipairs(PlayerGui:GetDescendants()) do
		if (g:IsA("Frame") or g:IsA("ScreenGui")) and isPoliceObj(g.Name) then
			if g:IsA("ScreenGui") then g.Enabled = true else g.Visible = true end
		end
	end
	for _, o in ipairs(Workspace:GetDescendants()) do
		if isPoliceObj(o.Name) or (o.Parent and isPoliceObj(o.Parent.Name)) then
			if o:IsA("ProximityPrompt") and fireproximityprompt then
				pcall(fireproximityprompt, o)
			elseif o:IsA("ClickDetector") and fireclickdetector then
				pcall(fireclickdetector, o)
			end
		end
	end
end)

local dpBtn
dpBtn = addBtn(pages[2], "Bo Va Cham Cua / Gao: TAT", 0.16, function()
	doorPass = not doorPass
	dpBtn.Text = doorPass and "Bo Va Cham Cua / Gao: BAT" or "Bo Va Cham Cua / Gao: TAT"
end)

addBtn(pages[2], "Dich Chuyen Den Tu Do / Ghe CS", 0.24, function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	for _, o in ipairs(Workspace:GetDescendants()) do
		if isPoliceObj(o.Name) or (o.Parent and isPoliceObj(o.Parent.Name)) then
			if o:IsA("VehicleSeat") and hum then
				o.Disabled = false
				smoothTp(o.CFrame + Vector3.new(0, 3, 0))
				task.wait(0.08)
				pcall(function() o:Sit(hum) end)
				return
			elseif o:IsA("BasePart") then
				smoothTp(o.CFrame + Vector3.new(0, 3, 0))
				return
			end
		end
	end
end)

-- TAB 3: Chon Team
local teamBox = Instance.new("Frame")
teamBox.Size = UDim2.new(1, -4, 0, 210)
teamBox.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
teamBox.Parent = pages[3]
Instance.new("UICorner", teamBox).CornerRadius = UDim.new(0, 6)
regStroke(teamBox, 0.1)

local teamScroll = Instance.new("ScrollingFrame")
teamScroll.Size = UDim2.new(1, -8, 1, -8)
teamScroll.Position = UDim2.new(0, 4, 0, 4)
teamScroll.BackgroundTransparency = 1
teamScroll.ScrollBarThickness = 2
teamScroll.Parent = teamBox

local teamListLayout = Instance.new("UIListLayout")
teamListLayout.Padding = UDim.new(0, 4)
teamListLayout.Parent = teamScroll

local function rebuildTeams()
	for _, ch in ipairs(teamScroll:GetChildren()) do
		if ch:IsA("TextButton") then ch:Destroy() end
	end
	local all = Teams:GetTeams()
	teamScroll.CanvasSize = UDim2.new(0, 0, 0, #all * 30)
	for idx, tm in ipairs(all) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 26)
		b.BackgroundColor3 = Color3.fromRGB(22, 25, 38)
		b.Text = "Team: " .. tm.Name
		b.TextSize = 9
		b.Font = Enum.Font.GothamBold
		b.Parent = teamScroll
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
		regLabel(b, idx * 0.1)
		b.MouseButton1Click:Connect(function()
			pcall(function() LocalPlayer.Team = tm end)
		end)
	end
end
rebuildTeams()
addBtn(pages[3], "Tai Lai Danh Sach Team", 0.25, rebuildTeams)

-- TAB 4: Kho Do
addBtn(pages[4], "Lay Tool Co San Vao Backpack", 0.08, function()
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	if not bp then return end
	for _, it in ipairs(Workspace:GetDescendants()) do
		if it:IsA("Tool") then pcall(function() it:Clone().Parent = bp end) end
	end
end)
addBtn(pages[4], "Cam Tool Dau Tien Trong Backpack", 0.16, function()
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local t = bp and bp:FindFirstChildOfClass("Tool")
	if t and hum then pcall(function() hum:EquipTool(t) end) end
end)

-- TAB 5: Toc Do
local spBtn
spBtn = addBtn(pages[5], "Tang Toc Buoc Chan: TAT", 0.06, function()
	speedOn = not speedOn
	spBtn.Text = speedOn and "Tang Toc Buoc Chan: BAT" or "Tang Toc Buoc Chan: TAT"
end)
addBox(pages[5], "Toc Do", targetSpeed, 0.14, function(v)
	targetSpeed = math.clamp(tonumber(v) or 48, 0, 250)
end)
addBox(pages[5], "Nhay Cao", targetJump, 0.22, function(v)
	targetJump = math.clamp(tonumber(v) or 80, 0, 400)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.UseJumpPower = true hum.JumpPower = targetJump end
end)

-- TAB 6: Dich Chuyen
addBtn(pages[6], "Luu Vi Tri Hien Tai", 0.08, function()
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if r then savedCF = r.CFrame end
end)
addBtn(pages[6], "Ve Vi Tri Da Luu", 0.16, function()
	if savedCF then smoothTp(savedCF + Vector3.new(0, 2, 0)) end
end)

-- TAB 7: ESP
local espBtn
espBtn = addBtn(pages[7], "ESP Nguoi Choi: TAT", 0.10, function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP Nguoi Choi: BAT" or "ESP Nguoi Choi: TAT"
	if not espOn then espFolder:ClearAllChildren() end
end)

-- TAB 8: Xe Co
addBtn(pages[8], "Lat Lai Xe Dang Ngoi", 0.12, function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local s = h and h.SeatPart
	if s and s:IsA("VehicleSeat") then s.CFrame = CFrame.new(s.Position + Vector3.new(0, 4, 0)) end
end)
addBtn(pages[8], "Roi Ghe Xe Ngay", 0.20, function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.Sit = false end
end)

-- TAB 9: Chi So Ao
addBox(pages[9], "Tien Ao (UI/Attr)", 999999999, 0.08, function(v)
	pcall(function() LocalPlayer:SetAttribute("VisualMoney", v) end)
	for _, g in ipairs(PlayerGui:GetDescendants()) do
		if (g:IsA("TextLabel") or g:IsA("TextBox")) and g.Name:lower():find("money", 1, true) then
			g.Text = tostring(v)
		end
	end
end)
addBox(pages[9], "Level Ao (UI/Attr)", 9999, 0.16, function(v)
	pcall(function() LocalPlayer:SetAttribute("VisualLevel", v) end)
	for _, g in ipairs(PlayerGui:GetDescendants()) do
		if (g:IsA("TextLabel") or g:IsA("TextBox")) and g.Name:lower():find("level", 1, true) then
			g.Text = tostring(v)
		end
	end
end)

-- TAB 10: Tuong Tac
addBtn(pages[10], "Kich Hoat ProximityPrompt Gan", 0.10, function()
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	for _, o in ipairs(Workspace:GetDescendants()) do
		if o:IsA("ProximityPrompt") and fireproximityprompt then
			if not r or not o.Parent or not o.Parent:IsA("BasePart") or (o.Parent.Position - r.Position).Magnitude <= 30 then
				pcall(fireproximityprompt, o)
			end
		end
	end
end)
addBtn(pages[10], "Bam ClickDetector Gan", 0.18, function()
	for _, o in ipairs(Workspace:GetDescendants()) do
		if o:IsA("ClickDetector") and fireclickdetector then pcall(fireclickdetector, o) end
	end
end)

-- TAB 11: Anh Sang
addBtn(pages[11], "Fullbright Sang Ro", 0.10, function()
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
end)
addBtn(pages[11], "Che Do Dem", 0.18, function()
	Lighting.ClockTime = 0
	Lighting.Brightness = 1
end)

-- TAB 12: He Thong
addBtn(pages[12], "Giam Do Hoa / Fix Lag", 0.08, function()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	Lighting.GlobalShadows = false
	for _, fx in ipairs(Workspace:GetDescendants()) do
		if fx:IsA("ParticleEmitter") or fx:IsA("Fire") or fx:IsA("Smoke") then fx.Enabled = false end
	end
end)
addBtn(pages[12], "Go Menu & Ngat Ket Noi", 0.18, function()
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	espFolder:Destroy()
	ScreenGui:Destroy()
end)
