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
		
		//_mouseTest = new BaseCharacter();
		//Reg.CHARACTERS.add( _mouseTest );
	}
	
	override public function update():Void 
	{
		super.update();
		
		//_mouseTest.view.setPosition( FlxG.mouse.x, FlxG.mouse.y );
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