-- Filename: DB_Share.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Share", package.seeall)

keys = {
	"id", "name", "weiboContent", "weiboImage", "weixinUrl", "weixinTitle", "weixinContent", "wenxinIcon", "wenxinImage", 
}

Share = {
	id_1001 = {1001, "91_ios", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://app.91.com/Soft/Detail.aspx?Platform=iPhone&f_id=1856420", "《放开那三国》火爆内测狂撒现金礼", nil, "91.png", nil, },
	id_1002 = {1002, "91_android", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1003 = {1003, "pp", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://www.25pp.com/ipad/game/info_1088347.html", "《放开那三国》火爆内测狂撒现金礼", nil, "pp.png", nil, },
	id_1004 = {1004, "qiho360", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1005 = {1005, "uc", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1006 = {1006, "baidu", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1007 = {1007, "xiaomi", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1008 = {1008, "dangleanzhuo", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1009 = {1009, "wandoujia", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1010 = {1010, "anzhi", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1011 = {1011, "37wan", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1012 = {1012, "jifeng", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1013 = {1013, "tbtios", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://app.tongbu.com/10003971_fangkainasanguo.html", "《放开那三国》火爆内测狂撒现金礼", nil, "tbt.png", nil, },
	id_1014 = {1014, "app", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→https://itunes.apple.com/us/app/fang-kai-na-san-guo/id680465449?ls=1&mt=8", "fenxiangtu.jpg", "https://itunes.apple.com/us/app/fang-kai-na-san-guo/id680465449?ls=1&mt=8", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_9000 = {9000, "线下", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://sg.zuiyouxi.com", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1015 = {1015, "itools", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜14岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://www.itools.cn/details/10087/", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1016 = {1016, "dangleios", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜15岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://ng.d.cn/fangkainasanguo/", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1017 = {1017, "pingguoyuan", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜16岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", "http://www.app111.com/info/51278/", "《放开那三国》火爆内测狂撒现金礼", nil, "tubiao.png", nil, },
	id_1018 = {1018, "PP2", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", nil, nil, nil, "tubiao.png", "fenxiangtu2.jpg", },
	id_1019 = {1019, "快用", "#我要上三国#刘备出征的日子尚香的房门为何夜夜被敲？周瑜13岁官拜水军都督究竟与孙权是何关系？蔡文姬北国侍奉蛮夷学会了什么姿势？问世间情为何物，直教人狂点屏幕。《放开那三国》带你探寻历史背后的真相→_→http://sg.zuiyouxi.com", "fenxiangtu.jpg", nil, nil, nil, "tubiao.png", "fenxiangtu2.jpg", },
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
	local id_data = Share["id_" .. key_id]
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
	for k, v in pairs(Share) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Share"] = nil
	package.loaded["DB_Share"] = nil
	package.loaded["db/DB_Share"] = nil
end

