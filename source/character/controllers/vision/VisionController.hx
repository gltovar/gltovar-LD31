package character.controllers.vision;
import flixel.FlxBasic;
import character.BaseCharacter;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxVelocity;
/**
 * ...
 * @author 
 */
class VisionController extends FlxBasic
{
	public var character:BaseCharacter;
	public var vision:FlxSprite;
	
	public var state:VisionState;

	public function new() 
	{
		super();
	}
	
	public function init( p_character:BaseCharacter, p_vision:FlxSprite ):Void
	{
		character = p_character;
		vision = p_vision;
		
		switchState( VisionState.NOTHING_INTERESTING );
	}
	
	private function switchState( p_newState:VisionState ):Void
	{
		state = p_newState;
	}
	
	override public function update():Void 
	{
		super.update();
		
		switch( state )
		{
			case VisionState.NOTHING_INTERESTING:
				lookForSomethingInteresting();
			
			case VisionState.LIKE_FOUND:
			
			case VisionState.HATE_FOUND:
			
			case VisionState.SWEEP_CURRENT_FACING:
			
			case VisionState.LOOKING_AT_MIDDLE:
		}
	}
	
	private function lookForSomethingInteresting():Void
	{
		//character.angle += 1;
		vision.angle += 1;
		
		var colorViews:Array<FlxBasic> = Reg.CHARACTER_COLORS[character.colorHate].members;
		
		for ( viewIndex in 0...colorViews.length )
		{
			if ( FlxCollision.pixelPerfectCheck( vision, cast(colorViews[ viewIndex ]) ) )
			{
				character.dispatcher.dispatchEvent( new VisionEvent( VisionEvent.FOUND_HATE, cast(colorViews[ viewIndex ]) ) );
				return;
			}
		}
		
		colorViews = Reg.CHARACTER_COLORS[ character.colorLike ].members;
		
		
		for ( viewIndex in 0...colorViews.length )
		{
			if ( FlxCollision.pixelPerfectCheck( vision, cast(colorViews[ viewIndex ]) ) )
			{
				character.dispatcher.dispatchEvent( new VisionEvent( VisionEvent.FOUND_LIKE, cast(colorViews[ viewIndex ]) ) );
				return;
			}
		}
	}
}