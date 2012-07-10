local lujgl = require "lujgl"

local gl = lujgl.gl
local glu = lujgl.glu

mab = mab or {}
mab.font = mab.font or {}


  --
 -- Hardcoded font table -- I'm lazy!
--
mab.font = {
	width=2048, height=1024,
	
	dds = "R:\\Juegos\\swconquest\\modules\\swconquest\\Textures\\FONT_SWC.dds",
    xml = "R:\\Juegos\\swconquest\\modules\\swconquest\\Module Data\\FONT_DATA.XML",
	
	[32]={u=2030 , v=0  , w=2045, h=15 , preshift=0 , yadjust=11, postshift=32},
	[33]={u=96   , v=211, w=117 , h=270, preshift=-4, yadjust=56, postshift=13},
	[34]={u=417  , v=260, w=445 , h=290, preshift=-2, yadjust=56, postshift=25},
	[35]={u=618  , v=144, w=676 , h=203, preshift=-7, yadjust=56, postshift=49},
	[36]={u=141  , v=211, w=204 , h=267, preshift=-6, yadjust=53, postshift=52},
	[37]={u=1617 , v=73 , w=1684, h=132, preshift=-4, yadjust=56, postshift=59},
	[38]={u=1271 , v=143, w=1327, h=202, preshift=-1, yadjust=56, postshift=49},
	[39]={u=471  , v=260, w=491 , h=290, preshift=-2, yadjust=56, postshift=16},
	[40]={u=92   , v=0  , w=126 , h=79 , preshift=-1, yadjust=66, postshift=27},
	[41]={u=128  , v=0  , w=162 , h=79 , preshift=-2, yadjust=66, postshift=27},
	[42]={u=276  , v=268, w=314 , h=304, preshift=-6, yadjust=56, postshift=25},
	[43]={u=89   , v=272, w=127 , h=309, preshift=-4, yadjust=45, postshift=29},
	[44]={u=447  , v=260, w=469 , h=290, preshift=-3, yadjust=17, postshift=16},
	[45]={u=608  , v=260, w=641 , h=280, preshift=-4, yadjust=36, postshift=24},
	[46]={u=643  , v=260, w=663 , h=280, preshift=-3, yadjust=17, postshift=14},
	[47]={u=48   , v=211, w=94  , h=270, preshift=-7, yadjust=56, postshift=32},
	[48]={u=918  , v=143, w=975 , h=202, preshift=-3, yadjust=56, postshift=52},
	[49]={u=1890 , v=131, w=1940, h=190, preshift=1 , yadjust=56, postshift=52},
	[50]={u=1503 , v=134, w=1558, h=193, preshift=-2, yadjust=56, postshift=52},
	[51]={u=1213 , v=143, w=1269, h=202, preshift=-1, yadjust=56, postshift=52},
	[52]={u=558  , v=144, w=616 , h=203, preshift=-4, yadjust=56, postshift=52},
	[53]={u=1387 , v=135, w=1443, h=194, preshift=-1, yadjust=56, postshift=52},
	[54]={u=1154 , v=143, w=1211, h=202, preshift=-3, yadjust=56, postshift=52},
	[55]={u=1445 , v=135, w=1501, h=194, preshift=-2, yadjust=56, postshift=52},
	[56]={u=1095 , v=143, w=1152, h=202, preshift=-3, yadjust=56, postshift=52},
	[57]={u=1036 , v=143, w=1093, h=202, preshift=-3, yadjust=56, postshift=52},
	[58]={u=1926 , v=192, w=1947, h=238, preshift=-3, yadjust=43, postshift=14},
	[59]={u=206  , v=211, w=228 , h=267, preshift=-4, yadjust=43, postshift=15},
	[60]={u=1989 , v=192, w=2031, h=233, preshift=-5, yadjust=47, postshift=33},
	[61]={u=493  , v=260, w=531 , h=289, preshift=-4, yadjust=41, postshift=29},
	[62]={u=0    , v=272, w=42  , h=313, preshift=-4, yadjust=47, postshift=33},
	[63]={u=1942 , v=131, w=1992, h=190, preshift=-6, yadjust=56, postshift=42},
	[64]={u=858  , v=144, w=916 , h=203, preshift=-2, yadjust=56, postshift=55},
	[65]={u=1820 , v=70 , w=1882, h=129, preshift=-5, yadjust=56, postshift=52},
	[66]={u=977  , v=143, w=1034, h=202, preshift=-1, yadjust=56, postshift=54},
	[67]={u=1673 , v=134, w=1727, h=193, preshift=-2, yadjust=56, postshift=49},
	[68]={u=497  , v=144, w=556 , h=203, preshift=-1, yadjust=56, postshift=56},
	[69]={u=1617 , v=134, w=1671, h=193, preshift=-1, yadjust=56, postshift=50},
	[70]={u=1729 , v=134, w=1782, h=193, preshift=-1, yadjust=56, postshift=48},
	[71]={u=436  , v=144, w=495 , h=203, preshift=-2, yadjust=56, postshift=55},
	[72]={u=798  , v=144, w=856 , h=203, preshift=-1, yadjust=56, postshift=57},
	[73]={u=119  , v=211, w=139 , h=270, preshift=0 , yadjust=56, postshift=20},
	[74]={u=1838 , v=131, w=1888, h=190, preshift=-6, yadjust=56, postshift=42},
	[75]={u=738  , v=144, w=796 , h=203, preshift=-1, yadjust=56, postshift=52},
	[76]={u=1994 , v=131, w=2044, h=190, preshift=-1, yadjust=56, postshift=44},
	[77]={u=1753 , v=71 , w=1818, h=130, preshift=-1, yadjust=56, postshift=64},
	[78]={u=678  , v=144, w=736 , h=203, preshift=-1, yadjust=56, postshift=56},
	[79]={u=1884 , v=70 , w=1946, h=129, preshift=-2, yadjust=56, postshift=57},
	[80]={u=1560 , v=134, w=1615, h=193, preshift=-1, yadjust=56, postshift=50},
	[81]={u=1789 , v=0  , w=1851, h=68 , preshift=-2, yadjust=56, postshift=57},
	[82]={u=128  , v=150, w=188 , h=209, preshift=-1, yadjust=56, postshift=57},
	[83]={u=1329 , v=139, w=1385, h=198, preshift=-4, yadjust=56, postshift=49},
	[84]={u=252  , v=150, w=312 , h=209, preshift=-4, yadjust=56, postshift=51},
	[85]={u=375  , v=144, w=434 , h=203, preshift=-1, yadjust=56, postshift=57},
	[86]={u=0    , v=150, w=62  , h=209, preshift=-5, yadjust=56, postshift=52},
	[87]={u=1466 , v=73 , w=1543, h=132, preshift=-6, yadjust=56, postshift=64},
	[88]={u=64   , v=150, w=126 , h=209, preshift=-6, yadjust=56, postshift=50},
	[89]={u=1686 , v=73 , w=1751, h=132, preshift=-7, yadjust=56, postshift=51},
	[90]={u=190  , v=150, w=250 , h=209, preshift=-4, yadjust=56, postshift=51},
	[91]={u=164  , v=0  , w=193 , h=79 , preshift=-1, yadjust=66, postshift=27},
	[92]={u=0    , v=211, w=46  , h=270, preshift=-7, yadjust=56, postshift=32},
	[93]={u=195  , v=0  , w=224 , h=79 , preshift=-1, yadjust=66, postshift=27},
	[94]={u=168  , v=269, w=204 , h=306, preshift=4 , yadjust=56, postshift=45},
	[95]={u=562  , v=260, w=606 , h=280, preshift=-5, yadjust=11, postshift=35},
	[96]={u=533  , v=260, w=560 , h=284, preshift=9 , yadjust=64, postshift=51},
	[97]={u=787  , v=205, w=845 , h=258, preshift=-5, yadjust=50, postshift=47},
	[98]={u=1197 , v=204, w=1252, h=257, preshift=-1, yadjust=50, postshift=52},
	[99]={u=1695 , v=195, w=1746, h=248, preshift=-2, yadjust=50, postshift=46},
	[100]={u=1140, v=204, w=1195, h=257, preshift=-1, yadjust=50, postshift=52},
	[101]={u=1587, v=195, w=1639, h=248, preshift=-1, yadjust=50, postshift=48},
	[102]={u=1533, v=195, w=1585, h=248, preshift=-1, yadjust=50, postshift=46},
	[103]={u=1083, v=204, w=1138, h=257, preshift=-2, yadjust=50, postshift=52},
	[104]={u=1478, v=196, w=1531, h=249, preshift=-1, yadjust=50, postshift=51},
	[105]={u=1904, v=192, w=1924, h=245, preshift=0 , yadjust=50, postshift=20},
	[106]={u=1800, v=193, w=1850, h=246, preshift=-6, yadjust=50, postshift=42},
	[107]={u=1025, v=204, w=1081, h=257, preshift=-1, yadjust=50, postshift=50},
	[108]={u=1852, v=192, w=1902, h=245, preshift=-1, yadjust=50, postshift=44},
	[109]={u=601 , v=205, w=663 , h=258, preshift=-1, yadjust=50, postshift=60},
	[110]={u=727 , v=205, w=785 , h=258, preshift=-1, yadjust=50, postshift=56},
	[111]={u=847 , v=205, w=905 , h=258, preshift=-2, yadjust=50, postshift=53},
	[112]={u=1641, v=195, w=1693, h=248, preshift=-1, yadjust=50, postshift=48},
	[113]={u=1272, v=75 , w=1330, h=137, preshift=-2, yadjust=50, postshift=53},
	[114]={u=1254, v=204, w=1308, h=257, preshift=-1, yadjust=50, postshift=50},
	[115]={u=1748, v=195, w=1798, h=248, preshift=-4, yadjust=50, postshift=42},
	[116]={u=1366, v=200, w=1420, h=253, preshift=-4, yadjust=50, postshift=45},
	[117]={u=1422, v=196, w=1476, h=249, preshift=-1, yadjust=50, postshift=51},
	[118]={u=665 , v=205, w=725 , h=258, preshift=-5, yadjust=50, postshift=50},
	[119]={u=459 , v=205, w=530 , h=258, preshift=-5, yadjust=50, postshift=62},
	[120]={u=907 , v=205, w=964 , h=258, preshift=-6, yadjust=50, postshift=46},
	[121]={u=966 , v=204, w=1023, h=257, preshift=-6, yadjust=50, postshift=44},
	[122]={u=1310, v=204, w=1364, h=257, preshift=-4, yadjust=50, postshift=46},
	[123]={u=46  , v=0  , w=90  , h=79 , preshift=-4, yadjust=66, postshift=34},
	[124]={u=226 , v=0  , w=246 , h=79 , preshift=0 , yadjust=66, postshift=20},
	[125]={u=0   , v=0  , w=44  , h=79 , preshift=-4, yadjust=66, postshift=34},
	[126]={u=352 , v=266, w=415 , h=297, preshift=-1, yadjust=39, postshift=61},
	[160]={u=699 , v=260, w=714 , h=275, preshift=-7, yadjust=11, postshift=32},
	[161]={u=2012, v=69 , w=2033, h=128, preshift=-4, yadjust=43, postshift=13},
	[169]={u=314 , v=146, w=373 , h=205, preshift=-1, yadjust=56, postshift=57},
	[174]={u=316 , v=266, w=350 , h=300, preshift=-1, yadjust=56, postshift=32},
	[175]={u=665 , v=260, w=697 , h=278, preshift=9 , yadjust=67, postshift=51},
	[176]={u=129 , v=272, w=166 , h=309, preshift=-2, yadjust=56, postshift=32},
	[178]={u=206 , v=269, w=239 , h=306, preshift=-4, yadjust=56, postshift=25},
	[179]={u=241 , v=268, w=274 , h=305, preshift=-4, yadjust=56, postshift=25},
	[191]={u=1784, v=132, w=1836, h=191, preshift=-2, yadjust=43, postshift=44},
	[192]={u=636 , v=0  , w=698 , h=73 , preshift=-5, yadjust=70, postshift=52},
	[193]={u=828 , v=0  , w=890 , h=73 , preshift=-5, yadjust=70, postshift=52},
	[194]={u=700 , v=0  , w=762 , h=73 , preshift=-5, yadjust=70, postshift=52},
	[195]={u=764 , v=0  , w=826 , h=73 , preshift=-5, yadjust=70, postshift=52},
	[196]={u=1448, v=0  , w=1510, h=71 , preshift=-5, yadjust=68, postshift=52},
	[197]={u=248 , v=0  , w=311 , h=75 , preshift=-5, yadjust=72, postshift=52},
	[198]={u=1386, v=74 , w=1464, h=133, preshift=-5, yadjust=56, postshift=71},
	[199]={u=1392, v=0  , w=1446, h=72 , preshift=-2, yadjust=56, postshift=49},
	[200]={u=1187, v=0  , w=1241, h=73 , preshift=-1, yadjust=70, postshift=50},
	[201]={u=1075, v=0  , w=1129, h=73 , preshift=-1, yadjust=70, postshift=50},
	[202]={u=1131, v=0  , w=1185, h=73 , preshift=-1, yadjust=70, postshift=50},
	[203]={u=1637, v=0  , w=1691, h=71 , preshift=-1, yadjust=68, postshift=50},
	[204]={u=1275, v=0  , w=1302, h=73 , preshift=-7, yadjust=70, postshift=20},
	[205]={u=1304, v=0  , w=1330, h=73 , preshift=0 , yadjust=70, postshift=20},
	[206]={u=1243, v=0  , w=1273, h=73 , preshift=-5, yadjust=70, postshift=20},
	[207]={u=1693, v=0  , w=1727, h=71 , preshift=-7, yadjust=68, postshift=20},
	[208]={u=1545, v=73 , w=1615, h=132, preshift=-4, yadjust=56, postshift=64},
	[209]={u=1332, v=0  , w=1390, h=72 , preshift=-1, yadjust=69, postshift=56},
	[210]={u=572 , v=0  , w=634 , h=73 , preshift=-2, yadjust=70, postshift=57},
	[211]={u=508 , v=0  , w=570 , h=73 , preshift=-2, yadjust=70, postshift=57},
	[212]={u=444 , v=0  , w=506 , h=73 , preshift=-2, yadjust=70, postshift=57},
	[213]={u=380 , v=0  , w=442 , h=73 , preshift=-2, yadjust=70, postshift=57},
	[214]={u=1512, v=0  , w=1574, h=71 , preshift=-2, yadjust=68, postshift=57},
	[215]={u=44  , v=272, w=87  , h=310, preshift=-4, yadjust=45, postshift=35},
	[216]={u=1948, v=70 , w=2010, h=129, preshift=-2, yadjust=56, postshift=55},
	[217]={u=953 , v=0  , w=1012, h=73 , preshift=-1, yadjust=70, postshift=56},
	[218]={u=892 , v=0  , w=951 , h=73 , preshift=-1, yadjust=70, postshift=56},
	[219]={u=1014, v=0  , w=1073, h=73 , preshift=-1, yadjust=70, postshift=56},
	[220]={u=1576, v=0  , w=1635, h=71 , preshift=-1, yadjust=68, postshift=56},
	[221]={u=313 , v=0  , w=378 , h=73 , preshift=-7, yadjust=70, postshift=51},
	[222]={u=1913, v=0  , w=1968, h=68 , preshift=-1, yadjust=65, postshift=50},
	[223]={u=290 , v=211, w=382 , h=264, preshift=-4, yadjust=50, postshift=84},
	[224]={u=180 , v=81 , w=238 , h=148, preshift=-5, yadjust=64, postshift=47},
	[225]={u=60  , v=81 , w=118 , h=148, preshift=-5, yadjust=64, postshift=47},
	[226]={u=0   , v=81 , w=58  , h=148, preshift=-5, yadjust=64, postshift=47},
	[227]={u=1970, v=0  , w=2028, h=67 , preshift=-5, yadjust=64, postshift=47},
	[228]={u=895 , v=75 , w=953 , h=141, preshift=-5, yadjust=63, postshift=47},
	[229]={u=1729, v=0  , w=1787, h=69 , preshift=-5, yadjust=66, postshift=47},
	[230]={u=384 , v=205, w=457 , h=258, preshift=-5, yadjust=50, postshift=66},
	[231]={u=1183, v=75 , w=1234, h=141, preshift=-2, yadjust=50, postshift=46},
	[232]={u=752 , v=75 , w=804 , h=142, preshift=-1, yadjust=64, postshift=48},
	[233]={u=698 , v=75 , w=750 , h=142, preshift=-1, yadjust=64, postshift=48},
	[234]={u=644 , v=75 , w=696 , h=142, preshift=-1, yadjust=64, postshift=48},
	[235]={u=1129, v=75 , w=1181, h=141, preshift=-1, yadjust=63, postshift=48},
	[236]={u=838 , v=75 , w=865 , h=142, preshift=-7, yadjust=64, postshift=20},
	[237]={u=867 , v=75 , w=893 , h=142, preshift=0 , yadjust=64, postshift=20},
	[238]={u=806 , v=75 , w=836 , h=142, preshift=-5, yadjust=64, postshift=20},
	[239]={u=1236, v=75 , w=1270, h=141, preshift=-7, yadjust=63, postshift=20},
	[240]={u=532 , v=205, w=599 , h=258, preshift=-4, yadjust=50, postshift=60},
	[241]={u=1853, v=0  , w=1911, h=68 , preshift=-1, yadjust=64, postshift=56},
	[242]={u=240 , v=81 , w=298 , h=148, preshift=-2, yadjust=64, postshift=53},
	[243]={u=300 , v=77 , w=358 , h=144, preshift=-2, yadjust=64, postshift=53},
	[244]={u=360 , v=75 , w=418 , h=142, preshift=-2, yadjust=64, postshift=53},
	[245]={u=120 , v=81 , w=178 , h=148, preshift=-2, yadjust=64, postshift=53},
	[246]={u=955 , v=75 , w=1013, h=141, preshift=-2, yadjust=63, postshift=53},
	[247]={u=1949, v=192, w=1987, h=235, preshift=-4, yadjust=48, postshift=29},
	[248]={u=230 , v=211, w=288 , h=266, preshift=-2, yadjust=51, postshift=53},
	[249]={u=479 , v=75 , w=532 , h=142, preshift=-1, yadjust=64, postshift=51},
	[250]={u=534 , v=75 , w=587 , h=142, preshift=-1, yadjust=64, postshift=51},
	[251]={u=589 , v=75 , w=642 , h=142, preshift=-1, yadjust=64, postshift=51},
	[252]={u=1074, v=75 , w=1127, h=141, preshift=-1, yadjust=63, postshift=51},
	[253]={u=420 , v=75 , w=477 , h=142, preshift=-7, yadjust=64, postshift=43},
	[254]={u=1332, v=74 , w=1384, h=136, preshift=-1, yadjust=59, postshift=48},
	[255]={u=1015, v=75 , w=1072, h=141, preshift=-7, yadjust=63, postshift=43},
}


--[[
function mab.font:load(filename)
	for l in io.lines(filename) do

	if l==2
		local lx, ly, lr = l:match "%d"
		if lx or ly or lr then
			mab.font[]={ x = lx, y = ly, r = lr }
			print(lx)
		end
	end
end

mab.font:load("R:\\Juegos\\swconquest\\modules\\swconquest\\Module Data\\FONT_DATA.XML")
]]

  --
 -- Helper functions
--

function mab.font:print(phrase,x,y,s)
	x=x or 50
	y=y or 40
	s=s or 1--130
	phrase:gsub(".",
		function(c)
			ls = mab.font:char(c,x,y,s)
			print(x)
			x = x + ls
		end)

end

function mab.font:char(c,x,y,s)
	print(c.." ->"..string.byte(c))
	c=string.byte(c)

	gl.glBegin(gl.GL_QUADS)
	
	local u= mab.font[c].u/mab.font.width
	local v= 1-(mab.font[c].v/mab.font.height)
	local w= mab.font[c].w/mab.font.width
	local h= 1-(mab.font[c].h/mab.font.height)
	
	--derivate the correct aspect ratio
	local sx, sy = mab.font[c].w-mab.font[c].u, mab.font[c].h-mab.font[c].v --width
	
	--horizontal adjustments
	local x = x+mab.font[c].preshift
	--vertical adjustments
	local yadj = mab.font[c].yadjust-sy
	
	--1
		gl.glTexCoord2d(u,h)--(0,0)
		gl.glVertex2i(x, 0+y+yadj)
	--2
		gl.glTexCoord2d(w,h)--(1,0)
		gl.glVertex2i(sx+x, 0+y+yadj)
	--3
		gl.glTexCoord2d(w,v)--(1,1)
		gl.glVertex2i(sx+x, y+sy+yadj)
	--4
		gl.glTexCoord2d(u,v)--(0,1)
		gl.glVertex2i(x, y+sy+yadj)
	--    v
	--   4|      3
	-- u--+-----+
	--	  |     |
	--	  |     |
	--    +-----+--w
	--   1      |2
	--          h
	gl.glEnd()
	return sx-(sx-mab.font[c].postshift)
end