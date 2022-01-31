function onCreate()

    -- background shit
    playSound('ayo', 1)
    
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-pixel-dead');
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver-pixel');
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'bf-dies');
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd-pixel');

    makeLuaSprite('skyd', 'weeb/weebSky', 300, 240);
	addLuaSprite('skyd', false);
    setProperty('skyd.visible', true)
	scaleObject('skyd', 7, 7);
	setLuaSpriteScrollFactor('skyd', 0.9, 0.9);
    
    makeLuaSprite('backschoold', 'weeb/weebSchool', 80, 180);
	addLuaSprite('backschoold', false);
    setProperty('backschoold.visible', true)
	scaleObject('backschoold', 7, 7);
	setLuaSpriteScrollFactor('backschoold', 0.7, 1);

    makeLuaSprite('streetd', 'weeb/weebStreet', 1, 1);
	addLuaSprite('streetd', false);
	scaleObject('streetd', 8.5, 8.5);
    setProperty('streetd.visible', true)
	setLuaSpriteScrollFactor('streetd', 1, 1);

	makeLuaSprite('tresssd', 'weeb/weebTreesBack', 450, 325);
	addLuaSprite('tresssd', false);
    setProperty('tresssd.visible', true)
	scaleObject('tresssd', 5.5, 5.5);
	setLuaSpriteScrollFactor('tresssd', 1, 1);

	makeAnimatedLuaSprite('aaaad', 'weeb/weebTrees', 1, 220);
	addAnimationByPrefix('aaaad', 'bruhD', 'TreesD', 10, true);
	setGraphicSize('aaaad', getProperty('aaaad.width') * 8.5)
	setProperty('aaaad.visible', true);
	addLuaSprite('aaaad', false);

	makeAnimatedLuaSprite('petal1', 'weeb/petals', 1, 220);
	addAnimationByPrefix('petal1', 'bruuhh1', 'PETALS ALL0', 24, true);
	objectPlayAnimation('petal1', 'bruuhh1', true);
	setGraphicSize('petal1', getProperty('petal1.width') * 8.5)
	addLuaSprite('petal1', false);
	setObjectCamera('petal1', 'game');

	makeAnimatedLuaSprite('freaks', 'weeb/duet/bgFreaksAngry', 1, 410);
	addAnimationByPrefix('freaks', 'freak', 'BG fangirls dissuaded', 24, true);
	setGraphicSize('freaks', getProperty('freaks.width') * 6.5)
	setProperty('freaks.visible', true);
	addLuaSprite('freaks', false);

	setProperty('skyd.antialiasing', false)
	setProperty('backschoold.antialiasing', false)
	setProperty('streetd.antialiasing', false)
	setProperty('tresssd.antialiasing', false)
	setProperty('aaaad.antialiasing', false)
	setProperty('freaks.antialiasing', false)
	setProperty('petal1.antialiasing', false)

end

function onBeatHit()

    objectPlayAnimation('freaks', 'BG fangirls dissuaded', true);
	objectPlayAnimation('aaaad', 'TreesD', true);

end