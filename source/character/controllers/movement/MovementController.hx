package character.controllers.movement;
import flixel.FlxBasic;
import character.BaseCharacter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;

/**
 * ...
 * @author 
 */
class MovementController extends FlxBasic
{
	public static inline var TIME_AVOID:Float = 1;
	public static inline var MAX_VELOCITY:Float = 20;
	
	
	private var _character:BaseCharacter;
	private var _view:FlxSprite;
	
	private var	_like:FlxSprite;
	
	private var _accel:Float;
	
	public var state:MovementState;
	
	private var _currentAvaoidTime:Float;
	
	public function new() 
	{
		super();
	}
	
	public function init( p_character:BaseCharacter, p_view:FlxSprite ):Void
	{
		_character = p_character;
		_view = p_view;
		
		_view.velocity.set(0, 0);
		_view.acceleration.set( 0, 0 );
		_accel = 0;
		
		
		switchState( MovementState.IDLE );
		
	}
	
	private function switchState( p_newState:MovementState ):Void
	{
		state = p_newState;
	}
	
	override public function update():Void 
	{
		super.update();
		
		_accel = FlxMath.bound(_accel, -MAX_VELOCITY, MAX_VELOCITY);
		
		switch( state )
		{
			case MovementState.IDLE:
			
			case MovementState.AVOIDING:
				avoiding();
				
			case MovementState.ENGAGING:
				engaging();
				
			case MovementState.SEARCHING:
		}
		
	}
	
	
	private function avoiding():Void
	{
		if ( _character.currentHate == null )
		{
			if ( _character.currentLike != null )
			{
				switchState( MovementState.ENGAGING );
			}
			else
			{
				switchState( MovementState.IDLE );
			}
			return;
		}
		
		if ( _currentAvaoidTime <= TIME_AVOID )
		{
			FlxVelocity.moveTowardsObject(_view, _character.currentHate, _accel += -2);
			_currentAvaoidTime += FlxG.elapsed;
		}
		else
		{
			_accel = Math.max(0, _accel);
			if ( _character.currentLike != null )
			{
				switchState( MovementState.ENGAGING );
			}
			else
			{
				switchState( MovementState.IDLE );
			}
		}
	}
	
	private function engaging():Void
	{
		if ( _character.currentLike == null )
		{
			switchState( MovementState.IDLE );
			return;
		}
		
		FlxVelocity.moveTowardsObject( _view, _character.currentLike, _accel += 1);
	}
	
	public function newAvoidFound():Void
	{
		_currentAvaoidTime = 0;
		
		switchState( MovementState.AVOIDING );
	}
	
	public function newLikeFound():Void
	{
		switchState( MovementState.ENGAGING );
	}
	
}