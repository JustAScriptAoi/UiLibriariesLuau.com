local RRQUiLibrary = {}

local coreGui = cloneref(game:GetService("CoreGui"))
local userInputService = cloneref(game:GetService("UserInputService"))
local runService = cloneref(game:GetService("RunService"))
local tweenService = cloneref(game:GetService("TweenService"))

local COL_BG      = Color3.fromRGB(12, 12, 14)
local COL_ROW     = Color3.fromRGB(25, 25, 28)
local COL_TOGGLE  = Color3.fromRGB(40, 40, 45)
local COL_ACTIVE  = Color3.fromRGB(220, 180, 30)
local MIN_NORMAL  = Color3.fromRGB(35, 35, 38)
local MIN_HOVER   = Color3.fromRGB(20, 20, 22)
local COL_YELLOW  = Color3.fromRGB(255, 210, 50)
local COL_YELLOW2 = Color3.fromRGB(200, 155, 20)
local COL_TAB_ACT = Color3.fromRGB(220, 180, 30)
local COL_TAB_OFF = Color3.fromRGB(30, 30, 34)

local STROKE_CS = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(20, 20, 22)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(160, 125, 10)),
    ColorSequenceKeypoint.new(0.4,  Color3.fromRGB(255, 210, 50)),
    ColorSequenceKeypoint.new(0.6,  Color3.fromRGB(255, 210, 50)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(160, 125, 10)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(20, 20, 22)),
})

function RRQUiLibrary:CreateWindow(config)
    config = config or {}
    local title   = config.Title  or "RRQUiLibrary"
    local author  = config.Author or "RyuuScripts Hub"
    local width   = config.Width  or 240
    local height  = config.Height or 320

    if coreGui:FindFirstChild("RRQUiLibraryGui") then
        coreGui.RRQUiLibraryGui:Destroy()
    end

    local allGrads = {}

    local function animStroke(parent, thick)
        local s = Instance.new("UIStroke")
        s.Thickness = thick or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Color = Color3.new(1, 1, 1)
        s.Parent = parent
        local g = Instance.new("UIGradient")
        g.Color = STROKE_CS
        g.Rotation = 45
        g.Parent = s
        table.insert(allGrads, g)
        return s
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "RRQUiLibraryGui"
    gui.ResetOnSpawn = false
    gui.Parent = coreGui

    local FULL_H = height
    local MINI_H = 44

    local main = Instance.new("Frame")
    main.Size                   = UDim2.new(0, width, 0, FULL_H)
    main.Position               = UDim2.new(0.5, -width/2, 0.4, -FULL_H/2)
    main.BackgroundColor3       = COL_BG
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel        = 0
    main.ClipsDescendants       = true
    main.Active                 = true
    main.Parent                 = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    animStroke(main, 1.5)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size                = UDim2.new(1, -40, 0, 16)
    titleLbl.Position            = UDim2.new(0, 12, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                = title
    titleLbl.Font                = Enum.Font.GothamBlack
    titleLbl.TextSize            = 13
    titleLbl.TextColor3          = COL_YELLOW
    titleLbl.TextXAlignment      = Enum.TextXAlignment.Left
    titleLbl.Parent              = main
    local tGrad = Instance.new("UIGradient")
    tGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   COL_YELLOW2),
        ColorSequenceKeypoint.new(0.5, COL_YELLOW),
        ColorSequenceKeypoint.new(1,   COL_YELLOW2),
    })
    tGrad.Parent = titleLbl

    local authorLbl = Instance.new("TextLabel")
    authorLbl.Size               = UDim2.new(1, -40, 0, 10)
    authorLbl.Position           = UDim2.new(0, 12, 0, 25)
    authorLbl.BackgroundTransparency = 1
    authorLbl.Text               = author
    authorLbl.Font               = Enum.Font.GothamMedium
    authorLbl.TextSize           = 9
    authorLbl.TextColor3         = Color3.fromRGB(160, 130, 30)
    authorLbl.TextXAlignment     = Enum.TextXAlignment.Left
    authorLbl.Parent             = main

    local minimized = false
    local minBtn = Instance.new("TextButton")
    minBtn.Size             = UDim2.new(0, 24, 0, 24)
    minBtn.Position         = UDim2.new(1, -32, 0, 8)
    minBtn.BackgroundColor3 = MIN_NORMAL
    minBtn.Text             = "-"
    minBtn.TextColor3       = COL_YELLOW
    minBtn.Font             = Enum.Font.GothamBlack
    minBtn.TextSize         = 14
    minBtn.BorderSizePixel  = 0
    minBtn.AutoButtonColor  = false
    minBtn.Parent           = main
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    animStroke(minBtn, 1)

    local minScale = Instance.new("UIScale")
    minScale.Scale = 1
    minScale.Parent = minBtn

    minBtn.MouseEnter:Connect(function()
        tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOVER}):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        tweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORMAL}):Play()
    end)
    minBtn.MouseButton1Down:Connect(function()
        tweenService:Create(minBtn, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(10,10,12)}):Play()
        tweenService:Create(minScale, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {Scale = 0.93}):Play()
        task.delay(0.07, function()
            tweenService:Create(minBtn, TweenInfo.new(0.18), {BackgroundColor3 = MIN_NORMAL}):Play()
            tweenService:Create(minScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = minimized and UDim2.new(0, width, 0, MINI_H) or UDim2.new(0, width, 0, FULL_H)
        }):Play()
        minBtn.Text = minimized and "+" or "-"
    end)

    local tabBar = Instance.new("Frame")
    tabBar.Size                = UDim2.new(1, 0, 0, 28)
    tabBar.Position            = UDim2.new(0, 0, 0, 38)
    tabBar.BackgroundColor3    = Color3.fromRGB(16, 16, 18)
    tabBar.BackgroundTransparency = 0
    tabBar.BorderSizePixel     = 0
    tabBar.Parent              = main

    local tabBarStroke = Instance.new("UIStroke")
    tabBarStroke.Thickness = 1
    tabBarStroke.Color = Color3.fromRGB(40, 35, 10)
    tabBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabBarStroke.Parent = tabBar

    local tabBarLayout = Instance.new("UIListLayout")
    tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabBarLayout.Padding = UDim.new(0, 2)
    tabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabBarLayout.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 4)
    tabPadding.PaddingTop  = UDim.new(0, 4)
    tabPadding.PaddingBottom = UDim.new(0, 4)
    tabPadding.Parent = tabBar

    local contentHolder = Instance.new("Frame")
    contentHolder.Size             = UDim2.new(1, 0, 1, -66)
    contentHolder.Position         = UDim2.new(0, 0, 0, 66)
    contentHolder.BackgroundTransparency = 1
    contentHolder.ClipsDescendants = true
    contentHolder.BorderSizePixel  = 0
    contentHolder.Parent           = main

    do
        local dragging, dragStart, startPos = false, nil, nil
        main.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                local abs = main.AbsolutePosition
                main.Position = UDim2.new(0, abs.X, 0, abs.Y)
                dragging  = true
                dragStart = i.Position
                startPos  = main.Position
            end
        end)
        userInputService.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local d  = i.Position - dragStart
                local vp = workspace.CurrentCamera.ViewportSize
                local gs = main.AbsoluteSize
                main.Position = UDim2.new(0,
                    math.clamp(startPos.X.Offset + d.X, 0, vp.X - gs.X), 0,
                    math.clamp(startPos.Y.Offset + d.Y, 0, vp.Y - gs.Y))
            end
        end)
        userInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    runService.RenderStepped:Connect(function()
        local off = Vector2.new(math.sin(tick() * 2.8), 0)
        for _, g in ipairs(allGrads) do g.Offset = off end
    end)

    local tabs = {}
    local activeTab = nil

    local Window = {}

    function Window:CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size                = UDim2.new(0, 0, 1, 0)
        tabBtn.AutomaticSize       = Enum.AutomaticSize.X
        tabBtn.BackgroundColor3    = COL_TAB_OFF
        tabBtn.Text                = tabName
        tabBtn.Font                = Enum.Font.GothamBlack
        tabBtn.TextSize            = 10
        tabBtn.TextColor3          = Color3.fromRGB(180, 155, 40)
        tabBtn.BorderSizePixel     = 0
        tabBtn.AutoButtonColor     = false
        tabBtn.Parent              = tabBar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

        local tabBtnPad = Instance.new("UIPadding")
        tabBtnPad.PaddingLeft  = UDim.new(0, 8)
        tabBtnPad.PaddingRight = UDim.new(0, 8)
        tabBtnPad.Parent = tabBtn

        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Size               = UDim2.new(1, 0, 1, 0)
        tabPage.Position           = UDim2.new(0, 0, 0, 0)
        tabPage.BackgroundTransparency = 1
        tabPage.BorderSizePixel    = 0
        tabPage.ScrollBarThickness = 2
        tabPage.ScrollBarImageColor3 = COL_YELLOW
        tabPage.CanvasSize         = UDim2.new(0, 0, 0, 0)
        tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabPage.Visible            = false
        tabPage.Parent             = contentHolder

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder  = Enum.SortOrder.LayoutOrder
        pageLayout.Padding    = UDim.new(0, 6)
        pageLayout.Parent     = tabPage

        local pagePad = Instance.new("UIPadding")
        pagePad.PaddingTop    = UDim.new(0, 6)
        pagePad.PaddingLeft   = UDim.new(0, 10)
        pagePad.PaddingRight  = UDim.new(0, 10)
        pagePad.PaddingBottom = UDim.new(0, 6)
        pagePad.Parent        = tabPage

        local function setActive(isActive)
            tweenService:Create(tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                BackgroundColor3 = isActive and COL_TAB_ACT or COL_TAB_OFF,
                TextColor3 = isActive and Color3.fromRGB(20, 15, 5) or Color3.fromRGB(180, 155, 40),
            }):Play()
            tabPage.Visible = isActive
        end

        tabBtn.MouseButton1Click:Connect(function()
            if activeTab == tabPage then return end
            if activeTab then
                for _, t in ipairs(tabs) do
                    if t.page == activeTab then t.setActive(false) end
                end
            end
            activeTab = tabPage
            setActive(true)
        end)

        table.insert(tabs, {page = tabPage, setActive = setActive})

        if #tabs == 1 then
            activeTab = tabPage
            setActive(true)
        end

        local function makeRow()
            local row = Instance.new("Frame")
            row.Size                   = UDim2.new(1, 0, 0, 34)
            row.BackgroundColor3       = COL_ROW
            row.BackgroundTransparency = 0.2
            row.BorderSizePixel        = 0
            row.LayoutOrder            = #tabPage:GetChildren()
            row.Parent                 = tabPage
            Instance.new("UICorner", row)
            animStroke(row, 1)
            return row
        end

        local function makeLabel(parent, text, wOff)
            local lbl = Instance.new("TextLabel")
            lbl.Size             = UDim2.new(1, wOff or -60, 1, 0)
            lbl.Position         = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text             = text
            lbl.Font             = Enum.Font.GothamBlack
            lbl.TextSize         = 11
            lbl.TextColor3       = Color3.fromRGB(245, 245, 245)
            lbl.TextXAlignment   = Enum.TextXAlignment.Left
            lbl.Parent           = parent
            return lbl
        end

        local Tab = {}

        function Tab:CreateToggle(tConfig)
            tConfig = tConfig or {}
            local lname    = tConfig.Name     or "Toggle"
            local default  = tConfig.Default  or false
            local callback = tConfig.Callback or function() end

            local row = makeRow()
            makeLabel(row, lname)

            local track = Instance.new("Frame")
            track.Size             = UDim2.new(0, 36, 0, 18)
            track.Position         = UDim2.new(1, -46, 0.5, -9)
            track.BackgroundColor3 = COL_TOGGLE
            track.BorderSizePixel  = 0
            track.Parent           = row
            Instance.new("UICorner", track).CornerRadius = UDim.new(0, 9)
            animStroke(track, 1)

            local knob = Instance.new("Frame")
            knob.Size             = UDim2.new(0, 14, 0, 14)
            knob.Position         = UDim2.new(0, 2, 0.5, -7)
            knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            knob.BorderSizePixel  = 0
            knob.Parent           = track
            Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)

            local btn = Instance.new("TextButton")
            btn.Size               = UDim2.new(0, 46, 1, 0)
            btn.Position           = UDim2.new(1, -46, 0, 0)
            btn.BackgroundTransparency = 1
            btn.Text               = ""
            btn.Parent             = row

            local state = default
            local function applyState(v)
                tweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                    Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                }):Play()
                tweenService:Create(track, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = v and COL_ACTIVE or COL_TOGGLE
                }):Play()
            end

            applyState(state)
            btn.MouseButton1Click:Connect(function()
                state = not state
                applyState(state)
                callback(state)
            end)

            local Toggle = {}
            function Toggle:Set(v)
                state = v
                applyState(state)
                callback(state)
            end
            function Toggle:Get() return state end
            return Toggle
        end

        function Tab:CreateSlider(sConfig)
            sConfig = sConfig or {}
            local lname    = sConfig.Name     or "Slider"
            local minVal   = sConfig.Min      or 0
            local maxVal   = sConfig.Max      or 100
            local default  = sConfig.Default  or minVal
            local callback = sConfig.Callback or function() end

            local rowTop = makeRow()
            makeLabel(rowTop, lname)

            local numLbl = Instance.new("TextLabel")
            numLbl.Size               = UDim2.new(0, 40, 1, 0)
            numLbl.Position           = UDim2.new(1, -48, 0, 0)
            numLbl.BackgroundTransparency = 1
            numLbl.Text               = tostring(default)
            numLbl.Font               = Enum.Font.GothamBlack
            numLbl.TextSize           = 11
            numLbl.TextColor3         = COL_YELLOW
            numLbl.TextXAlignment     = Enum.TextXAlignment.Right
            numLbl.Parent             = rowTop

            local sliderBg = Instance.new("Frame")
            sliderBg.Size               = UDim2.new(1, 0, 0, 16)
            sliderBg.BackgroundColor3   = Color3.fromRGB(20, 20, 22)
            sliderBg.BorderSizePixel    = 0
            sliderBg.LayoutOrder        = #tabPage:GetChildren()
            sliderBg.Parent             = tabPage
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 8)
            animStroke(sliderBg, 1)

            local sliderFill = Instance.new("Frame")
            sliderFill.Size             = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = COL_YELLOW
            sliderFill.BorderSizePixel  = 0
            sliderFill.Parent           = sliderBg
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 8)
            local fGrad = Instance.new("UIGradient")
            fGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 120, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 210, 50)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(160, 120, 10)),
            })
            fGrad.Parent = sliderFill

            local curVal = math.clamp(default, minVal, maxVal)
            local function updateSlider(val)
                curVal = math.clamp(math.floor(val), minVal, maxVal)
                local pct = (curVal - minVal) / (maxVal - minVal)
                tweenService:Create(sliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(pct, 0, 1, 0)
                }):Play()
                numLbl.Text = tostring(curVal)
                callback(curVal)
            end

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size               = UDim2.new(1, 0, 1, 0)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text               = ""
            sliderBtn.ZIndex             = 5
            sliderBtn.Parent             = sliderBg

            local dragging = false
            sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
            userInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            userInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    local absPos  = sliderBg.AbsolutePosition.X
                    local absSize = sliderBg.AbsoluteSize.X
                    local relX    = math.clamp((i.Position.X - absPos) / absSize, 0, 1)
                    updateSlider(minVal + relX * (maxVal - minVal))
                end
            end)

            updateSlider(curVal)

            local Slider = {}
            function Slider:Set(v) updateSlider(v) end
            function Slider:Get() return curVal end
            return Slider
        end

        function Tab:CreateInput(iConfig)
            iConfig = iConfig or {}
            local lname    = iConfig.Name        or "Input"
            local default  = iConfig.Default     or ""
            local placehldr= iConfig.Placeholder or "Type here..."
            local callback = iConfig.Callback    or function() end

            local row = makeRow()
            makeLabel(row, lname)

            local input = Instance.new("TextBox")
            input.Size               = UDim2.new(0, 70, 0, 22)
            input.Position           = UDim2.new(1, -78, 0.5, -11)
            input.BackgroundColor3   = Color3.fromRGB(20, 20, 22)
            input.BorderSizePixel    = 0
            input.Text               = default
            input.Font               = Enum.Font.GothamBlack
            input.TextSize           = 10
            input.TextColor3         = COL_YELLOW
            input.PlaceholderText    = placehldr
            input.PlaceholderColor3  = Color3.fromRGB(100, 80, 20)
            input.ClearTextOnFocus   = false
            input.Parent             = row
            Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
            animStroke(input, 1)

            input.FocusLost:Connect(function(enterPressed)
                callback(input.Text, enterPressed)
            end)

            local Input = {}
            function Input:Set(v) input.Text = v end
            function Input:Get() return input.Text end
            return Input
        end

        function Tab:CreateDropdown(dConfig)
            dConfig = dConfig or {}
            local lname    = dConfig.Name     or "Dropdown"
            local options  = dConfig.Options  or {}
            local default  = dConfig.Default  or (options[1] or "")
            local callback = dConfig.Callback or function() end

            local ROW_H     = 34
            local ITEM_H    = 26
            local OPEN_EXTRA = #options * (ITEM_H + 2) + 6

            local wrapper = Instance.new("Frame")
            wrapper.Size             = UDim2.new(1, 0, 0, ROW_H)
            wrapper.BackgroundTransparency = 1
            wrapper.BorderSizePixel  = 0
            wrapper.ClipsDescendants = false
            wrapper.LayoutOrder      = #tabPage:GetChildren()
            wrapper.Parent           = tabPage

            local row = Instance.new("Frame")
            row.Size                   = UDim2.new(1, 0, 0, ROW_H)
            row.Position               = UDim2.new(0, 0, 0, 0)
            row.BackgroundColor3       = COL_ROW
            row.BackgroundTransparency = 0.2
            row.BorderSizePixel        = 0
            row.ZIndex                 = 2
            row.Parent                 = wrapper
            Instance.new("UICorner", row)
            animStroke(row, 1)

            makeLabel(row, lname)

            local selectedLbl = Instance.new("TextLabel")
            selectedLbl.Size               = UDim2.new(0, 70, 1, 0)
            selectedLbl.Position           = UDim2.new(1, -80, 0, 0)
            selectedLbl.BackgroundTransparency = 1
            selectedLbl.Text               = default
            selectedLbl.Font               = Enum.Font.GothamBlack
            selectedLbl.TextSize           = 10
            selectedLbl.TextColor3         = COL_YELLOW
            selectedLbl.TextXAlignment     = Enum.TextXAlignment.Right
            selectedLbl.ZIndex             = 3
            selectedLbl.Parent             = row

            local arrow = Instance.new("TextLabel")
            arrow.Size                = UDim2.new(0, 14, 1, 0)
            arrow.Position            = UDim2.new(1, -14, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text                = "▾"
            arrow.Font                = Enum.Font.GothamBlack
            arrow.TextSize            = 11
            arrow.TextColor3          = COL_YELLOW
            arrow.ZIndex              = 3
            arrow.Parent              = row

            local dropList = Instance.new("Frame")
            dropList.Size             = UDim2.new(1, 0, 0, 0)
            dropList.Position         = UDim2.new(0, 0, 0, ROW_H + 2)
            dropList.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
            dropList.BorderSizePixel  = 0
            dropList.ClipsDescendants = true
            dropList.ZIndex           = 10
            dropList.Parent           = wrapper
            Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 7)
            local dStroke = Instance.new("UIStroke")
            dStroke.Thickness = 1
            dStroke.Color = Color3.fromRGB(80, 60, 10)
            dStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            dStroke.Parent = dropList

            local dLayout = Instance.new("UIListLayout")
            dLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dLayout.Padding   = UDim.new(0, 2)
            dLayout.Parent    = dropList

            local dPad = Instance.new("UIPadding")
            dPad.PaddingTop    = UDim.new(0, 3)
            dPad.PaddingBottom = UDim.new(0, 3)
            dPad.PaddingLeft   = UDim.new(0, 4)
            dPad.PaddingRight  = UDim.new(0, 4)
            dPad.Parent        = dropList

            local opened = false
            local curVal = default

            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size               = UDim2.new(1, 0, 0, ITEM_H)
                item.BackgroundColor3   = Color3.fromRGB(28, 28, 32)
                item.Text               = opt
                item.Font               = Enum.Font.GothamBlack
                item.TextSize           = 10
                item.TextColor3         = Color3.fromRGB(220, 200, 120)
                item.BorderSizePixel    = 0
                item.AutoButtonColor    = false
                item.ZIndex             = 11
                item.Parent             = dropList
                Instance.new("UICorner", item).CornerRadius = UDim.new(0, 5)

                item.MouseEnter:Connect(function()
                    tweenService:Create(item, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 35, 10)}):Play()
                end)
                item.MouseLeave:Connect(function()
                    tweenService:Create(item, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}):Play()
                end)
                item.MouseButton1Click:Connect(function()
                    curVal = opt
                    selectedLbl.Text = opt
                    opened = false
                    tweenService:Create(dropList, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    tweenService:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, ROW_H)
                    }):Play()
                    arrow.Text = "▾"
                    callback(opt)
                end)
            end

            local rowBtn = Instance.new("TextButton")
            rowBtn.Size               = UDim2.new(1, 0, 1, 0)
            rowBtn.BackgroundTransparency = 1
            rowBtn.Text               = ""
            rowBtn.ZIndex             = 4
            rowBtn.Parent             = row

            rowBtn.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    tweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, OPEN_EXTRA)
                    }):Play()
                    tweenService:Create(wrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, ROW_H + OPEN_EXTRA + 2)
                    }):Play()
                    arrow.Text = "▴"
                else
                    tweenService:Create(dropList, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    tweenService:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, ROW_H)
                    }):Play()
                    arrow.Text = "▾"
                end
            end)

            local Dropdown = {}
            function Dropdown:Set(v)
                curVal = v
                selectedLbl.Text = v
                callback(v)
            end
            function Dropdown:Get() return curVal end
            function Dropdown:Refresh(newOptions)
                for _, c in ipairs(dropList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                options = newOptions
                OPEN_EXTRA = #options * (ITEM_H + 2) + 6
                for _, opt in ipairs(options) do
                    local item = Instance.new("TextButton")
                    item.Size               = UDim2.new(1, 0, 0, ITEM_H)
                    item.BackgroundColor3   = Color3.fromRGB(28, 28, 32)
                    item.Text               = opt
                    item.Font               = Enum.Font.GothamBlack
                    item.TextSize           = 10
                    item.TextColor3         = Color3.fromRGB(220, 200, 120)
                    item.BorderSizePixel    = 0
                    item.AutoButtonColor    = false
                    item.ZIndex             = 11
                    item.Parent             = dropList
                    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 5)
                    item.MouseEnter:Connect(function()
                        tweenService:Create(item, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 35, 10)}):Play()
                    end)
                    item.MouseLeave:Connect(function()
                        tweenService:Create(item, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}):Play()
                    end)
                    item.MouseButton1Click:Connect(function()
                        curVal = opt
                        selectedLbl.Text = opt
                        opened = false
                        tweenService:Create(dropList, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        tweenService:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, ROW_H)
                        }):Play()
                        arrow.Text = "▾"
                        callback(opt)
                    end)
                end
            end
            return Dropdown
        end

        return Tab
    end

    return Window
end

return RRQUiLibrary
