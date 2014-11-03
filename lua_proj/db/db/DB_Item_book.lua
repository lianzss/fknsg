-- Filename: DB_Item_book.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_book", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "numProperties", "property1", "value1", "property2", "value2", "property3", "value3", "property4", "value4", "property5", "value5", "property6", "value6", "property7", "value7", "property8", "value8", "property9", "value9", "property10", "value10", "fixedSkills", "canDeleted", "use_costBely", "use_costGold", "use_needItem", "use_needNum", "lv_addValue_1", "lv_addValue_2", "lv_addValue_3", "lv_addValue_4", "lv_addValue_5", "lv_addValue_6", "lv_addValue_7", "lv_addValue_8", "lv_addValue_9", "lv_addValue_10", "can_equipSlot", "book_type", "up_skills", "exp_eat", "canUp", "up_id", "max_lv", "info_1", "info_2", "info_3", "info_4", "info_5", "info_6", "info_7", "info_8", "info_9", "info_10", 
}

Item_book = {
	id_200001 = {200001, "橡胶果实", "橡胶果实oye！增加生命100点，力量10点。", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 100000, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200002 = {200002, "敏捷果实", "敏捷果实oye！增加生命100点，敏捷10点。", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200003 = {200003, "智慧果实", "智慧果实oye！增加生命100点，敏捷10点。", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 100000, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200004 = {200004, "大炮果实", "可以拥有一个船战技能-炮击1", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200005 = {200005, "生命果实1", "生命加1000", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, 200000, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200006 = {200006, "生命果实2", "增加生命值100%", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200007 = {200007, "全体攻击果实", "生命加1000", "bingshu.png", "bingshu.png", 2, 1, 1, 1, 1, 1, nil, 1, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200008 = {200008, "人人果实", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "bingshu.png", "bingshu.png", 2, 4, nil, nil, nil, 1, nil, nil, 1, 5, 500, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0, nil, nil, nil, nil, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 1, 1000004, 10, "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", "[人人果实]相当稀有的恶魔果实，人吃了只会变成旱鸭子，在动物吃下果实的情况下，能力者会获得理解人类语言的能力。", },
	id_200009 = {200009, "花花果实", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有15%概率眩晕目标，且不增加目标怒气。", "bingshu.png", "bingshu.png", 2, 5, nil, nil, nil, 1, nil, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "100010|20000010|20000020|20000030|20000040|20000050|20000060|20000070|20000080|20000090|20000100", 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 1, 1000005, 10, "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有16%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有17%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有18%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有19%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有20%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有21%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有22%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有23%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有24%概率眩晕目标，且不增加目标怒气。", "[花花果实]可以在任何地方（包括其他人身上或地上）开花，也可以因开花的数量变换成各种型态。普通攻击有25%概率眩晕目标，且不增加目标怒气。", },
	id_200010 = {200010, "橡皮果实", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有20%概率回复怒气25点。", "bingshu.png", "bingshu.png", 2, 6, nil, nil, nil, 1, nil, nil, 2, 3, 400, 1, 250, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "100020", 0, nil, nil, nil, nil, 40, 50, nil, nil, nil, nil, nil, nil, nil, nil, "1,2,3", nil, nil, 0, 1, 1000006, 10, "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有21%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有22%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有23%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有24%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有25%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有26%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有27%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有28%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有29%概率回复怒气25点。", "[橡皮果实]身体变成橡胶体质，具有绝佳的弹性与延展性，可以抵挡绝大多数的物理攻击，不怕子弹，对雷电攻击具绝缘性。攻击有30%概率回复怒气25点。", },
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
	local id_data = Item_book["id_" .. key_id]
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
	for k, v in pairs(Item_book) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_book"] = nil
	package.loaded["DB_Item_book"] = nil
	package.loaded["db/DB_Item_book"] = nil
end

