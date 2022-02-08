package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	public static var psychEngineVersion:String = "0.4.2";

	var show:String = "";
	var menuItems:FlxTypedGroup<FlxSprite>;
	var crediticons:FlxTypedGroup<FlxSprite>;
	var fixdiff:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'credits', 'language', 'options'];

	public static var firstStart:Bool = true;

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;
	var logo:FlxSprite;
	var fumo:FlxSprite;
	var menu_character:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var backdrop:FlxBackdrop;
	var logoBl:FlxSprite;
	var grpLocks:FlxTypedGroup<FlxSprite>;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{

		#if FEATURE_DISCORD
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			Conductor.changeBPM(102);
		}

		if (!FlxG.save.data.monibeaten)
			FlxG.save.data.weekUnlocked = 1;

		trace("CURRENT WEEK: " + FlxG.save.data.weekUnlocked);

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80, -80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0.10;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);

		add(camFollow);

		add(backdrop = new FlxBackdrop(Paths.image('scrolling_BG')));
		backdrop.velocity.set(-40, -40);

		var random = FlxG.random.float(0, 20);
		// show = 'senpai';
		trace(random);
		if (!FlxG.save.data.extrabeaten)
		{
			trace('natsuki');
			show = 'natsuki';
		}
		else
		{
			trace('pixelmonika');
			show = 'pixelmonika';
		}
		if (random >= 0 && random <= 20)
		{
			trace('senpai');
			show = 'senpai';
		}

		//-700, =359
		logo = new FlxSprite(-900, -359).loadGraphic(Paths.image('Credits_LeftSide'));
		logo.antialiasing = true;
		add(logo);
		if (firstStart)
			FlxTween.tween(logo, {x: -700}, 1.2, {
				ease: FlxEase.elasticOut,
				onComplete: function(flxTween:FlxTween)
				{
					firstStart = false;
					changeItem();
				}
			});
		else
			logo.x = -700;

		//-600, -400
		logoBl = new FlxSprite(-800, -400);
		logoBl.frames = Paths.getSparrowAtlas('DDLCStart_Screen_Assets');
		logoBl.antialiasing = true;
		logoBl.scale.set(0.5, 0.5);
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		add(logoBl);
		if (firstStart)
			FlxTween.tween(logoBl, {x: -600}, 1.2, {
				ease: FlxEase.elasticOut,
				onComplete: function(flxTween:FlxTween)
				{
					firstStart = false;
					changeItem();
				}
			});
		else
			logoBl.x = -600;

		/*
			fumo = new FlxSprite(-100, -250).loadGraphic(Paths.image('Fumo'));
			fumo.scale.set(1, 1);
			add(fumo);
		 */

		switch (show)
		{
			case 'senpai':
				menu_character = new FlxSprite(-100, -250);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/Senpai');
				menu_character.antialiasing = true;
				menu_character.scale.set(.9, .9);
				menu_character.animation.addByPrefix('play', 'senpai_microphone', 24);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
			case 'pixelmonika':
				menu_character = new FlxSprite(-40, -240);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/pixelmonika');
				menu_character.antialiasing = true;
				menu_character.scale.set(.7, .7);
				menu_character.animation.addByPrefix('play', 'Monika_Neutral_gif', 24, false);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
			case 'natsuki':
				menu_character = new FlxSprite(0, -140);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/natsuki');
				menu_character.antialiasing = true;
				menu_character.scale.set(.7, .7);
				menu_character.animation.addByPrefix('play', 'Natsu BG', 24, false);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('mainmenu/menu');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-350, 390 + (i * 50));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.set(1.5, 1.5);
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem, {x: 50}, 1.2 + (i * 0.2), {
					ease: FlxEase.elasticOut,
					onComplete: function(flxTween:FlxTween)
					{
						firstStart = false;
						changeItem();
					}
				});
			else
				menuItem.x = 50;
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if (firstStart)
			FlxTween.tween(versionShit, {x: 5}, 1.2, {
				ease: FlxEase.elasticOut,
				onComplete: function(flxTween:FlxTween)
				{
					firstStart = false;
					changeItem();
				}
			});
		else
			versionShit.x = 5;

		FlxG.camera.follow(camFollow);

		// NG.core.calls.event.logEvent('swag').send();

		#if mobileC
		addVirtualPad(UP_DOWN, A_B);
		#end

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						if (FlxG.save.data.flashing)
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								goToState();
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState();
							});
						}
					}
				});
			}
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
		menuItems.forEach(function(spr:FlxSprite)
		{
			// spr.screenCenter(X);
		});
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
			MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
			MusicBeatState.switchState(new FreeplayState());
			case 'credits':
			MusicBeatState.switchState(new CreditsState());
			case 'language':
			FlxG.switchState(new LangSelectState());
			case 'options':
			MusicBeatState.switchState(new OptionsState());
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= optionShit.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = optionShit.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);

		if ((show == 'natsuki' || show == 'pixelmonika')
			&& curBeat % 2 == 0)
			menu_character.animation.play('play', true);
	}
}