package character.controllers.vision;

import character.BaseCharacter;
import flixel.FlxSprite;
import openfl.events.Event;

/**
 * ...
 * @author 
 */
class VisionEvent extends Event
{
	static public inline var FOUND_LIKE:String = "foundLike";
	static public inline var FOUND_HATE:String = "foundHate";
	
	public var seenView:FlxSprite;

	public function new(type:String, p_seenView:FlxSprite, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
		
		seenView = p_seenView;
		
	}
	
}