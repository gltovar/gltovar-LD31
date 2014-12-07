package;

import character.BaseCharacter;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.addons.nape.FlxNapeState;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.BodyList;
import nape.phys.BodyType;
import openfl.geom.Rectangle;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxNapeState
{	
	public static inline var TIME_DELAY_PLACEMENT:Float = 5;
	
	private var _mouseTest:BaseCharacter;
	
	private var _currentDropTime:Float;
	
	private var _dropTimeMultiplier:Float;
	
	private var _countDownText:FlxText;
	private var _scoreText:FlxText;
	private var _strikeText:FlxText;
	
	private var _nextDropColor:Int;
	
	private var state:GameState;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		napeDebugEnabled = true;
		
		Reg.score = 0;
		Reg.strikes = 0;

		FlxG.sound.playMusic("assets/music/music.wav", .25);
		
		Reg.BOUNDS_TOP = new Rectangle(0, 0, FlxG.width, 75);
		Reg.BOUNDS_RIGHT = new Rectangle(FlxG.width-75, 0, 75, FlxG.height);
		Reg.BOUNDS_BOTTOM = new Rectangle(0, FlxG.height-75, FlxG.width, 75);
		Reg.BOUNDS_LEFT = new Rectangle(0, 0, 75, FlxG.height);
		
		
		var	colorIndex:Int = 0;
		
		while ( colorIndex < Reg.COLORS.length )
		{
			Reg.CHARACTER_COLORS[ Reg.COLORS[ colorIndex ] ] = new FlxGroup();
			++colorIndex;
		}
		
		Reg.CHARACTERS = new FlxGroup();
		add(Reg.CHARACTERS);
		
		Reg.VIEWS = new FlxGroup();
		add(Reg.VIEWS);
		
		Reg.VISIONS = new FlxGroup();
		add(Reg.VISIONS);
		
	
		
		var testingCharacters:Int = 0;
		/*while ( testingCharacters < 8 )
		{
			Reg.CHARACTERS.add( new BaseCharacter( ) );
			
			++testingCharacters;
		}*/
		
		var interactionListener:InteractionListener = new InteractionListener( CbEvent.BEGIN, InteractionType.COLLISION, BaseCharacter.characterInteraction, BaseCharacter.characterInteraction, onCharacterCollide);
		
		FlxNapeState.space.listeners.add( interactionListener );
		
		_currentDropTime = TIME_DELAY_PLACEMENT - FlxG.elapsed;
		_dropTimeMultiplier = 1;
		
		
		_nextDropColor = Reg.COLORS[ FlxRandom.intRanged(0, Reg.COLORS.length -1) ];
		
		_countDownText = new FlxText(0, 0, 150);
		_countDownText.size = 24;
		_countDownText.color = _nextDropColor;
		_countDownText.borderStyle = FlxText.BORDER_OUTLINE_FAST;
		_countDownText.borderColor = 0;
			
		add(_countDownText);
		
		
		_scoreText = new FlxText(0, 0, 150);
		_scoreText.size = 12;
		_scoreText.color = FlxColor.WHITE;
		_scoreText.borderStyle = FlxText.BORDER_OUTLINE_FAST;
		_scoreText.borderColor = 0;
		
		add(_scoreText);
		
		_strikeText = new FlxText(0, 0, 150);
		_strikeText.size = 16;
		_strikeText.color = FlxColor.MAROON;
		_strikeText.borderStyle = FlxText.BORDER_OUTLINE_FAST;
		_strikeText.borderColor = FlxColor.WHITE;
		
		add(_strikeText );
		
		state = GameState.INTRO;
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch( state )
		{
			case GameState.INTRO:
				intro();
			case GameState.PLAYING:
				playing();
			case GameState.GAME_OVER:
				gameOver();
		}
		
	}
	
	private function intro():Void
	{
		if ( FlxG.mouse.justReleased )
		{
			state = GameState.PLAYING;
		}
	}
	
	private function gameOver():Void
	{
		if ( FlxG.mouse.justReleased )
		{
			Reg.CHARACTERS.destroy();
			Reg.VIEWS.destroy();
			
			FlxG.resetState();
		}
	}
	
	private function playing():Void
	{
		/*FlxNapeState.debug.drawAABB(  AABB.fromRect( Reg.BOUNDS_TOP ), FlxColor.WHITE );
		FlxNapeState.debug.drawAABB(  AABB.fromRect( Reg.BOUNDS_RIGHT ), FlxColor.WHITE );
		FlxNapeState.debug.drawAABB(  AABB.fromRect( Reg.BOUNDS_BOTTOM ), FlxColor.WHITE );
		FlxNapeState.debug.drawAABB(  AABB.fromRect( Reg.BOUNDS_LEFT ), FlxColor.WHITE );*/
		
		var l_bodyList:BodyList;
		var l_baseCharacter:BaseCharacter;
		l_bodyList = FlxNapeState.space.bodiesInAABB( AABB.fromRect( Reg.BOUNDS_TOP ) );
		
		for ( l_body in l_bodyList )
		{
			l_baseCharacter = l_body.userData.character;
			if ( l_baseCharacter != null )
			{
				l_baseCharacter.headingOutOfBounds();
			}
		}
		
		
		l_bodyList = FlxNapeState.space.bodiesInAABB( AABB.fromRect( Reg.BOUNDS_RIGHT ) );
		
		for ( l_body in l_bodyList )
		{
			l_baseCharacter = l_body.userData.character;
			if ( l_baseCharacter != null )
			{
				l_baseCharacter.headingOutOfBounds();
			}
		}
		
		
		l_bodyList = FlxNapeState.space.bodiesInAABB( AABB.fromRect( Reg.BOUNDS_BOTTOM ) );
		
		for ( l_body in l_bodyList )
		{
			l_baseCharacter = l_body.userData.character;
			if ( l_baseCharacter != null )
			{
				l_baseCharacter.headingOutOfBounds();
			}
		}
		
		
		l_bodyList = FlxNapeState.space.bodiesInAABB( AABB.fromRect( Reg.BOUNDS_LEFT ) );
		
		for ( l_body in l_bodyList )
		{
			l_baseCharacter = l_body.userData.character;
			if ( l_baseCharacter != null )
			{
				l_baseCharacter.headingOutOfBounds();
			}
		}
		
		if ( _currentDropTime <= 0 )
		{
			Reg.CHARACTERS.add( new BaseCharacter( _nextDropColor, FlxG.mouse.x, FlxG.mouse.y) );
			FlxG.sound.play( "assets/sounds/Blip_Place.wav", .1 );
			_currentDropTime = TIME_DELAY_PLACEMENT;
			_dropTimeMultiplier += .01;
			_nextDropColor = Reg.COLORS[ FlxRandom.intRanged(0, Reg.COLORS.length -1) ];
			_countDownText.color = _nextDropColor;
			++Reg.score;
		}
		else if ( Math.floor( _currentDropTime ) != Math.floor( _currentDropTime - (FlxG.elapsed * _dropTimeMultiplier) ) && _currentDropTime - (FlxG.elapsed * _dropTimeMultiplier) > 0 )
		{
			FlxG.sound.play("assets/sounds/Blip_Countdown.wav", .1 );
		}
		
		var l_pointIndex:Int = Std.string( _currentDropTime ).indexOf('.');
		_countDownText.text = Std.string( _currentDropTime ).substring(0, l_pointIndex+2);
		_countDownText.setPosition( FlxG.mouse.x + 20, FlxG.mouse.y );
		
		_scoreText.text = ""+Reg.score;
		_scoreText.setPosition( FlxG.mouse.x + 20, FlxG.mouse.y - 18 );
		
		switch( Reg.strikes )
		{
			case 0:
				_strikeText.text = "";
			case 1:
				_strikeText.text = "X";
			case 2:
				_strikeText.text = "X X";
			case 3:
				_strikeText.text = "X X X";
				state = GameState.GAME_OVER;
				// GAMEOVER!!!!!
		}
		_strikeText.setPosition( FlxG.mouse.x + 20, FlxG.mouse.y + 30 );
		
		_currentDropTime -= FlxG.elapsed * _dropTimeMultiplier;
		
		
		//FlxNapeState.debug.drawCircle( Vec2.weak(FlxG.mouse.x, FlxG.mouse.y), 25, 0xffffffff ) ;
		
		//_mouseTest.view.setPosition( FlxG.mouse.x, FlxG.mouse.y );
	}
	
	private function onCharacterCollide( p_collision:InteractionCallback ):Void
	{
		//FlxG.log.add("a bounce!");
		//FlxAngle.
		
		//p_collision.int1.castBody.rotation += 3.14;
		//p_collision.int1.castBody.angularVel *= -1;
		//p_collision.int2.castBody.rotation += 3.14;
		//p_collision.int2.castBody.angularVel *= -1;
		
		p_collision.int1.castBody.userData.character.onBump( p_collision.int2.castBody.userData.character.view );
		p_collision.int2.castBody.userData.character.onBump( p_collision.int1.castBody.userData.character.view );
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
}