-- Filename: DB_Item_hero_fragment.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_hero_fragment", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "need_part_num", "aimItem", "dropStrongHold", 
}

Item_hero_fragment = {
	id_410001 = {410001, "张辽武魂", "集齐30个可以招募张辽", "head_zhangliao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10001, nil, },
	id_410002 = {410002, "司马懿武魂", "集齐30个可以招募司马懿", "head_simayi.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10002, nil, },
	id_410003 = {410003, "郭嘉武魂", "集齐30个可以招募郭嘉", "head_guojia.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10003, nil, },
	id_410004 = {410004, "曹操武魂", "集齐30个可以招募曹操", "head_caocao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10004, nil, },
	id_410005 = {410005, "夏侯惇武魂", "集齐30个可以招募夏侯惇", "head_xiahoudun.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10005, nil, },
	id_410006 = {410006, "关羽武魂", "集齐30个可以招募关羽", "head_guanyu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10006, nil, },
	id_410007 = {410007, "张飞武魂", "集齐30个可以招募张飞", "head_zhangfei.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10007, nil, },
	id_410008 = {410008, "赵云武魂", "集齐30个可以招募赵云", "head_zhaoyun.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10008, nil, },
	id_410009 = {410009, "诸葛亮武魂", "集齐30个可以招募诸葛亮", "head_zhugeliang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10009, nil, },
	id_410010 = {410010, "马超武魂", "集齐30个可以招募马超", "head_machao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10010, nil, },
	id_410011 = {410011, "周瑜武魂", "集齐30个可以招募周瑜", "head_zhouyu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10011, nil, },
	id_410012 = {410012, "陆逊武魂", "集齐30个可以招募陆逊", "head_luxun.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10012, nil, },
	id_410013 = {410013, "甘宁武魂", "集齐30个可以招募甘宁", "head_ganning.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10013, nil, },
	id_410014 = {410014, "孙策武魂", "集齐30个可以招募孙策", "head_sunce.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10014, nil, },
	id_410015 = {410015, "吕蒙武魂", "集齐30个可以招募吕蒙", "head_lvmeng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10015, nil, },
	id_410016 = {410016, "吕布武魂", "集齐30个可以招募吕布", "head_lvbu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10016, nil, },
	id_410017 = {410017, "贾诩武魂", "集齐30个可以招募贾诩", "head_jiaxu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10017, nil, },
	id_410018 = {410018, "貂蝉武魂", "集齐30个可以招募貂蝉", "head_diaochan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10018, nil, },
	id_410019 = {410019, "华佗武魂", "集齐30个可以招募华佗", "head_huatuo.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10019, nil, },
	id_410020 = {410020, "左慈武魂", "集齐30个可以招募左慈", "head_zuoci.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10020, nil, },
	id_410021 = {410021, "于吉武魂", "集齐30个可以招募于吉", "head_yuji.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10021, nil, },
	id_410022 = {410022, "典韦武魂", "集齐30个可以招募典韦", "head_dianwei.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10022, "27010,47010", },
	id_410023 = {410023, "徐晃武魂", "集齐30个可以招募徐晃", "head_xuhuang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10023, "22010,53010", },
	id_410024 = {410024, "曹仁武魂", "集齐30个可以招募曹仁", "head_caoren.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10024, "29010,49010", },
	id_410025 = {410025, "许褚武魂", "集齐30个可以招募许褚", "head_xuchu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10025, "42010", },
	id_410026 = {410026, "甄姬武魂", "集齐30个可以招募甄姬", "head_zhenji.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10026, "44010", },
	id_410027 = {410027, "张郃武魂", "集齐30个可以招募张郃", "head_zhanghe.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10027, "20009", },
	id_410028 = {410028, "姜维武魂", "集齐30个可以招募姜维", "head_jiangwei.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10028, "33010", },
	id_410029 = {410029, "魏延武魂", "集齐30个可以招募魏延", "head_weiyan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10029, "17010", },
	id_410030 = {410030, "黄忠武魂", "集齐30个可以招募黄忠", "head_huangzhong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10030, "18010,50010", },
	id_410031 = {410031, "徐庶武魂", "集齐30个可以招募徐庶", "head_xushu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10031, "30010", },
	id_410032 = {410032, "刘备武魂", "集齐30个可以招募刘备", "head_liubei.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10032, "32010", },
	id_410033 = {410033, "黄月英武魂", "集齐30个可以招募黄月英", "head_huangyueying.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10033, "46010", },
	id_410034 = {410034, "太史慈武魂", "集齐30个可以招募太史慈", "head_taishici.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10034, "26010", },
	id_410035 = {410035, "孙坚武魂", "集齐30个可以招募孙坚", "head_sunjian.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10035, "14010,37010", },
	id_410036 = {410036, "孙权武魂", "集齐30个可以招募孙权", "head_sunquan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10036, "28010", },
	id_410037 = {410037, "孙尚香武魂", "集齐30个可以招募孙尚香", "head_sunshangxiang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10037, "25010", },
	id_410038 = {410038, "小乔武魂", "集齐30个可以招募小乔", "head_xiaoqiao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10038, "35010,40010", },
	id_410039 = {410039, "大乔武魂", "集齐30个可以招募大乔", "head_daqiao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10039, nil, },
	id_410040 = {410040, "文丑武魂", "集齐30个可以招募文丑", "head_wenchou.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10040, "15010", },
	id_410041 = {410041, "颜良武魂", "集齐30个可以招募颜良", "head_yanliang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10041, "16010,52010", },
	id_410042 = {410042, "张角武魂", "集齐30个可以招募张角", "head_zhangjiao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10042, "2007", },
	id_410043 = {410043, "华雄武魂", "集齐30个可以招募华雄", "head_huaxiong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10043, "3008,34010", },
	id_410044 = {410044, "陈宫武魂", "集齐30个可以招募陈宫", "head_chengong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10044, "8010", },
	id_410045 = {410045, "董卓武魂", "集齐30个可以招募董卓", "head_dongzhuo.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10045, "6010,48010", },
	id_410046 = {410046, "蔡文姬武魂", "集齐30个可以招募蔡文姬", "head_caiwenji.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10046, "43010", },
	id_410047 = {410047, "曹丕武魂", "集齐30个可以招募曹丕", "head_caopei.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10047, "31010", },
	id_410048 = {410048, "孟获武魂", "集齐30个可以招募孟获", "head_menghuo.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10048, nil, },
	id_410049 = {410049, "祝融武魂", "集齐30个可以招募祝融", "head_zhurong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10049, "38010", },
	id_410050 = {410050, "黄盖武魂", "集齐30个可以招募黄盖", "head_huanggai.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10050, "23010", },
	id_410051 = {410051, "鲁肃武魂", "集齐30个可以招募鲁肃", "head_lusu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10051, "21010,51010", },
	id_410052 = {410052, "陈登武魂", "集齐30个可以招募陈登", "head_chendeng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10052, "10010", },
	id_410053 = {410053, "高顺武魂", "集齐30个可以招募高顺", "head_gaoshun.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10053, "4010,5010,9010", },
	id_410054 = {410054, "张春华武魂", "集齐15个可以招募张春华", "head_zhangchunhua.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10054, "37009,51009", },
	id_410055 = {410055, "文聘武魂", "集齐15个可以招募文聘", "head_wenpin.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10055, "30009,46009", },
	id_410056 = {410056, "满宠武魂", "集齐15个可以招募满宠", "head_manchong.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10056, "33009", },
	id_410057 = {410057, "李典武魂", "集齐15个可以招募李典", "head_lidian.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10057, "27009,48009", },
	id_410058 = {410058, "乐进武魂", "集齐30个可以招募乐进", "head_lejin.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10058, "12010,41010", },
	id_410059 = {410059, "许攸武魂", "集齐15个可以招募许攸", "head_xuyou.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10059, "16009", },
	id_410060 = {410060, "于禁武魂", "集齐30个可以招募于禁", "head_yujin.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10060, "7010,36010", },
	id_410061 = {410061, "荀攸武魂", "集齐15个可以招募荀攸", "head_xunyou.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10061, "41009", },
	id_410062 = {410062, "曹洪武魂", "集齐15个可以招募曹洪", "head_caohong.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10062, "28009", },
	id_410063 = {410063, "关银萍武魂", "集齐15个可以招募关银萍", "head_guanyinping.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10063, "32009", },
	id_410064 = {410064, "张星彩武魂", "集齐15个可以招募张星彩", "head_zhangxingcai.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10064, "10009", },
	id_410065 = {410065, "马岱武魂", "集齐15个可以招募马岱", "head_madai.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10065, "29009,52009", },
	id_410066 = {410066, "周仓武魂", "集齐15个可以招募周仓", "head_zhoucang.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10066, "38009,49009", },
	id_410067 = {410067, "关兴武魂", "集齐15个可以招募关兴", "head_guanxing.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10067, "43009", },
	id_410068 = {410068, "关平武魂", "集齐15个可以招募关平", "head_guanping.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10068, "34009", },
	id_410069 = {410069, "张苞武魂", "集齐15个可以招募张苞", "head_zhangbao.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10069, "19009", },
	id_410070 = {410070, "周泰武魂", "集齐30个可以招募周泰", "head_zhoutai.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10070, "13010,39010", },
	id_410071 = {410071, "张昭武魂", "集齐15个可以招募张昭", "head_zhangzhao.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10071, "7009,47009,53009", },
	id_410072 = {410072, "凌统武魂", "集齐15个可以招募凌统", "head_lingtong.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10072, "8009", },
	id_410073 = {410073, "步练师武魂", "集齐15个可以招募步练师", "head_bulianshi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10073, "24009", },
	id_410074 = {410074, "诸葛瑾武魂", "集齐15个可以招募诸葛瑾", "head_zhugejin.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10074, "21009", },
	id_410075 = {410075, "徐盛武魂", "集齐30个可以招募徐盛", "head_xusheng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10075, "11010", },
	id_410076 = {410076, "陆抗武魂", "集齐15个可以招募陆抗", "head_lukang.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10076, "23009", },
	id_410077 = {410077, "程普武魂", "集齐15个可以招募程普", "head_chengpu.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10077, "14009,50009", },
	id_410078 = {410078, "丁原武魂", "集齐15个可以招募丁原", "head_dingyuan.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10078, "4009,45009", },
	id_410079 = {410079, "皇甫嵩武魂", "集齐15个可以招募皇甫嵩", "head_huangfusong.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10079, "3007,22009", },
	id_410080 = {410080, "李儒武魂", "集齐15个可以招募李儒", "head_liru.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10080, "6009,9009", },
	id_410081 = {410081, "纪灵武魂", "集齐15个可以招募纪灵", "head_jiling.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10081, "11009", },
	id_410082 = {410082, "刘表武魂", "集齐15个可以招募刘表", "head_liubiao.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10082, "42009", },
	id_410083 = {410083, "袁绍武魂", "集齐30个可以招募袁绍", "head_yuanshao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10083, "20010,45010", },
	id_410084 = {410084, "袁术武魂", "集齐15个可以招募袁术", "head_yuanshu.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10084, "12009", },
	id_410085 = {410085, "张宝武魂", "集齐15个可以招募张宝", "head_zhangbao_1.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10085, "1006", },
	id_410086 = {410086, "曹昂武魂", "集齐15个可以招募曹昂", "head_caoang.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10086, "36009", },
	id_410087 = {410087, "曹节武魂", "集齐15个可以招募曹节", "head_xinxianying.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10087, nil, },
	id_410088 = {410088, "卞氏武魂", "集齐15个可以招募卞氏", "head_bianshi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10088, "35009", },
	id_410089 = {410089, "王异武魂", "集齐15个可以招募王异", "head_heshi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10089, nil, },
	id_410090 = {410090, "郭氏武魂", "集齐15个可以招募郭氏", "head_guoshi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10090, "40009", },
	id_410091 = {410091, "邹氏武魂", "集齐15个可以招募邹氏", "head_zoushi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10091, "31009", },
	id_410097 = {410097, "夏侯氏武魂", "集齐30个可以招募夏侯氏", "head_xiahoushi.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10097, "19010", },
	id_410098 = {410098, "糜夫人武魂", "集齐15个可以招募糜夫人", "head_mifuren.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10098, "18009", },
	id_410099 = {410099, "蔡氏武魂", "集齐15个可以招募蔡氏", "head_caifuren.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10099, nil, },
	id_410100 = {410100, "大张皇后武魂", "集齐15个可以招募大张皇后", "head_dazhanghuanghou.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10100, nil, },
	id_410101 = {410101, "甘夫人武魂", "集齐15个可以招募甘夫人", "head_ganfuren.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10101, "17009", },
	id_410102 = {410102, "吴国太武魂", "集齐15个可以招募吴国太", "head_wuguotai.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10102, "26009", },
	id_410106 = {410106, "淳于琼武魂", "集齐15个可以招募淳于琼", "head_chunyuqiong.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10106, nil, },
	id_410109 = {410109, "卢植武魂", "集齐15个可以招募卢植", "head_luzhi.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10109, "39009", },
	id_410110 = {410110, "张绣武魂", "集齐15个可以招募张绣", "head_zhangxiu.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10110, "13009", },
	id_410111 = {410111, "何氏武魂", "集齐15个可以招募何氏", "head_wujiang7.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10111, "44009", },
	id_410112 = {410112, "王允武魂", "集齐15个可以招募王允", "head_wangyun.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10112, "5009,25009", },
	id_410113 = {410113, "樊氏武魂", "集齐15个可以招募樊氏", "head_wenguan6.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10113, "15009", },
	id_410118 = {410118, "张燕武魂", "集齐15个可以招募张燕", "head_wujiang4.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10118, "2006", },
	id_410162 = {410162, "凌操武魂", "集齐15个可以招募凌操", "head_wujiang3.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10162, nil, },
	id_410163 = {410163, "邢道荣武魂", "集齐15个可以招募邢道荣", "head_handang.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10163, nil, },
	id_410164 = {410164, "张允武魂", "集齐15个可以招募张允", "head_wenguan3.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10164, nil, },
	id_410165 = {410165, "黄祖武魂", "集齐15个可以招募黄祖", "head_wenguan4.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10165, nil, },
	id_410166 = {410166, "蔡瑁武魂", "集齐15个可以招募蔡瑁", "head_caimao.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10166, nil, },
	id_410167 = {410167, "丁奉武魂", "集齐30个可以招募丁奉", "head_dingfeng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10167, nil, },
	id_410168 = {410168, "潘璋武魂", "集齐30个可以招募潘璋", "head_panzhang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10168, nil, },
	id_410170 = {410170, "孙桓武魂", "集齐15个可以招募孙桓", "head_wujiang2.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10170, nil, },
	id_410172 = {410172, "朱桓武魂", "集齐30个可以招募朱桓", "head_zhuhuan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10172, nil, },
	id_410173 = {410173, "张武武魂", "集齐15个可以招募张武", "head_wujiang5.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10173, nil, },
	id_410175 = {410175, "夏侯渊武魂", "集齐30个可以招募夏侯渊", "head_xiahouyuan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10175, nil, },
	id_410179 = {410179, "法正武魂", "集齐30个可以招募法正", "head_fazheng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10179, "24010", },
	id_410180 = {410180, "蒯良武魂", "集齐15个可以招募蒯良", "head_wenguan1.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10180, nil, },
	id_410181 = {410181, "蒯越武魂", "集齐15个可以招募蒯越", "head_wenguan2.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10181, nil, },
	id_410183 = {410183, "荀彧武魂", "集齐30个可以招募荀彧", "head_xunyu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10183, nil, },
	id_410184 = {410184, "司马昭武魂", "集齐30个可以招募司马昭", "head_simazhao.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10184, nil, },
	id_410185 = {410185, "杨修武魂", "集齐30个可以招募杨修", "head_yangxiu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10185, nil, },
	id_410186 = {410186, "蒋干武魂", "集齐30个可以招募蒋干", "head_jianggan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10186, nil, },
	id_410187 = {410187, "关索武魂", "集齐30个可以招募关索", "head_guansuo.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10187, nil, },
	id_410188 = {410188, "马谡武魂", "集齐30个可以招募马谡", "head_masu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10188, nil, },
	id_410189 = {410189, "费祎武魂", "集齐30个可以招募费祎", "head_feiyi.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10189, nil, },
	id_410190 = {410190, "严颜武魂", "集齐30个可以招募严颜", "head_yanyan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10190, nil, },
	id_410191 = {410191, "马腾武魂", "集齐30个可以招募马腾", "head_mateng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10191, nil, },
	id_410192 = {410192, "诸葛恪武魂", "集齐30个可以招募诸葛恪", "head_zhugeke.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10192, nil, },
	id_410193 = {410193, "蒋钦武魂", "集齐15个可以招募蒋钦", "head_wujiang2.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10193, nil, },
	id_410194 = {410194, "朱治武魂", "集齐15个可以招募朱治", "head_wujiang3.png", "datili.png", 7, 4, 0, nil, nil, 15, nil, nil, 15, 10194, nil, },
	id_410195 = {410195, "左慈武魂", "集齐30个可以招募新手版左慈", "head_zuoci.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10195, nil, },
	id_410196 = {410196, "于吉武魂", "集齐30个可以招募新手版于吉", "head_yuji.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10196, nil, },
	id_410197 = {410197, "公孙瓒武魂", "集齐30个可以招募公孙瓒", "head_gongsunzan.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10197, nil, },
	id_410198 = {410198, "邓艾武魂", "集齐30个可以招募邓艾", "head_dengai.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10198, nil, },
	id_410199 = {410199, "庞统武魂", "集齐30个可以招募庞统", "head_pangtong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10199, nil, },
	id_410200 = {410200, "程昱武魂", "集齐30个可以招募程昱", "head_chengyu.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10200, nil, },
	id_410201 = {410201, "马良武魂", "集齐30个可以招募马良", "head_maliang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10201, nil, },
	id_410202 = {410202, "文鸯武魂", "集齐30个可以招募文鸯", "head_wenyang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10202, nil, },
	id_410203 = {410203, "张仲景武魂", "集齐30个可以招募张仲景", "head_zhangzhongjing.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10203, nil, },
	id_410204 = {410204, "鲍三娘武魂", "集齐30个可以招募鲍三娘", "head_baosanniang.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10204, nil, },
	id_410205 = {410205, "廖化武魂", "集齐30个可以招募廖化", "head_liaohua.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10205, nil, },
	id_410206 = {410206, "刘协武魂", "集齐30个可以招募刘协", "head_liuxie.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10206, nil, },
	id_410207 = {410207, "南华老仙武魂", "集齐30个可以招募南华老仙", "head_nanhualaoxian.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10207, nil, },
	id_410208 = {410208, "水镜先生武魂", "集齐30个可以招募水镜先生", "head_shuijingxiansheng.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10208, nil, },
	id_410209 = {410209, "邓芝武魂", "集齐30个可以招募邓芝", "head_dengzhi.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10209, nil, },
	id_410210 = {410210, "顾雍武魂", "集齐30个可以招募顾雍", "head_guyong.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10210, nil, },
	id_410211 = {410211, "庞德武魂", "集齐30个可以招募庞德", "head_pangde.png", "datili.png", 7, 5, 0, nil, nil, 30, nil, nil, 30, 10211, nil, },
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
	local id_data = Item_hero_fragment["id_" .. key_id]
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
	for k, v in pairs(Item_hero_fragment) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_hero_fragment"] = nil
	package.loaded["DB_Item_hero_fragment"] = nil
	package.loaded["db/DB_Item_hero_fragment"] = nil
end

