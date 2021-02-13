-- [do not obfuscate]

local ScrW,ScrH = ScrW,ScrH

function CWGUI:Frame(title)
	local fr = CWGUI:UnfocusedFrame(title)
	fr:MakePopup()

	return fr
end

function CWGUI:AddFrameBehavior(fr,title)
	fr:SetDraggable(true)
	fr:SetSizable(false)
	fr:SetTitle(title or '')
	fr:SetBackgroundBlur(true)
	fr:SetPaintShadow(true)
	CWGUI:ResizeFrame(fr)
	fr.btnMinim:SetVisible(false)
	fr.btnMaxim:SetVisible(false)
	fr.btnClose:SetVisible(false)
	local close = fr:Add(CWGUI:DeclineButton('X',function()
		fr:Close()
	end))
	close:SetSize(35, 25)
	close:SetPos(fr:GetWide()-close:GetWide(),0)
	close:SetFont('N')
	fr.lblTitle.UpdateColours = function(label)
		label:SetTextStyleColor(CWC:ThemeText())
	end
	fr.lblTitle:SetFont('N')
	fr.Paint = function(pnl)
		-- Draw the menu background color.
		draw.RoundedBox(6, 0, 0, pnl:GetWide(), pnl:GetTall(), fr.NBackgroundColor or CWC:ThemeInside())
	end
end

function CWGUI:ResizeFrame(fr)
	fr:SetSize(ScrW()*0.7, ScrH()*0.8)
    fr:Center()
end

function CWGUI:UnfocusedFrame(title)
	local fr = vgui.Create('DFrame')

	CWGUI:AddFrameBehavior(fr,title)

	return fr
end

function CWGUI:InputFrame(title, acceptFunc, typeOfInput)
	local fr = CWGUI:Frame()
	fr:SetIcon('icon16/pencil.png')
	fr:SetSize(ScrW() / 4, 85)
	fr:Center()

	local inp = fr:Add(CWGUI:InputPanel(title, acceptFunc, typeOfInput,fr))
	inp:Dock(FILL)
	fr.mainPanel = inp

	timer.Simple(0, function()
		inp.editPanel:RequestFocus()
	end)

	local c = inp.subPanel:Add(CWGUI:AcceptButton())
	c:Dock(RIGHT)
	c:SetWide(fr:GetWide() / 4)

	c.DoClick = function() inp.editPanel.OnEnter() end

	for _, v in pairs(inp.subPanel:GetChildren()) do
		v:DockMargin(2, 0, 2, 0)
	end

	return fr

end

function CWGUI:BinderFrame(title,command)
	local fr = CWGUI:Frame(title)
	fr:SetSize(250,100)
	fr:Center()
	local color = CWC:ThemeInside()
	color.a = 255
	fr.NBackgroundColor = color

	local binder = fr:Add(CWGUI:BinderPanel(command))

	return fr,binder
end

-- окно для редактирования каких-либо правил (для зоны, для админки и т.п.)
function CWGUI:RulesFrame(title, checkBoxes, acceptFunc)
	local fr = CWGUI:Frame()
	fr:SetIcon('icon16/pencil.png')
	fr:SetSize(400, 400)
	fr:SetTitle(title)
	fr:Center()
	local scroll = fr:Add('DScrollPanel')
	scroll:Dock(FILL)
	local chArray = {}

	for k, v in pairs(checkBoxes) do
		local p = scroll:Add('DPanel')
		p:SetPaintBackground(true)
		p:SetBackgroundColor(CWC:Grey(100))
		p:Dock(TOP)
		p:DockMargin(0, 2, 0, 2)
		local ch = p:Add('DCheckBoxLabel')
		ch:SetValue(v.checked)
		ch:Dock(FILL)
		ch:SetText(v.name)
		ch:SetFont('N')
		ch:SetTextColor(CWC:White())
		ch:DockMargin(5, 0, 0, 5)
		ch.Button:Dock(LEFT)
		ch.Button:DockMargin(0, 4, 0, 0)
		ch.rule = k
		table.insert(chArray, ch)
	end

	local p1 = vgui.Create('DPanel', fr)
	p1:SetPaintBackground(false)
	p1:Dock(BOTTOM)
	local c = p1:Add(CWGUI:AcceptButton())
	c:Dock(RIGHT)
	c:SetWide(150)

	c.DoClick = function()
		local checkedStr = ''

		for _, v in pairs(chArray) do
			if v:GetChecked() then
				checkedStr = checkedStr .. v.rule
			end
		end

		fr:Close()
		acceptFunc(checkedStr)
	end

	for _, v in pairs(p1:GetChildren()) do
		v:DockMargin(2, 0, 2, 0)
	end

	return fr
end

function CWGUI:AcceptDialogue(text, textYes, textNo, acceptFunc)
	local fr = CWGUI:Frame()
	fr:SetIcon('icon16/help.png')
	fr:SetWide(530)
	local txt = vgui.Create('DMultiline', fr)
	txt:SetText(text)
	txt:SetContentAlignment(5)
	txt:DockPadding(2, 2, 2, 2)
	txt:Dock(FILL)
	txt:SetTextColor(CWC:ThemeText())
	txt:SetFont('N_small')

	if LocalPlayer():GetLang() == 'ru' then
		fr:SetTall(#text / 1.5)
	else
		fr:SetTall(#text * 1.5)
	end

	fr:Center()
	local p2 = vgui.Create('DPanel', fr)
	p2:SetPaintBackground(false)
	p2:Dock(BOTTOM)
	local d = p2:Add(CWGUI:DeclineButton(textNo))
	d:Dock(LEFT)
	d:SetWide(fr:GetWide() / 4)

	d.DoClick = function()
		fr:Close()
	end

	local c = p2:Add(CWGUI:AcceptButton(textYes))
	c:Dock(RIGHT)
	c:SetWide(fr:GetWide() / 4)

	c.DoClick = function()
		fr:Close()
		acceptFunc()
	end

	for _, v in pairs(p2:GetChildren()) do
		v:DockMargin(2, 0, 2, 0)
	end

	fr:SetTall(fr:GetTall() + 50)

	return fr
end

function CWGUI:ListFrame(title)
	local fr = CWGUI:Frame(title)
	local scroll = fr:Add('DScrollPanel')
	scroll:Dock(FILL)
	fr.list = scroll:Add(CWGUI:List())
	fr.list:Dock(TOP)

	return fr
end

function CWGUI:ManyFieldsFrame(text, tblFields, acceptFunc)
	local fr = CWGUI:Frame(text)
	local tile = fr:Add(CWGUI:InputFields(tblFields, acceptFunc))

	return fr,tile.inputs
end