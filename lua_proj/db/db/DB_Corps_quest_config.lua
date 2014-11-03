-- Filename: DB_Corps_quest_config.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Corps_quest_config", package.seeall)

keys = {
	"id", "questMaxNum", "dropCd", "refreshPay", "addPay", "siteProbability", "legionTaskExp", "levelRatio", "hallLv", "userLv", 
}

Corps_quest_config = {
	id_1 = {1, 5, 0, 10, "0,10", "1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|1020|1021|1022|1023|1024|1025|1026|1027|1028|1029|1030|1031|1031|1032|1033|1034|1035|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|2010|2011|2012|2013|2014|2015|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|4020|4021|4022|4023|4024|4025|4026|4027|4028|4029|4030|4031|4032|4033|4034|4035|4036|4037|4038|4039|4040|4040|4041|4042|4043|4044|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|6000|6001|6002|6003|6004|6005|6006|6007|6008|6009|6010|6011|6012|6013|6014|6015|6016|6017|6018|6019|4045|4046|4047|4048|4049|4050|4051|4052|4053|4054|4055|4056|4057|4058|4059|4060|4061|4062|4063|4064|4065|4066|4067|4068|4069|4070|4071|4072|4073|4074|4075|4076|4077|4078|4079|4080|4081|4082|4083|4084|4085|4086|4087|4088|4089|4090|4091|4092|4093|4094|4095|4096,1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|1020|1021|1022|1023|1024|1025|1026|1027|1028|1029|1030|1031|1031|1032|1033|1034|1035|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|2010|2011|2012|2013|2014|2015|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|4020|4021|4022|4023|4024|4025|4026|4027|4028|4029|4030|4031|4032|4033|4034|4035|4036|4037|4038|4039|4040|4040|4041|4042|4043|4044|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|6000|6001|6002|6003|6004|6005|6006|6007|6008|6009|6010|6011|6012|6013|6014|6015|6016|6017|6018|6019|4045|4046|4047|4048|4049|4050|4051|4052|4053|4054|4055|4056|4057|4058|4059|4060|4061|4062|4063|4064|4065|4066|4067|4068|4069|4070|4071|4072|4073|4074|4075|4076|4077|4078|4079|4080|4081|4082|4083|4084|4085|4086|4087|4088|4089|4090|4091|4092|4093|4094|4095|4096,1000|1001|1002|1003|1004|1005|1006|1007|1008|1009|1010|1011|1012|1013|1014|1015|1016|1017|1018|1019|1020|1021|1022|1023|1024|1025|1026|1027|1028|1029|1030|1031|1031|1032|1033|1034|1035|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|2010|2011|2012|2013|2014|2015|4000|4001|4002|4003|4004|4005|4006|4007|4008|4009|4010|4011|4012|4013|4014|4015|4016|4017|4018|4019|4020|4021|4022|4023|4024|4025|4026|4027|4028|4029|4030|4031|4032|4033|4034|4035|4036|4037|4038|4039|4040|4040|4041|4042|4043|4044|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|6000|6001|6002|6003|6004|6005|6006|6007|6008|6009|6010|6011|6012|6013|6014|6015|6016|6017|6018|6019|4045|4046|4047|4048|4049|4050|4051|4052|4053|4054|4055|4056|4057|4058|4059|4060|4061|4062|4063|4064|4065|4066|4067|4068|4069|4070|4071|4072|4073|4074|4075|4076|4077|4078|4079|4080|4081|4082|4083|4084|4085|4086|4087|4088|4089|4090|4091|4092|4093|4094|4095|4096", 2005, 100, 10, 50, },
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
	local id_data = Corps_quest_config["id_" .. key_id]
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
	for k, v in pairs(Corps_quest_config) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Corps_quest_config"] = nil
	package.loaded["DB_Corps_quest_config"] = nil
	package.loaded["db/DB_Corps_quest_config"] = nil
end
