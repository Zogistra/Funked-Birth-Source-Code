package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
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
import flixel.input.keyboard.FlxKey;

class AltCreditsState extends MusicBeatState
{
	// you can change these if you want to
	var IMAGE_SIZE:Int = 520;
	var ICON_SIZE:Int = 100;
	
	// just the texts
	var roleTxt:Alphabet;
	var nameTxt:Alphabet;
	var descTxt:Alphabet;
	
	var credits:Array<CreditData> = [];
	
	var grpButtons:FlxTypedGroup<FlxSprite>;
	var grpImages:FlxTypedGroup<FlxSprite>;
	var grpIcons:FlxTypedGroup<FlxSprite>;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var colorTween:FlxTween;


	
	static var curSelected:Int = 0;
	
	override function create()
	{
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bgc'));
        //bg.scrollFactor.set(0, yScroll);
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

		super.create();
		
		// add the credits here
		addCredit('luis f', 'Director Artist and Animator', '":faceholdingbacktears"',                          "https://twitter.com/LuisF_0506");
		addCredit('andryu', 'Co Director and Artist', '"can you work on S.I.M.P?"',                          "https://twitter.com/SoyAndryu");
		addCredit('ketch0', 'Artist and Animator', '"Im going to kill me in the funny way"',                          "https://twitter.com/fellsans32");
		addCredit('allychiquita', 'Artist', '"Estoy chiquita"',                          "https://twitter.com/AIlyChiquita");
		addCredit('epic carlos', 'Artist', '"No tengo Twitter"',                          "");
		addCredit('samu music', 'Composer', '"I saved the mod"',                          "https://twitter.com/SAMU__MUSIC");
		addCredit('heymega', 'Composer', '"tilin si fuera una campana tilin tilin tilin"',                          "https://twitter.com/HeyMega3");
		addCredit('yinal', 'Chromatic scale', '"agujero es agujero aunque sea de caballero"',                          "https://twitter.com/Yina_Tilin");
		addCredit('vayront67', 'Charter', '"Cualquier cosa"',                          "https://twitter.com/Vayront637");
		addCredit('farsy', 'Charter', '"matense"',                          "https://twitter.com/Farsyyyyy");
		addCredit('wox', 'Artist and Animator', '"im starving"',                          "https://twitter.com/lol_wox");
		addCredit('zogistra', 'Coder', '"w"',                          "https://twitter.com/zogistra");
		
		
		// spawning stuff
		grpIcons = new FlxTypedGroup<FlxSprite>();
		grpImages = new FlxTypedGroup<FlxSprite>();
		for(i in 0...credits.length)
		{
			trace('${i + 1} out of ${credits.length}');

			var daImage = new FlxSprite().loadGraphic(Paths.image('altcredit/${credits[i].name}-image'));
            daImage.antialiasing = ClientPrefs.globalAntialiasing;
            //daImage.setGraphicSize(IMAGE_SIZE, IMAGE_SIZE);
            //daImage.updateHitbox();
            daImage.y = (FlxG.height / 2) - (daImage.height / 2);
            daImage.ID = i;
            grpImages.add(daImage);
			
			var daIcon = new FlxSprite().loadGraphic(Paths.image('altcredit/${credits[i].name}-icon'));
			daIcon.antialiasing = ClientPrefs.globalAntialiasing;
			//daIcon.setGraphicSize(ICON_SIZE, ICON_SIZE);
			//daIcon.updateHitbox();
			daIcon.y = daImage.y + daImage.height - (daIcon.height / 2);
			daIcon.ID = i;
			
			grpIcons.add(daIcon);
		}
		add(grpIcons);
		
		//trace('theres ${grpImages.length} images');
		trace('theres ${grpIcons.length} icons');
		
		grpButtons = new FlxTypedGroup<FlxSprite>();
		for(i in 0...2)
		{
			// nothing yet
			trace('left and right buttons goes here');
		}
		add(grpButtons);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

        leftArrow = new FlxSprite(5);
        leftArrow.y = FlxG.height/2 - 50;
        leftArrow.frames = ui_tex;
        leftArrow.animation.addByPrefix('idle', "arrow left");
        leftArrow.animation.addByPrefix('press', "arrow push left");
        leftArrow.animation.play('idle');
        leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
        add(leftArrow);

        rightArrow = new FlxSprite(FlxG.width - leftArrow.width-5, leftArrow.y);
        rightArrow.frames = ui_tex;
        rightArrow.animation.addByPrefix('idle', 'arrow right');
        rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
        rightArrow.animation.play('idle');
        rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
        add(rightArrow);
		
		changeSelection();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(controls.UI_LEFT_P)
			changeSelection(-1);
		if(controls.UI_RIGHT_P)
			changeSelection(1);
		if(controls.ACCEPT)
		{
			trace('yeaaaa');
			CoolUtil.browserLoad(credits[curSelected].media);
		}
		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		
		for(image in grpImages.members)
		{
			image.x = FlxMath.lerp(image.x, alignMiddle(image) + (FlxG.width * (image.ID - curSelected)), elapsed * 10);
		}
		
		for(icon in grpIcons.members)
		{
			var iconImage = grpImages.members[icon.ID];
			icon.x = FlxMath.lerp(icon.x, (iconImage.x + iconImage.height - (icon.width / 2)), elapsed * 10);
		}
	}
	
	function changeSelection(direction:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		
		curSelected += direction;
		curSelected = FlxMath.wrap(curSelected, 0, credits.length - 1);
		
		reloadTexts();
	}
	
	// removes the old ones and creates another ones
	function reloadTexts()
	{
		if(roleTxt != null) remove(roleTxt);
		if(nameTxt != null) remove(nameTxt);
		if(descTxt != null) remove(descTxt);
		
		roleTxt = new Alphabet(0, 0, credits[curSelected].name, true);
		roleTxt.x = alignMiddle(roleTxt);
		
		descTxt = new Alphabet(0, 0, credits[curSelected].description, true, false, 0, 0.6);
		descTxt.x = alignMiddle(descTxt);
		descTxt.y = FlxG.height - descTxt.height - 5;
		
		nameTxt = new Alphabet(0, 0, credits[curSelected].role, true, false, 0, 0.8);
		nameTxt.x = alignMiddle(nameTxt);
		nameTxt.y = descTxt.y - nameTxt.height - 5;
		
		add(roleTxt);
		add(nameTxt);
		add(descTxt);
	}
	
	function alignMiddle(daTxt:FlxSprite):Float
		return (FlxG.width / 2) - (daTxt.width / 2);
	
	// adds a credit into the array
	function addCredit(name:String, role:String, description:String, media:String)
	{
		var newCredit = new CreditData(name, role, description, media);
		credits.push(newCredit);
		trace(newCredit);
	}
}
// controls the texts and icons stuff
class CreditData
{
	public var name:String;
	public var role:String;
	public var description:String;
	public var media:String;
	
	public function new(name:String, role:String, description:String, media:String)
	{
		this.name = name;
		this.role = role;
		this.description = description;
		this.media = media;
	}
}