-- Filename: DB_ChangeActivity.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_ChangeActivity", package.seeall)

keys = {
	"id", "name", "exchangeMaterialQuantity", "exchangeMaterial1", "exchangeMaterial2", "exchangeMaterial3", "exchangeMaterial4", "exchangeMaterial5", "targetItems", "changeTime", "refreshTime", "conversionFormula", "rewardNormal", "gold", "level", "goldTop", "itemView", "viewName", "tavernId", "mysticalGoodsId", "copymysticalGoodsId", "act_icon1", "act_icon2", "title_bg", "title", "list_bg", "act_bg", 
}

ChangeActivity = {
	id_1 = {1, "中秋兑换", 1, "2|10000|60604|300", nil, nil, nil, nil, "2|10000|30052|1", 1, 000000, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22,1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22", 131001, "20|10", 30, 100, "30052|30062|30601|30801|30802|30701|410018|410026|410046|410033|410038|410039|501010|60015|30003|30013|60017|60016|50403", "中秋兑换", "0,0,131002", "310001,310002,310003,310004,310005,310006,310007,310008,310009,310010,310011,310012,310013,310014,310015,310016,310017,310018,310019,310020,310021,310022,310023,310024,310025,310026,310027,310028,310029,310030,310031,310032,310033,310034,310035,310036,310037,310038,310039,310040,310041,310042,310043,310044,310045,310046,310047,310048,310049,310050,310051,310052,310053,310054,310055,310056,310057,310058,310059,310060,310061,310062,310063,310064,310065,310066,310067,310068,310069,310070,310071,310072,310073,310074,310075,310076,310077,310078,310079,310080,310081,310082,310083,310084,310085,310086,310087,310088,310089,310090,310091,310092,310093,310094,310095,310096,310097,310098,310099,310100,310101,310102,310103,310104,310105,310106,310107,310108,310109,310110,310111,310112,310113,310114,310115,310116,310117,310118,310119,310120,310121,310122,310123,310124,310125,310126,310127,310128,310129,310130,310131,310132,310133,310134,310135,310136,310137,310138,310139,310140,310141,310142,310143,310144,310145,310146,310147,310148,310149,310150,310151,310152,310153,310154,310155,310156,310157,310158,310159,310160,310161,310162,310163,310164,310165,310166,310167,310168,310169,310170,310171,310172,310173,310174,310175,310176,310177,310178,310179,310180,310181,310182,310183,310184,310185,310186,310187,310188,310189,310190,310191,310192,310193,310194,310195,310196,310197,310198,310199,310200", "110001,110002,110003,110004,110005,110006,110007,110008,110009,110010,110011,110012,110013,110014,110015,110016,110017,110018,110019,110020,110021,110022,110023,110024,110025,110026,110027,110028,110029,110030,110031,110032,110033,110034,110035,110036,110037,110038,110039,110040", "change_qi_n.png", "change_qi_h.png", "title_bg_qi.png", "title_qi.png", "list_bg.png", nil, },
	id_2 = {2, "中秋兑换", 1, "2|10000|60604|300", nil, nil, nil, nil, "2|10000|30062|1", 1, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, "中秋兑换", 1, "2|10000|60604|50", nil, nil, nil, nil, "2|10000|30601|1", 5, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, "中秋兑换", 1, "2|10000|60604|15", nil, nil, nil, nil, "2|10000|30801|1", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, "中秋兑换", 1, "2|10000|60604|15", nil, nil, nil, nil, "2|10000|30802|1", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, "中秋兑换", 1, "2|10000|60604|3", nil, nil, nil, nil, "2|10000|30701|1", 25, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, "中秋兑换", 1, "2|10000|60604|200", nil, nil, nil, nil, "2|10000|410018|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_8 = {8, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|410026|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_9 = {9, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|410046|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10 = {10, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|410033|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_11 = {11, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|410038|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_12 = {12, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|410039|30", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_13 = {13, "中秋兑换", 1, "2|10000|60604|100", nil, nil, nil, nil, "2|10000|501010|1", 2, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_14 = {14, "中秋兑换", 1, "2|10000|60604|40", nil, nil, nil, nil, "2|10000|60015|1", 5, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_15 = {15, "中秋兑换", 1, "2|10000|60604|10", nil, nil, nil, nil, "2|10000|30003|1", 15, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_16 = {16, "中秋兑换", 1, "2|10000|60604|5", nil, nil, nil, nil, "2|10000|30013|1", 15, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_17 = {17, "中秋兑换", 1, "2|10000|60604|10", nil, nil, nil, nil, "2|10000|60017|1", 99, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_18 = {18, "中秋兑换", 1, "2|10000|60604|8", nil, nil, nil, nil, "2|10000|60016|1", 5, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_19 = {19, "中秋兑换", 1, "2|10000|60604|5", nil, nil, nil, nil, "2|10000|50403|1", 10, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_20 = {20, "中秋兑换", 1, "2|10000|60601|1", nil, nil, nil, nil, "2|10000|60604|6", 999, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_21 = {21, "中秋兑换", 1, "2|10000|60602|1", nil, nil, nil, nil, "2|10000|60604|2", 999, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_22 = {22, "中秋兑换", 1, "2|10000|60603|3", nil, nil, nil, nil, "2|10000|60604|1", 999, 000000, nil, nil, "20|10", nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = ChangeActivity["id_" .. key_id]
	if id_data == nil then
		print("don't find data by id " .. key_id)
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(ChangeActivity) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_ChangeActivity"] = nil
	package.loaded["DB_ChangeActivity"] = nil
	package.loaded["db/DB_ChangeActivity"] = nil
end

