-- Filename: DB_Copy_team.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Copy_team", package.seeall)

keys = {
	"id", "name", "des", "level", "winDes", "rewardDes", "model", "img", "copyType", "background", "teamLimit", "maxWin", "min", "max", "levelLimit", "armyNum", "strongHold", "exp", "silver", "soul", "items", "stamina", "needPassCopy", "needPassTeamCopy", "postfTeamCopy", "thumbnail", 
}

Copy_team = {
	id_400001 = {400001, "测试副本1", "我是描述1", 20, "击败全部部队", nil, nil, "1.png", 1, nil, "1,2,3", 9, 1, 3, 20, 3, "200005", nil, 1000, 100, nil, 5, 2, nil, 400002, "copy1.jpg", },
	id_400002 = {400002, "测试副本2", "我是描述2", 30, "击败全部部队", nil, nil, "2.png", 1, nil, "1,2,3", 9, 1, 3, 30, 3, "200006", nil, 2000, 200, nil, 5, 3, 400001, 400003, "copy2.jpg", },
	id_400003 = {400003, "测试副本3", "我是描述3", 40, "击败全部部队", nil, nil, "3.png", 1, nil, "1,2,3", 9, 1, 3, 40, 3, "200007", nil, 3000, 300, nil, 5, 4, 400002, 400004, "copy3.jpg", },
	id_400004 = {400004, "测试副本4", "我是描述4", 50, "击败全部部队", nil, nil, "4.png", 1, nil, "1,2,3", 9, 1, 3, 50, 3, "200008", nil, 4000, 400, nil, 5, 5, 400003, 400005, "copy2.jpg", },
	id_400005 = {400005, "测试副本5", "我是描述5", 60, "击败全部部队", nil, nil, "5.png", 1, nil, "1,2,3", 9, 1, 3, 60, 3, "200009", nil, 5000, 500, nil, 5, 6, 400004, nil, "copy5.jpg", },
	id_400101 = {400101, "我是描述1", "我是描述1", nil, "击败全部部队", nil, nil, "1.png", 1, "zuduifuben.jpg", "1,3", 5, 2, 3, 1, 9, "150001", nil, 1000, 0, nil, 5, 7, nil, nil, "copy5.jpg", },
	id_400102 = {400102, "下邳军团", "我是描述1", nil, "击败全部部队", nil, nil, "1.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 20, 5, "150002", nil, 5000, 0, nil, 0, 10, nil, 400103, "copy5.jpg", },
	id_400103 = {400103, "寿春军团", "我是描述2", nil, "击败全部部队", nil, nil, "2.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 25, 6, "150003", nil, 7500, 0, nil, 0, 12, 400102, 400104, "copy6.jpg", },
	id_400104 = {400104, "魔阵军团", "我是描述3", nil, "击败全部部队", nil, nil, "3.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 30, 6, "150004", nil, 10000, 0, nil, 0, 14, 400103, 400105, "copy7.jpg", },
	id_400105 = {400105, "白马军团", "我是描述4", nil, "击败全部部队", nil, nil, "4.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 35, 6, "150005", nil, 12500, 0, nil, 0, 16, 400104, 400106, "copy8.jpg", },
	id_400106 = {400106, "千里军团", "我是描述5", nil, "击败全部部队", nil, nil, "5.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 40, 6, "150006", nil, 15000, 0, nil, 0, 18, 400105, 400107, "copy9.jpg", },
	id_400107 = {400107, "官渡军团", "我是描述6", nil, "击败全部部队", nil, nil, "6.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 42, 6, "150007", nil, 17500, 0, nil, 0, 20, 400106, 400108, "copy10.jpg", },
	id_400108 = {400108, "荆州军团一", "我是描述7", nil, "击败全部部队", nil, nil, "7.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 44, 6, "150008", nil, 20000, 0, nil, 0, 21, 400107, 400109, "copy11.jpg", },
	id_400109 = {400109, "荆州军团二", "我是描述8", nil, "击败全部部队", nil, nil, "8.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 46, 10, "150009", nil, 22500, 0, nil, 0, 23, 400108, 400110, "copy11.jpg", },
	id_400110 = {400110, "江东军团一", "我是描述9", nil, "击败全部部队", nil, nil, "9.png", 1, "zuduifuben.jpg", "1,3", 4, 2, 2, 48, 6, "150010", nil, 25000, 0, nil, 0, 24, 400109, 400111, "copy12.jpg", },
	id_400111 = {400111, "江东军团二", "我是描述10", nil, "击败全部部队", nil, nil, "10.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 50, 10, "150011", nil, 27500, 0, nil, 0, 26, 400110, 400112, "copy12.jpg", },
	id_400112 = {400112, "江州魔阵军团一", "我是描述11", nil, "击败全部部队", nil, nil, "11.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 52, 10, "150012", nil, 30000, 0, nil, 0, 27, 400111, 400113, "tcopy13.jpg", },
	id_400113 = {400113, "江州魔阵军团二", "我是描述12", nil, "击败全部部队", nil, nil, "12.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 54, 10, "150013", nil, 32500, 0, nil, 0, 28, 400112, 400114, "tcopy14.jpg", },
	id_400114 = {400114, "江州魔阵军团三", "我是描述13", nil, "击败全部部队", nil, nil, "13.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 56, 10, "150014", nil, 35000, 0, nil, 0, 29, 400113, 400115, "copy13.jpg", },
	id_400115 = {400115, "新野漉战军团一", "我是描述13", nil, "击败全部部队", nil, nil, "14.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 58, 10, "150015", nil, 37500, 0, nil, 0, 30, 400114, 400116, "tcopy15.png", },
	id_400116 = {400116, "新野漉战军团二", "我是描述13", nil, "击败全部部队", nil, nil, "15.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 60, 10, "150016", nil, 40000, 0, nil, 0, 31, 400115, 400117, "tcopy16.png", },
	id_400117 = {400117, "新野漉战军团三", "我是描述13", nil, "击败全部部队", nil, nil, "16.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 62, 10, "150017", nil, 42500, 0, nil, 0, 32, 400116, 400118, "tcopy17.png", },
	id_400118 = {400118, "火烧博望坡一", "我是描述11", nil, "击败全部部队", nil, nil, "17.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 64, 10, "150018", nil, 45000, 0, nil, 0, 33, 400117, 400119, "tcopy18.jpg", },
	id_400119 = {400119, "火烧博望坡二", "我是描述12", nil, "击败全部部队", nil, nil, "18.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 66, 10, "150019", nil, 47500, 0, nil, 0, 34, 400118, 400120, "tcopy19.jpg", },
	id_400120 = {400120, "火烧博望坡三", "我是描述13", nil, "击败全部部队", nil, nil, "19.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 68, 10, "150020", nil, 50000, 0, nil, 0, 35, 400119, 400121, "tcopy20.jpg", },
	id_400121 = {400121, "荆州献曹一", "我是描述13", nil, "击败全部部队", nil, nil, "20.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 70, 10, "150021", nil, 52500, 0, nil, 0, 36, 400120, 400122, "tcopy21.jpg", },
	id_400122 = {400122, "荆州献曹二", "我是描述13", nil, "击败全部部队", nil, nil, "21.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 72, 10, "150022", nil, 55000, 0, nil, 0, 37, 400121, 400123, "tcopy22.jpg", },
	id_400123 = {400123, "荆州献曹三", "我是描述13", nil, "击败全部部队", nil, nil, "22.png", 1, "zuduifuben.jpg", "1,3", 4, 3, 3, 74, 10, "150023", nil, 57500, 0, nil, 0, 38, 400122, nil, "tcopy23.jpg", },
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
	local id_data = Copy_team["id_" .. key_id]
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
	for k, v in pairs(Copy_team) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Copy_team"] = nil
	package.loaded["DB_Copy_team"] = nil
	package.loaded["db/DB_Copy_team"] = nil
end

