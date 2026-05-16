local CryoLib = {}

function CryoLib:CreateWindow(hubName)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    local libData = {
        tabs = {},
        accent = Color3.fromRGB(120, 170, 255),
        visible = true,
        minimized = false,
        closing = false
    }

    -- [[ HELPER: Create Glow Effect with thin border ]]
    local function createGlow(parent, color, borderThickness)
        local thickness = borderThickness or 2
        
        local stroke = Instance.new("UIStroke", parent)
        stroke.Color = color
        stroke.Thickness = thickness
        stroke.Transparency = 0.2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local inner = Instance.new("UIStroke", parent)
        inner.Color = Color3.fromRGB(255, 255, 255)
        inner.Thickness = 1
        inner.Transparency = 0.6
        inner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        for i = 1, 3 do
            local glow = Instance.new("Frame", parent)
            glow.Name = "GlowLayer"..i
            glow.Size = UDim2.new(1, thickness + (i * 2), 1, thickness + (i * 2))
            glow.Position = UDim2.new(0, -(thickness/2) - i, 0, -(thickness/2) - i)
            glow.BackgroundColor3 = color
            glow.BackgroundTransparency = 0.75 + (i * 0.1)
            glow.ZIndex = parent.ZIndex - 1
            
            local glowCorner = Instance.new("UICorner", glow)
            local parentCorner = parent:FindFirstChildOfClass("UICorner")
            if parentCorner then
                glowCorner.CornerRadius = UDim.new(
                    parentCorner.CornerRadius.Scale, 
                    parentCorner.CornerRadius.Offset + i
                )
            else
                glowCorner.CornerRadius = UDim.new(0, 8 + i)
            end
        end
        
        return stroke
    end

    -- [[ ГЛАВНЫЙ GUI ]]
    local gui = Instance.new("ScreenGui")
    gui.Name = "CryoLib_Official_Final"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- [[ ПЛАВАЮЩАЯ КНОПКА С GLOW ]]
    local floatBtn = Instance.new("ImageButton")
    floatBtn.Size = UDim2.new(0, 0, 0, 0)
    floatBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
    floatBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    floatBtn.Image = "rbxassetid://12129379472"
    floatBtn.ZIndex = 100
    floatBtn.Parent = gui
    
    local floatCorner = Instance.new("UICorner", floatBtn)
    floatCorner.CornerRadius = UDim.new(1, 0)
    
    createGlow(floatBtn, libData.accent, 2)

    -- Animate float button appearance
    task.delay(0.2, function()
        TweenService:Create(floatBtn, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 48, 0, 48),
            Position = UDim2.new(0, 24, 0.5, -24)
        }):Play()
    end)

    -- Драг кнопки (smooth tween)
    local fDrag, fS, fP
    floatBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fDrag = true fS = i.Position fP = floatBtn.Position end end)
    UserInputService.InputChanged:Connect(function(i) if fDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - fS
        local np = UDim2.new(fP.X.Scale, fP.X.Offset + d.X, fP.Y.Scale, fP.Y.Offset + d.Y)
        TweenService:Create(floatBtn, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = np}):Play()
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fDrag = false fP = floatBtn.Position end end)

    -- [[ ГЛАВНАЯ ПАНЕЛЬ С GLOW ]]
    local mainPanel = Instance.new("Frame")
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    mainPanel.Parent = gui
    mainPanel.ClipsDescendants = true
    mainPanel.ZIndex = 10
    mainPanel.Visible = false
    
    local mainCorner = Instance.new("UICorner", mainPanel)
    mainCorner.CornerRadius = UDim.new(0, 16)
    
    createGlow(mainPanel, libData.accent, 2)

    local savedPosition = UDim2.new(0.5, -220, 0.5, -270)
    local savedSize = UDim2.new(0, 440, 0, 540)

    -- STARTUP ANIMATION — appear and grow
    task.delay(0.1, function()
        mainPanel.Visible = true
        TweenService:Create(mainPanel, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = savedSize,
            Position = savedPosition
        }):Play()
    end)

    local function getAnchorPoint()
        local headerTopLeft = mainPanel.AbsolutePosition + Vector2.new(16, 12)
        return UDim2.new(0, headerTopLeft.X, 0, headerTopLeft.Y)
    end

    local function animateShow()
        mainPanel.Visible = true
        local anchor = getAnchorPoint()
        mainPanel.Size = UDim2.new(0, 0, 0, 0)
        mainPanel.Position = anchor
        TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = savedSize,
            Position = savedPosition
        }):Play()
    end

    local function animateHide()
        local anchor = getAnchorPoint()
        TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = anchor
        }):Play()
        task.delay(0.3, function()
            mainPanel.Visible = false
            mainPanel.Size = savedSize
            mainPanel.Position = savedPosition
        end)
    end

    local function animateMinimize()
        if libData.minimized then
            local anchor = getAnchorPoint()
            mainPanel.Size = UDim2.new(0, 440, 0, 54)
            mainPanel.Position = anchor
            mainPanel.Visible = true
            TweenService:Create(mainPanel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = savedSize,
                Position = savedPosition
            }):Play()
            tabContainer.Visible = true
            contentArea.Visible = true
            libData.minimized = false
        else
            local anchor = getAnchorPoint()
            TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = anchor
            }):Play()
            task.delay(0.3, function()
                tabContainer.Visible = false
                contentArea.Visible = false
                mainPanel.Size = UDim2.new(0, 440, 0, 54)
                mainPanel.Position = savedPosition
                libData.minimized = true
            end)
        end
    end

    -- [[ SIMPLE CLOSE — shrink and destroy ]]
    local function animateClose()
        if libData.closing then return end
        libData.closing = true
        
        -- Shrink to center
        local center = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = center
        }):Play()
        
        -- Fade out float button
        TweenService:Create(floatBtn, TweenInfo.new(0.4), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.delay(0.6, function()
            gui:Destroy()
        end)
    end

    local function toggleGui()
        libData.visible = not libData.visible
        if libData.visible then
            animateShow()
        else
            animateHide()
        end
    end

    floatBtn.MouseButton1Click:Connect(toggleGui)
    UserInputService.InputBegan:Connect(function(i, gpe) if not gpe and i.KeyCode == Enum.KeyCode.K then toggleGui() end end)

    -- [[ HEADER ]]
    local header = Instance.new("Frame", mainPanel)
    header.Size = UDim2.new(1, 0, 0, 54)
    header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    header.BorderSizePixel = 0
    header.ZIndex = 11
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 16)

    local headerLogo = Instance.new("ImageLabel")
    headerLogo.Size = UDim2.new(0, 30, 0, 30)
    headerLogo.Position = UDim2.new(0, 16, 0, 12)
    headerLogo.BackgroundTransparency = 1
    headerLogo.Image = "rbxassetid://119085437225835"
    headerLogo.ScaleType = Enum.ScaleType.Fit
    headerLogo.Parent = header
    headerLogo.ZIndex = 12

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(0, 200, 0, 30)
    headerTitle.Position = UDim2.new(0, 52, 0, 12)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = hubName
    headerTitle.Font = Enum.Font.GothamBlack
    headerTitle.TextSize = 20
    headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = header
    headerTitle.ZIndex = 12

    -- [[ CLOSE BUTTON ]]
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 12)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Parent = header
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 12
    
    closeBtn.MouseButton1Click:Connect(animateClose)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(255, 80, 80)
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
    end)

    -- [[ MINIMIZE BUTTON ]]
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -72, 0, 12)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "−"
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 24
    minimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    minimizeBtn.Parent = header
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = 12
    
    minimizeBtn.MouseButton1Click:Connect(animateMinimize)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            TextColor3 = libData.accent
        }):Play()
    end)
    minimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
    end)

    -- Драг панели (smooth tween)
    local dDrag, dS, dI
    header.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 and not libData.minimized and not libData.closing then 
            dDrag = true 
            dI = i.Position 
            dS = mainPanel.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if dDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dI 
            local np = UDim2.new(dS.X.Scale, dS.X.Offset + d.X, dS.Y.Scale, dS.Y.Offset + d.Y)
            TweenService:Create(mainPanel, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = np}):Play()
            savedPosition = np
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then 
            dDrag = false
            dS = mainPanel.Position
        end 
    end)

    -- [[ КОНТЕЙНЕРЫ ]]
    local tabContainer = Instance.new("Frame", mainPanel)
    tabContainer.Size = UDim2.new(0, 110, 1, -54)
    tabContainer.Position = UDim2.new(0, 0, 0, 54)
    tabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    tabContainer.BorderSizePixel = 0
    tabContainer.ZIndex = 11
    
    local tabCorner = Instance.new("UICorner", tabContainer)
    tabCorner.CornerRadius = UDim.new(0, 16)

    local contentArea = Instance.new("Frame", mainPanel)
    contentArea.Size = UDim2.new(1, -110, 1, -54)
    contentArea.Position = UDim2.new(0, 110, 0, 54)
    contentArea.BackgroundTransparency = 1
    contentArea.ZIndex = 11

    -- [[ TAB INDICATOR ]]
    local tabIndicator = Instance.new("Frame", tabContainer)
    tabIndicator.Size = UDim2.new(0, 3, 0, 0)
    tabIndicator.Position = UDim2.new(0, 8, 0, 0)
    tabIndicator.BackgroundColor3 = libData.accent
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Visible = false
    tabIndicator.ZIndex = 12

    function libData:CreateTab(name)
        local tabObj = {}
        local scroll = Instance.new("ScrollingFrame", contentArea)
        scroll.Size = UDim2.new(1, -24, 1, -20)
        scroll.Position = UDim2.new(0, 12, 0, 10)
        scroll.Visible = false
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ZIndex = 11
        
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local padding = Instance.new("UIPadding", scroll)
        padding.PaddingTop = UDim.new(0, 4)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 4)
        padding.PaddingRight = UDim.new(0, 4)

        local btn = Instance.new("TextButton", tabContainer)
        btn.Size = UDim2.new(1, -16, 0, 38)
        btn.Position = UDim2.new(0, 8, 0, #libData.tabs * 42 + 12)
        btn.Text = name
        btn.BackgroundTransparency = 1
        btn.TextColor3 = Color3.fromRGB(130, 130, 145)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.ZIndex = 12
        
        local tabBg = Instance.new("Frame", btn)
        tabBg.Size = UDim2.new(1, 0, 1, 0)
        tabBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        tabBg.BackgroundTransparency = 1
        tabBg.ZIndex = 11
        
        local tabBgCorner = Instance.new("UICorner", tabBg)
        tabBgCorner.CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(libData.tabs) do
                t.s.Visible = false
                t.b.TextColor3 = Color3.fromRGB(130, 130, 145)
                TweenService:Create(t.bg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
            scroll.Visible = true
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(tabBg, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            
            tabIndicator.Visible = true
            TweenService:Create(tabIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0, 8, 0, btn.AbsolutePosition.Y - tabContainer.AbsolutePosition.Y),
                Size = UDim2.new(0, 3, 0, 38)
            }):Play()
        end)
        
        btn.MouseEnter:Connect(function()
            if scroll.Visible then return end
            TweenService:Create(tabBg, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if scroll.Visible then return end
            TweenService:Create(tabBg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)
        
        table.insert(libData.tabs, {s = scroll, b = btn, bg = tabBg})
        
        if #libData.tabs == 1 then
            scroll.Visible = true
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBg.BackgroundTransparency = 0
            tabIndicator.Visible = true
            tabIndicator.Size = UDim2.new(0, 3, 0, 38)
            tabIndicator.Position = UDim2.new(0, 8, 0, btn.AbsolutePosition.Y - tabContainer.AbsolutePosition.Y)
        end

        function tabObj:CreateToggle(txt, callback)
            local state = false
            local f = Instance.new("Frame", scroll)
            f.Size = UDim2.new(1, -4, 0, 48)
            f.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            f.BorderSizePixel = 0
            f.ZIndex = 11
            
            local fCorner = Instance.new("UICorner", f)
            fCorner.CornerRadius = UDim.new(0, 10)
            
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -70, 1, 0)
            l.Position = UDim2.new(0, 14, 0, 0)
            l.Text = txt
            l.Font = Enum.Font.GothamBold
            l.TextColor3 = Color3.fromRGB(220, 220, 235)
            l.BackgroundTransparency = 1
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextSize = 14
            l.ZIndex = 12
            
            local bg = Instance.new("Frame", f)
            bg.Size = UDim2.new(0, 40, 0, 22)
            bg.Position = UDim2.new(1, -52, 0.5, -11)
            bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            bg.BorderSizePixel = 0
            bg.ZIndex = 12
            
            local bgCorner = Instance.new("UICorner", bg)
            bgCorner.CornerRadius = UDim.new(1, 0)
            
            local c = Instance.new("Frame", bg)
            c.Size = UDim2.new(0, 18, 0, 18)
            c.Position = UDim2.new(0, 2, 0.5, -9)
            c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            c.BorderSizePixel = 0
            c.ZIndex = 13
            
            local cCorner = Instance.new("UICorner", c)
            cCorner.CornerRadius = UDim.new(1, 0)
            
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.AutoButtonColor = false
            b.ZIndex = 14
            
            b.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(bg, TweenInfo.new(0.25), {BackgroundColor3 = state and libData.accent or Color3.fromRGB(50, 50, 65)}):Play()
                TweenService:Create(c, TweenInfo.new(0.25), {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                callback(state)
            end)
        end

        function tabObj:CreateSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame", scroll)
            frame.Size = UDim2.new(1, -4, 0, 68)
            frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            frame.BorderSizePixel = 0
            frame.ZIndex = 11
            
            local frameCorner = Instance.new("UICorner", frame)
            frameCorner.CornerRadius = UDim.new(0, 10)
            
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, -24, 0, 22)
            label.Position = UDim2.new(0, 14, 0, 10)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. default
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(220, 220, 235)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 12
            
            local track = Instance.new("Frame", frame)
            track.Size = UDim2.new(1, -36, 0, 6)
            track.Position = UDim2.new(0, 18, 0, 44)
            track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            track.BorderSizePixel = 0
            track.ZIndex = 12
            
            local trackCorner = Instance.new("UICorner", track)
            trackCorner.CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", track)
            local p = math.clamp((default - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0)
            fill.BackgroundColor3 = libData.accent
            fill.BorderSizePixel = 0
            fill.ZIndex = 13
            
            local fillCorner = Instance.new("UICorner", fill)
            fillCorner.CornerRadius = UDim.new(1, 0)
            
            local handle = Instance.new("Frame", track)
            handle.Size = UDim2.new(0, 16, 0, 16)
            handle.Position = UDim2.new(p, -8, 0.5, -8)
            handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            handle.BorderSizePixel = 0
            handle.ZIndex = 14
            
            local handleCorner = Instance.new("UICorner", handle)
            handleCorner.CornerRadius = UDim.new(1, 0)
            
            local handleStroke = Instance.new("UIStroke", handle)
            handleStroke.Color = Color3.fromRGB(180, 180, 200)
            handleStroke.Thickness = 1

            local dragging = false
            local function update()
                local m = math.clamp((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (m * (max - min)))
                label.Text = text .. ": " .. val
                fill.Size = UDim2.new(m, 0, 1, 0)
                handle.Position = UDim2.new(m, -8, 0.5, -8)
                callback(val)
            end

            -- Overlay button lebih gede buat nangkep input slider dengan bener
            local sliderBtn = Instance.new("TextButton", frame)
            sliderBtn.Size = UDim2.new(1, -36, 0, 28)
            sliderBtn.Position = UDim2.new(0, 18, 0, 34)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.AutoButtonColor = false
            sliderBtn.ZIndex = 15

            sliderBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end

        function tabObj:CreateButton(txt, callback)
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, -4, 0, 44)
            b.BackgroundColor3 = libData.accent
            b.Text = txt
            b.Font = Enum.Font.GothamBlack
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.TextSize = 14
            b.AutoButtonColor = false
            b.ZIndex = 12
            
            local bCorner = Instance.new("UICorner", b)
            bCorner.CornerRadius = UDim.new(0, 10)
            
            b.MouseButton1Click:Connect(callback)
            
            b.MouseEnter:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 185, 255)}):Play()
            end)
            b.MouseLeave:Connect(function()
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = libData.accent}):Play()
            end)
        end
        
        function tabObj:CreateLabel(txt)
            local l = Instance.new("TextLabel", scroll)
            l.Size = UDim2.new(1, 0, 0, 28)
            l.Text = txt
            l.TextColor3 = libData.accent
            l.Font = Enum.Font.GothamBlack
            l.BackgroundTransparency = 1
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 12
        end
        
        return tabObj
    end
    
    return libData
end

return CryoLib
