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
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.phys.BodyType;

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
		while ( testingCharacters < 25 )
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
		
		//FlxNapeState.debug.drawCircle( Vec2.weak(FlxG.mouse.x, FlxG.mouse.y), 25, 0xffffffff ) ;
		
		
		//_mouseTest.view.setPosition( FlxG.mouse.x, FlxG.mouse.y );
	}
	
	private function onCharacterCollide( p_collision:InteractionCallback ):Void
	{
		//FlxG.log.add("a bounce!");
		//FlxAngle.
		
		p_collision.int1.castBody.rotation += 3.14;
		//p_collision.int1.castBody.angularVel *= -1;
		p_collision.int2.castBody.rotation += 3.14;
		//p_collision.int2.castBody.angularVel *= -1;
		
		
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