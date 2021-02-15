local nguiRealFont = 'Open Sans' -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name

WhenGMLoaded('NBase Fonts',function()
	nguiRealFont = ix and ix.config.Get('genericFont') or nguiRealFont
end)

-- ix.config.Get("font"), ix.config.Get("genericFont")

-- TODO: Перевести все шрифты на ix шрифты, изза хреновой поддержки киррилицы в gmod.

local function CreateFonts(font,tbl)
	surface.CreateFont(font,tbl)
	tbl.shadow = true
	surface.CreateFont(font..'_s',tbl)
	tbl.shadow = nil
	tbl.outline = true
	surface.CreateFont(font..'_o',tbl)
end


-- surface.CreateFont('N',{
-- 	font = nguiRealFont, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
-- 	extended = false,
-- 	size = 13,
-- 	weight = 500,
-- 	blursize = 0,
-- 	scanlines = 0,
-- 	antialias = true,
-- 	underline = false,
-- 	italic = false,
-- 	strikeout = false,
-- 	symbol = false,
-- 	rotary = false,
-- 	shadow = false,
-- 	additive = false,
-- 	outline = false,
-- })

local commonWeight = 1000

surface.CreateFont('N_ent',{
	font = nguiRealFont,
	size = 23,
	weight = commonWeight-300,
	additive = true,
})

CreateFonts('N',{
	font = nguiRealFont,
	size = 20,
	weight = commonWeight,
})

CreateFonts('N_small',{
	font = nguiRealFont,
	size = 17,
	weight = commonWeight,
})

CreateFonts('N_smaller',{
	font = nguiRealFont,
	size = 13,
	weight = commonWeight,
})

local mul = (ScrW() < 700 or ScrH() < 700) and 0.6 or 1

CreateFonts('N_medium',{
	font = nguiRealFont,
	size = 25*mul,
	weight = commonWeight,
})

CreateFonts('N_large',{
	font = nguiRealFont,
	size = 35*mul,
	weight = commonWeight-400,
})

for i=1,6 do -- 6,12,18,24,30
	surface.CreateFont('draw_'..(6*i),{
		font = 'Tahoma',
		size = 6*i,
		weight = commonWeight-200,
	})
end

-- Для BadCoderz LagFinder'a
surface.CreateFont('Trebuchet48',{
	font = nguiRealFont,
	size = 48,
	weight = commonWeight-300,
	additive = true,
})
