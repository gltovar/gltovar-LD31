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
	private var _mouseTest:BaseCharacter;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		napeDebugEnabled = true;

		
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
		while ( testingCharacters < 20 )
		{
			Reg.CHARACTERS.add( new BaseCharacter() );
			++testingCharacters;
		}
		
		var interactionListener:InteractionListener = new InteractionListener( CbEvent.BEGIN, InteractionType.COLLISION, BaseCharacter.characterInteraction, BaseCharacter.characterInteraction, onCharacterCollide);
		
		FlxNapeState.space.listeners.add( interactionListener );
		
		//_mouseTest = new BaseCharacter();
		//Reg.CHARACTERS.add( _mouseTest );
	}
	
	override public function update():Void 
	{
		super.update();
		
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