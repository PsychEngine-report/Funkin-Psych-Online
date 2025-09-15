package states;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		#if mobile
		final accept:String = (controls.mobileC) ? 'A' : 'ACCEPT';
		final back:String = (controls.mobileC) ? 'B' : 'BACK';
		#end

		leftState = false;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Sorry, but you have to update this mod
			your current version is '" + Main.PSYCH_ONLINE_VERSION + "' while
			the latest is '" + Main.updateVersion + "'\n
			ACCEPT - Jump into the download page!
			BACK - Continue without updating.",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		#if mobile
		addTouchPad('NONE', 'A_B');
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				CoolUtil.browserLoad(Main.updatePageURL);
				online.network.Auth.saveClose();
				Sys.exit(1);
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						FlxG.switchState(() -> new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
