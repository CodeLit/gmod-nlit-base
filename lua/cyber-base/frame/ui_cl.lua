local D = CW:Lib('draw')
local Buttons = CW:Lib('buttons')
local Frames = CW:Lib('frames')
local Icons = CW:Lib('icons')
local Inputs = CW:Lib('inputs')
local Panels = CW:Lib('panels')
local CWStr = CW:Lib('strings')
local CWC = CW:Lib('colors')
local TblLsts = CW:Lib('table_lists')
local HTML = CW:Lib('html')
local Text = CW:Lib('text')

local addons_short_name = 'CW'
local addons_website = 'https://neolife.tk/ru' -- Английский нужно добавлять отдельно
local last_selected_category

local fr

Buttons:AddToCMenu(addons_short_name..' '..l('Addons'),Icons:GetPath('cyber/logo256.png'),50,function(invalidFrame)

    local function add_save_btn(inp_pnl,addon_name)
        local save = inp_pnl:Add(Buttons:Accept(l('Save changes')))
        save:Dock(BOTTOM)
        save:SetTall(30)
        save.DoClick = function(pnl)

            local inputsData = {}
            for _,inp in pairs(inp_pnl.lst.inputs) do
                inputsData[inp.option] = inp:GetInputValue()
            end

            local pkt = GNet.Packet(NCfg.NetStr)
            pkt:WriteUInt(1,GNet.CalculateRequiredBits(100))
            pkt:WriteString(addon_name)
            pkt:WriteString(CWStr:ToJson(inputsData))
            pkt:Send()
            LocalPlayer():Notify(l('The changes was saved')..'.')
        end
    end

    invalidFrame:Close()

    if IsValid(fr) then return end

    fr = Frames:Create(l("CyberWolf's Addons"))
    fr:SetIcon(Icons:GetPath('cyber/wolf-logo.png'))

    local leftP = fr:Add(Panels:Create())
    leftP:SetWide(fr:GetWide()/4.5)
    leftP:Dock(LEFT)
    leftP.NoOutline = true

    local centerP = fr:Add(Panels:Create())
    centerP:Dock(FILL)
    centerP:DockPadding(10, 10, 10, 10)
    centerP.NoOutline = true

    local selectedCat
    local buttons = {}

    local leftCategories = {
        {
            name = l('More addons'),
            icon = 'interface/033-share.png',
            open = function(cpnl)
                local html = HTML:MakeInPanel(cpnl)
                html:OpenURL(addons_website..'/gmod-resources/addons')
            end,
        },
        {
            name = l('Addons settings'),
            icon = 'web/038-controls.png',
            access = function()
                if !NCfg.CheckAccess(LocalPlayer()) then
                    LocalPlayer():Notify(l('You have no access rights to addons configuration')..'!')
                    return false
                end
                return true
            end,
            open = function(cpnl)

                local addons = {}

                for k,_ in pairs(NCfg.svTable or {}) do
                    if k == NCfg.Name then continue end
                    table.insert(addons, k)
                end

                if #addons == 0 then
                    local spaceBetween = 30
                    local label = cpnl:Add(Text:Create(l('You have no installed addons')..'!'))
                    label:SetFont('N_large')
                    label:SizeToContents()
                    label:SetPos(cpnl:GetWide()/2-label:GetWide()/2,cpnl:GetTall()/2-label:GetTall()/2-spaceBetween)

                    local toAddons = cpnl:Add(Buttons:Accept('Get addons',function()
                        buttons[1].DoClick()
                    end))
                    toAddons:SetFont('N_large')
                    toAddons:SizeToContents()
                    toAddons:SetWide(toAddons:GetWide()+25)
                    toAddons:SetTall(toAddons:GetTall()+15)
                    toAddons:SetPos(cpnl:GetWide()/2-toAddons:GetWide()/2,cpnl:GetTall()/2-toAddons:GetTall()/2+spaceBetween)


                    return
                end

                local function SelectAddon(addon)
                    addon = addon or addons[1]
                    local addonData = NCfg.svTable[addon]

                    local mainP = IsValid(cpnl.mainP) and cpnl.mainP or cpnl:Add(Panels:Create())
                    mainP.NoOutline = true
                    mainP:Clear()
                    mainP:Dock(FILL)

                    cpnl.mainP = mainP

                    local lst = mainP:Add(Inputs:Fields(addonData))
                    cpnl.lst = lst

                    NCfg.selectedAddon = addon
                end

                local topLabel = cpnl:Add(Text:Create(l('Select addon for setup')..':'))
                topLabel:Dock(TOP)
                topLabel:SetColor(CWC:White())

                local variant = cpnl:Add(TblLsts:Variant(addons, function(pnl,i,v)
                    SelectAddon(v)
                end))

                variant:Dock(TOP)
                variant:DockMargin(0, 0, 0, 10)
                variant:SetValue(NCfg.selectedAddon or addons[1])

                SelectAddon(NCfg.selectedAddon)

                add_save_btn(cpnl,NCfg.selectedAddon)
            end,
        },
        {
            name = l('Server settings'),
            icon = 'web/040-settings-1.png',
            open = function(cpnl)
                local svCfgData = NCfg.svTable[NCfg.Name]
                cpnl.lst = cpnl:Add(Inputs:Fields(svCfgData))
                add_save_btn(cpnl,NCfg.Name)
            end,
        },
        {
            name = l('Upgrade my Gmod'),
            icon = 'web/005-bar-chart.png',
            open = function(cpnl)
                local html = HTML:MakeInPanel(cpnl)
                html:OpenURL(addons_website..'/gmod-resources/upgrade')
            end,
        },
        {
            name = l('For server owners'),
            icon = 'interface/021-server.png',
            open = function(cpnl)
                local html = HTML:MakeInPanel(cpnl)
                html:OpenURL(addons_website..'/gmod-resources/for-server-owners')
            end,
        },
        {
            name = l('Addons subscription'),
            icon = 'web/051-star.png',
            open = function(cpnl)
                local html = HTML:MakeInPanel(cpnl)
                html:OpenURL(addons_website..'/gmod-resources/addons-subscription')
            end,
        },
    }

    for i,v in pairs(leftCategories) do
        local btn = leftP:Add(Buttons:Create(v.name,function()
            if (v.access and !v.access()) or selectedCat == v.name then
                return
            end
            selectedCat = v.name
            centerP:Clear()
            v.open(centerP)
            last_selected_category = i
        end))
        btn:Dock(TOP)
        btn:SetTall(50)
        btn:SetFont('N')
        if v.icon then
            btn.RightIcon = v.icon
        end
        table.insert( buttons, btn)
    end
    buttons[last_selected_category or 1].DoClick()
end)