package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
	'story mode',
	'freeplay',
	'credits',
	'options'
	];
    
    public static var firstStart:Bool = true;
    
    var newGaming:FlxText;
	var newGaming2:FlxText;
    var show:String = "";
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
    var backdrop:FlxBackdrop;
    var menu_character:FlxSprite;
    var logo:FlxSprite;
    var logoBl:FlxSprite;
    var fumo:FlxSprite;
    
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();
		
		add(backdrop = new FlxBackdrop(Paths.image('scrolling_BG')));
		backdrop.velocity.set(-40, -40);
		
        var random = FlxG.random.float(0, 1);
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
		if (random >= 0 && random <= 1)
		{
			trace('senpai');
			show = 'senpai';
		}
		
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
		case 'natsuki':
				menu_character = new FlxSprite(0, -140);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/natsuki');
				menu_character.antialiasing = true;
				menu_character.scale.set(.7, .7);
				menu_character.animation.addByPrefix('play', 'Natsu BG', 24);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
	    case 'pixelmonika':
				menu_character = new FlxSprite(-40, -240);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/pixelmonika');
				menu_character.antialiasing = true;
				menu_character.scale.set(.7, .7);
				menu_character.animation.addByPrefix('play', 'Monika_Neutral_gif', 24);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
		case 'senpai':
				menu_character = new FlxSprite(-100, -250);
				menu_character.frames = Paths.getSparrowAtlas('mainmenu/characters/Senpai');
				menu_character.antialiasing = true;
				menu_character.scale.set(.9, .9);
				menu_character.animation.addByPrefix('play', 'senpai_microphone', 24);
				menu_character.updateHitbox();
				menu_character.animation.play('play');
				add(menu_character);
				}
				
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
        
		for (i in 0...optionShit.length)
		{
		var menuItem:FlxSprite = new FlxSprite(-350, 390 + (i * 50));
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu');
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

		FlxG.camera.follow(camFollowPos, null, 1);

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
		addVirtualPad(UP_DOWN, A_B_C);
		#end

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

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

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
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
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
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
									case 'options':
										MusicBeatState.switchState(new OptionsState());
								}
							});
						}
					});
				}
			}
			else if (FlxG.keys.justPressed.SEVEN #if mobileC || _virtualpad.buttonC.justPressed #end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
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

		if ((show == 'pixelmonika' || show == 'natsuki' || show == 'senpai')
			&& curBeat % 2 == 0)
			menu_character.animation.play('play', true);
	}
}
