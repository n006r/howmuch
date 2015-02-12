package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author n06rin
 */
class FallingObject extends FlxSprite
{
	public var size(default, null):Int = 0;
	public var uniqNum(default, null):Int = 0;
	public var sorted:Bool = false;
	public var id:Int = 0;
	public var type:String;
	var typeOfTubeWhereItFall:Int;
	var fallingAnim:FlxTween;
	var typeMap:Map<Int, String> = [
				0 => "CircleBrownWithoutSq",
				1 => "CircleBlueWithoutSq",
				2 => "CircleGreenWithoutSq",
				3 => "CircleRedWithoutSq",
				4 => "SquareBrownWithoutSq",
				5 => "SquareBlueWithoutSq",
				6 => "SquareGreenWithoutSq",
				7 => "SquareRedWithoutSq",
				8 => "CircleBrownWithSq",
				9 => "CircleBlueWithSq",
				10 => "CircleGreenWithSq",
				11 => "CircleRedWithSq",
				12 => "SquareBrownWithSq",
				13 => "SquareBlueWithSq",
				14 => "SquareGreenWithSq",
				15 => "SquareRedWithSq",
				];

	public function new(compare1:Array<String>, compare2:Array<String>, inptSize:Int=1, X:Float=0, Y:Float=0, SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.objectTiles__png, true, 32, 32);
		
		var myRan = new FlxRandom();
		var except = new Array<Int> ();
		for (typeOfFO in typeMap.keys())
		{
			if (myRan.bool())
			{
			if (compare1[0] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare1[0]) == -1)
				except.push(typeOfFO);
			}
			if (compare1[1] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare1[1]) == -1)
				except.push(typeOfFO);
			}
			if (compare1[2] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare1[2]) == -1)
				except.push(typeOfFO);
			}
			}
			else
			{
			if (compare2[0] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare2[0]) == -1)
				except.push(typeOfFO);
			}
			if (compare2[1] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare2[1]) == -1)
				except.push(typeOfFO);
			}
			if (compare2[2] != null)
			{
				if (typeMap.get(typeOfFO).indexOf(compare2[2]) == -1)
				except.push(typeOfFO);
			}
			}
		}
		var workAr = new Array<Int>();
		for (typeOfFO in typeMap.keys())
		{
			var flag = true;
			for (wrongObj in except)
			if (typeOfFO == wrongObj) flag = false;
			if (flag == true) workAr.push(typeOfFO);
		}
		var rannum = myRan.int(0, workAr.length);
		FlxG.log.add("ranNum : " + rannum);
		uniqNum = workAr[rannum];
		//FlxG.log.add("UniqNum : " + uniqNum);
		
		animation.frameIndex = uniqNum;
		type = typeMap.get(uniqNum);
		if (myRan.bool())
		setGraphicSize(128, 128);
		else setGraphicSize(64, 64);
		fallingAnim = FlxTween.tween(this, { y:800 }, 5, { type: FlxTween.PERSIST, ease: FlxEase.cubeOut } );
	}
	

	
	public function fallToTube (tube:FlxSprite)
	{
		fallingAnim.cancel();
		//if (tube.x < 75) typeOfTubeWhereItFall = 1;
		//else typeOfTubeWhereItFall = 2;
		FlxTween.tween(this, { x:tube.x + 80, y:tube.y }, 0.5, { type: FlxTween.PERSIST, ease: FlxEase.cubeOut, onComplete:fallOntTube } );
	}
	
	public function fallOntTube (tween:FlxTween)
	{
		FlxTween.tween(this, { y:FlxG.height }, 0.3, { type: FlxTween.PERSIST, ease: FlxEase.elasticIn, onComplete:killMe} );
	}
	
	function killMe(tween:FlxTween)
	{
		//kill();
		destroy();
		
	}
	
}