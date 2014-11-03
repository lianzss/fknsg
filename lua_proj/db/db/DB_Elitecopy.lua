-- Filename: DB_Elitecopy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Elitecopy", package.seeall)

keys = {
	"id", "name", "desc", "image", "pre_copyid", "coins", "general_soul", "exp", "energy", "rewards", "baseids", "next_eliteid", "thumbnail", 
}

Elitecopy = {
	id_200001 = {200001, "黄巾之乱精英", nil, "name_copy1.png", 1, nil, nil, nil, 0, "1111,1118,61", 200001, 200002, "copy1.jpg", },
	id_200002 = {200002, "虎牢关精英", nil, "name_copy2.png", 4, nil, nil, nil, 0, "1120,61", 200002, 200003, "copy2.jpg", },
	id_200003 = {200003, "长安董卓精英", nil, "name_copy3.png", 6, nil, nil, nil, 0, "1130,61", 200003, 200004, "copy3.jpg", },
	id_200004 = {200004, "徐州精英", nil, "name_copy4.png", 8, nil, nil, nil, 0, "1210,61", 200004, 200005, "copy2.jpg", },
	id_200005 = {200005, "下邳精英", nil, "name_copy5.png", 10, nil, nil, nil, 0, "1220,61", 200005, 200006, "copy5.jpg", },
	id_200006 = {200006, "寿春精英", nil, "name_copy6.png", 12, nil, nil, nil, 0, "1230,61", 200006, 200007, "copy6.jpg", },
	id_200007 = {200007, "魔阵精英", nil, "name_copy7.png", 14, nil, nil, nil, 0, "1240,61", 200007, 200008, "copy7.jpg", },
	id_200008 = {200008, "白马城精英", nil, "name_copy8.png", 16, nil, nil, nil, 0, "1250,61", 200008, 200009, "copy8.jpg", },
	id_200009 = {200009, "千里走单骑精英", nil, "name_copy9.png", 18, nil, nil, nil, 0, "1316,61", 200009, 200010, "copy9.jpg", },
	id_200010 = {200010, "官渡之战精英", nil, "name_copy10.png", 20, nil, nil, nil, 0, "1317,61", 200010, 200011, "copy10.jpg", },
	id_200011 = {200011, "荆州之战精英", nil, "name_copy11.png", 23, nil, nil, nil, 0, nil, 200011, 200012, "copy11.jpg", },
	id_200012 = {200012, "江东破众将精英", nil, "name_copy12.png", 26, nil, nil, nil, 0, nil, 200012, 200013, "copy12.jpg", },
	id_200013 = {200013, "江州魔阵精英", nil, "name_copy13.png", 29, nil, nil, nil, 0, nil, 200013, 200014, "copy13.jpg", },
	id_200014 = {200014, "新野漉战精英", nil, "name_copy14.png", 32, nil, nil, nil, 0, nil, 200014, 200015, "copy14.jpg", },
	id_200015 = {200015, "火烧博望坡精英", nil, "name_copy15.png", 35, nil, nil, nil, 0, nil, 200015, 200016, "copy15.jpg", },
	id_200016 = {200016, "荆州献曹精英", nil, "name_copy16.png", 38, nil, nil, nil, 0, nil, 200016, 200017, "copy16.jpg", },
	id_200017 = {200017, "火烧新野精英", nil, "name_copy17.png", 41, nil, nil, nil, 0, nil, 200017, 200018, "copy17.jpg", },
	id_200018 = {200018, "樊城掩护精英", nil, "name_copy18.png", 44, nil, nil, nil, 0, nil, 200018, 200019, "copy18.jpg", },
	id_200019 = {200019, "襄阳之战精英", nil, "name_copy19.png", 47, nil, nil, nil, 0, nil, 200019, 200020, "copy19.jpg", },
	id_200020 = {200020, "长坂坡之战精英", nil, "name_copy20.png", 50, nil, nil, nil, 0, nil, 200020, 200021, "copy20.jpg", },
	id_200021 = {200021, "汉津之战精英", nil, "name_copy21.png", 53, nil, nil, nil, 0, nil, 200021, nil, "copy21.jpg", },
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
	local id_data = Elitecopy["id_" .. key_id]
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
	for k, v in pairs(Elitecopy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Elitecopy"] = nil
	package.loaded["DB_Elitecopy"] = nil
	package.loaded["db/DB_Elitecopy"] = nil
end

