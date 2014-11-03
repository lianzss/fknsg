-- Filename: AudioUtil.lua
-- Author: k
-- Date: 2013-08-03
-- Purpose: audio



require "script/utils/extern"
--require "amf3"
-- 主城场景模块声明
module("AudioUtil", package.seeall)

local m_currentBgm       --当前背景音乐

m_isBgmOpen = nil

m_isSoundEffectOpen = nil


local IMG_PATH = "audio/"               -- 图片主路径

local mPreloadEffect = nil

local mPreloadCount = 0

local mMaxPreload = 32

function initAudioInfo()
    if(CCUserDefault:sharedUserDefault():getBoolForKey("isAudioInit")==false)then
        CCUserDefault:sharedUserDefault():setBoolForKey("isAudioInit",true)
        CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",true)
        CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",true)
        CCUserDefault:sharedUserDefault():flush()
        
        m_isBgmOpen = true
        m_isSoundEffectOpen = true
    else
        m_isBgmOpen = CCUserDefault:sharedUserDefault():getBoolForKey("m_isBgmOpen")
        m_isSoundEffectOpen = CCUserDefault:sharedUserDefault():getBoolForKey("m_isSoundEffectOpen")
        
        if(m_isBgmOpen==true)then
            SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1)
        else
            SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
        end
        if(m_isSoundEffectOpen==true)then
            SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
            else
            SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
        end
    end
end
--播放背景音乐
function playBgm(bgm,isLoop)
    bgm = changeToWav(bgm)
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
    
    if(bgm~=m_currentBgm)then
        isLoop = isLoop==nil and true or isLoop
        m_currentBgm = bgm
        --if(m_isBgmOpen==true)then
            SimpleAudioEngine:sharedEngine():playBackgroundMusic(m_currentBgm,isLoop)
        --end
    end
end

--停止背景音乐
function stopBgm()
    
    if(nil==m_isBgmOpen)then
        initAudioInfo()
    end
    m_currentBgm = nil
    SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
end

local function checkEffect(effect)
    if mPreloadEffect == nil then
        mPreloadEffect = {}
    end

    local nowTime = os.time()
    if mPreloadEffect[effect] == nil then
        mPreloadCount = mPreloadCount + 1
    end

    mPreloadEffect[effect] = nowTime
    print("mPreloadCount",mPreloadCount)
    if mPreloadCount < mMaxPreload then
        return
    end
    
    local minTime = nowTime + 1
    local minEffect = nil
    for key, time in pairs(mPreloadEffect) do
        if key ~= effect and time < minTime then
            minTime = time
            minEffect = key
        end
    end

    print("unload " .. minEffect)
    SimpleAudioEngine:sharedEngine():unloadEffect(minEffect)
    mPreloadCount = mPreloadCount - 1
    mPreloadEffect[minEffect] = nil
end

--播放音效
function playEffect(effect,isLoop)
    effect = changeToWav(effect)
    if(nil==m_isSoundEffectOpen)then
        initAudioInfo()
    end
    
    isLoop = isLoop==nil and false or isLoop
    --print("AudioUtil.playEffect effect:",effect)
    
    if(m_isSoundEffectOpen==true)then
        if(file_exists(effect)) then
            checkEffect(effect)
            SimpleAudioEngine:sharedEngine():playEffect(effect,isLoop)
        end
    end
end
--关闭背景音乐
function muteBgm()
    m_isBgmOpen = false
    SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
    
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启背景音乐
function openBgm()
    m_isBgmOpen = true
    SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(1)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isBgmOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end
--关闭音效
function muteSoundEffect()
    m_isSoundEffectOpen = false
    SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",false)
    CCUserDefault:sharedUserDefault():flush()
end
--开启音效
function openSoundEffect()
    m_isSoundEffectOpen = true
    SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
    CCUserDefault:sharedUserDefault():setBoolForKey("m_isSoundEffectOpen",true)
    CCUserDefault:sharedUserDefault():flush()
end

--播放背景音乐
function playMainBgm()
    playBgm("audio/main.mp3")
end
-- 退出场景，释放不必要资源
function release (...) 
    AudioUtil = nil
    package.loaded["AudioUtil"] = nil
    for k, v in pairs(package.loaded) do
        local s, e = string.find(k, "/AudioUtil")
        if s and e == string.len(k) then
            package.loaded[k] = nil
        end
    end
end

--如果是wp系统, 把mp3转为wav
function changeToWav( name )
    if(Platform.getOS() == "wp")then
        if(name == nil) then return "" end
        return string.gsub(name,".mp3",".wav")
    end
    return name
end
