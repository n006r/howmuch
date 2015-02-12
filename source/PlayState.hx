package;

import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
//import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var apple:FallingObject;
	var myRand:FlxRandom;
	public static var score:Int = 0;
	var scoreText:FlxText;
	var zone:FlxSprite;
	var angle:FlxSprite;
	var falling:FlxTween;
	var firsttubeBG:FlxSprite;
	var secondtubeBG:FlxSprite;
	var line:FlxSprite;
	public static var GameOverMode:Bool = false;
	var falledApple:FallingObject;
	var appleCounter:Int = 0;
	var fallingApplelinks:Map<Int, FallingObject>;
	var fallingApples:FlxTypedGroup<FallingObject>;
	var fallingSortedApples:FlxTypedGroup<FallingObject>;
	var fallingObjectsArray:Array<FallingObject>;
	var firstTubeType:Array<String>;
	var secondTubeType:Array<String>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		this.bgColor = FlxColor.GRAY;
		
		line = new FlxSprite(FlxG.width /2 - 140 , -200, AssetPaths.imageline__png);
		line.setGraphicSize (320, 675);
		line.updateHitbox();
		add (line);
		
		fallingApples = new FlxTypedGroup<FallingObject> (100);
		add(fallingApples);
		fallingSortedApples = new FlxTypedGroup<FallingObject> (100);
		add(fallingSortedApples);
		fallingObjectsArray = new Array<FallingObject> ();
		
		firsttubeBG = new FlxSprite(0, FlxG.height - 256, AssetPaths.tube1__png);
		firsttubeBG.setGraphicSize (256, 256);
		firsttubeBG.updateHitbox();
		firsttubeBG.alpha = 0.5;
		add (firsttubeBG);
		createFirstSortType ();
		
		
		secondtubeBG = new FlxSprite(FlxG.width -240 , FlxG.height - 256, AssetPaths.tube1__png);
		secondtubeBG.setGraphicSize (256, 256);
		secondtubeBG.updateHitbox();
		add (secondtubeBG);
		createSecondSortType();
		
		
		//var secondtube = new FlxSprite(FlxG.width -190 , FlxG.height -210, AssetPaths.Green__png);
		//secondtube.setGraphicSize (128, 128);
		//secondtube.updateHitbox();
		//FlxMouseEventManager.add(secondtube, onSeconTubeDown);
		//add (secondtube);
		
		myRand = new FlxRandom ();
		scoreText = new FlxText (0, 0, 0, "test rand " + myRand.int(1, 3), 40);
		add (scoreText);
		//zone = new FlxSprite();
		//zone.makeGraphic(16, 16, FlxColor.BLUE);
		//zone.y = 650;
		//zone.x = FlxG.width / 2;
		//add (zone);
		
		generateNeededFigures();
		
		var spawnTimer = new FlxTimer();
		spawnTimer.start(0.5, createMovingAppleOnTimer, 0);
	}
	
	function createFirstSortType ()
	{
		
		firstTubeType = new Array<String> ();
		var newRan = new FlxRandom();
		if (newRan.bool())
		{
			switch (newRan.int(0, 3))
			{
				case 0: firstTubeType [0]= "Brown";
				case 1: firstTubeType [0]= "Blue";
				case 2: firstTubeType [0]= "Green";
				case 3: firstTubeType [0]= "Red";
			}
			var firsttubeColor = new FlxSprite(50, FlxG.height - 92, "assets/images/colours/" + firstTubeType[0] + ".png");
			firsttubeColor.setGraphicSize (128, 128);
			firsttubeColor.updateHitbox();
			add (firsttubeColor);
		}
		
		if (newRan.bool())
		{
			if (newRan.bool()) firstTubeType [1]= "Square";
			else firstTubeType [1]= "Circle";
		//var firsttubeFigure= new FlxSprite();
		
			if (firstTubeType[1] == "Square")
			{
				var firsttubeFigure = new FlxSprite(50, FlxG.height - 210, AssetPaths.SquareSiluette__png);
				firsttubeFigure.setGraphicSize (128, 128);
				firsttubeFigure.updateHitbox();
				add (firsttubeFigure);
			}
			else
			{
				var firsttubeFigure = new FlxSprite(50, FlxG.height - 210, AssetPaths.CircleSiluette__png);
				firsttubeFigure.setGraphicSize (128, 128);
				firsttubeFigure.updateHitbox();
				add (firsttubeFigure);
			}
		}
		
		if (newRan.bool())
		{
			firstTubeType [2]= "WithSq";
			var squareFigure = new FlxSprite(50, FlxG.height - 210, AssetPaths.withquad__png);
			squareFigure.setGraphicSize (128, 128);
			squareFigure.updateHitbox();
			add (squareFigure);
		}
		else
		{
			firstTubeType [2]= "WithoutSq";
		}
		
		//FlxG.log.add("My var: " + firstTubeType[0]+firstTubeType[1]);
		FlxG.log.add("FirstTube : " + firstTubeType[0] + firstTubeType[1] + firstTubeType[2]);
		
	}
	
	function createSecondSortType ()
	{
		secondTubeType = new Array<String> ();
		var newRan = new FlxRandom();
		
		if (firstTubeType[0] == null )
		{
			switch (newRan.int(0, 3))
			{
				case 0: secondTubeType [0]= "Brown";
				case 1: secondTubeType [0]= "Blue";
				case 2: secondTubeType [0]= "Green";
				case 3: secondTubeType [0]= "Red";
			}
			var secondtubeColor = new FlxSprite(FlxG.width -190 , FlxG.height - 92, "assets/images/colours/" + secondTubeType[0] + ".png");
			secondtubeColor.setGraphicSize (128, 128);
			secondtubeColor.updateHitbox();
			add (secondtubeColor);
		}
		
		if (firstTubeType[1] == null )
		{
			if (newRan.bool()) secondTubeType [1]= "Square";
			else secondTubeType [1]= "Circle";
		}
		else 
		{
			if (firstTubeType[1] == "Square")
				secondTubeType[1] = "Circle";
			else secondTubeType[1] = "Square";
		}
		
		if (secondTubeType[1] == "Square")
			{
				var secondTubeFigure = new FlxSprite(FlxG.width -190, FlxG.height - 210, AssetPaths.SquareSiluette__png);
				secondTubeFigure.setGraphicSize (128, 128);
				secondTubeFigure.updateHitbox();
				add (secondTubeFigure);
			}
		else
			{
				var secondTubeFigure = new FlxSprite(FlxG.width -190, FlxG.height - 210, AssetPaths.CircleSiluette__png);
				secondTubeFigure.setGraphicSize (128, 128);
				secondTubeFigure.updateHitbox();
				add (secondTubeFigure);
			}
			
		if (firstTubeType [2] == null)
		{
			secondTubeType [2]= "WithSq";
			var secondSquareFigure = new FlxSprite(FlxG.width -190, FlxG.height - 210, AssetPaths.withquad__png);
			secondSquareFigure.setGraphicSize (128, 128);
			secondSquareFigure.updateHitbox();
			add (secondSquareFigure);
		}
		else
		{
			secondTubeType [2]= "WithoutSq";
		}
		
		FlxG.log.add("SecondTube : " + secondTubeType[0]+secondTubeType[1]+secondTubeType[2]);
	}
	
	function createMovingAppleOnTimer (Timer:FlxTimer)
	{
		createMovingApple ();
	}
	
	function generateNeededFigures ()
	{
		var typeMap:Map<Int, Array<String>> = [
				0 => ["Circle","Brown","WithoutSq"],
				1 => ["Circle","Blue","WithoutSq"],
				2 => ["Circle","Green","WithoutSq"],
				3 => ["Circle","Red","WithoutSq"],
				4 => ["Square","Brown","WithoutSq"],
				5 => ["Square","Blue","WithoutSq"],
				6 => ["Square","Green","WithoutSq"],
				7 => ["Square","Red","WithoutSq"],
				8 => ["Circle","Brown","WithSq"],
				9 => ["Circle","Blue","WithSq"],
				10 => ["Circle","Green","WithSq"],
				11 => ["Circle","Red","WithSq"],
				12 => ["Square","Brown","WithSq"],
				13 => ["Square","Blue","WithSq"],
				14 => ["Square","Green","WithSq"],
				15 => ["Square","Red","WithSq"],
				];
		//var except = new Array<Int> ();		
		for (typeOfFO in typeMap.keys())
		{
			if (firstTubeType[0] != null)
			{
				if (typeMap.get(typeOfFO) [0] != firstTubeType[0])
				typeMap.remove(typeOfFO);
			}
			if (firstTubeType[1] != null)
			{
				if (typeMap.get(typeOfFO) [1] != firstTubeType[1])
				typeMap.remove(typeOfFO);
			}
			if (firstTubeType[2] != null)
			{
				if (typeMap.get(typeOfFO) [2] != firstTubeType[2])
				typeMap.remove(typeOfFO);
			}
			if (firstTubeType[0] != null)
			{
				if (typeMap.get(typeOfFO) [0] != secondTubeType[0])
				typeMap.remove(typeOfFO);
			}
			if (firstTubeType[1] != null)
			{
				if (typeMap.get(typeOfFO) [1] != secondTubeType[1])
				typeMap.remove(typeOfFO);
			}
			if (firstTubeType[2] != null)
			{
				if (typeMap.get(typeOfFO) [2] != secondTubeType[2])
				typeMap.remove(typeOfFO);
			}
		}
		
		for (typeOfFO in typeMap.keys())
		{
			FlxG.log.add("typeMap : " + typeOfFO+" soderzhit "+ typeMap.get(typeOfFO));
		}
	}
	
	function createMovingApple () {
		//var allCriteria = new Array<String>();
		//allCriteria.
		apple = new FallingObject(firstTubeType,secondTubeType, myRand.int(1, 3),FlxG.width / 2, 0, AssetPaths.apple__png);
		fallingApples.add(apple);
		fallingObjectsArray.insert(0, apple);
		appleCounter++;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
	super.update(elapsed);
	
	
		if (!GameOverMode)
		{
			scoreText.text = "score: " + score;
		
			for (apl in fallingApples)
				if (!apl.overlaps(line))
				{
					gameOver("permanent");
				//falling.cancel();
				//apple.destroy();
				}
			
			for (swipe in FlxG.swipes)
			{
				var start = swipe.startPosition;
				var end = swipe.endPosition;
			
				if (end.x < start.x)
				{
					if (appleCounter > 0)
					{
						falledApple = fallingObjectsArray.pop();
						add (falledApple);
						fallingApples.remove(falledApple);
						falledApple.fallToTube(firsttubeBG);
					
						var result:Int = 0;
						var neededResult:Int = 0;
						if (firstTubeType[0] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(firstTubeType[0]) != -1)
							result++;
						}
						if (firstTubeType[1] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(firstTubeType[1]) != -1)
							result++;
						}
						if (firstTubeType[2] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(firstTubeType[2]) != -1)
							result++;
						}
						
						if (neededResult == result)
							PlayState.score++;
						else
							gameOver();
						
						appleCounter--;
					}
				}
				else
				{
					if (appleCounter > 0)
					{
						falledApple = fallingObjectsArray.pop();
						add (falledApple);
						fallingApples.remove(falledApple);
						falledApple.fallToTube(secondtubeBG);
					
						var result:Int = 0;
						var neededResult:Int = 0;
						if (secondTubeType[0] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(secondTubeType[0]) != -1)
							result++;
						}
						if (secondTubeType[1] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(secondTubeType[1]) != -1)
							result++;
						}
						if (secondTubeType[2] != null )
						{
							neededResult++;
							if (falledApple.type.indexOf(secondTubeType[2]) != -1)
							result++;
						}
						
						if (neededResult == result)
							PlayState.score++;
						else
							gameOver();
						
						appleCounter--;
					}
				}	
			}
		}
	}
	
	
	function gameOver(type:String= "delay")
	{
		var gameOverTimer = new FlxTimer();
		if (type == "delay")
			gameOverTimer.start(1, continueOfGameOver);
		else if (type == "permanent")
			gameOverTimer.start(0.1, continueOfGameOver);
	}
	function continueOfGameOver (Timer:FlxTimer)
	{
		GameOverMode = true;
		this.bgColor = FlxColor.RED;
		var gameOver = new FlxText (FlxG.width / 2, FlxG.height / 2, 0, "GAME OVER", 40);
		add (gameOver);
		var newGame = new FlxUIButton(FlxG.width / 2, FlxG.height / 2 + 150, "retry", callNewGame);
		newGame.resize (200, 100);
		//newGame.updateHitbox();
		add (newGame);
	}
	
	function callNewGame ()
	{
		GameOverMode = false;
		FlxG.switchState(new PlayState());
	}
}