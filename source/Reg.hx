package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import openfl.geom.Rectangle;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	
	public static var BOUNDS_LEFT:Rectangle;
	public static var BOUNDS_TOP:Rectangle;
	public static var BOUNDS_RIGHT:Rectangle;
	public static var BOUNDS_BOTTOM:Rectangle;
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	public static var COLORS:Array<Int> = [ FlxColor.CRIMSON, FlxColor.AZURE, FlxColor.GOLDEN, FlxColor.LAVENDER ];
	
	public static var CHARACTERS:FlxGroup;
	public static var VIEWS:FlxGroup;
	public static var VISIONS:FlxGroup;
	
	public static var CHARACTER_COLORS:Map<Int,FlxGroup> = [	FlxColor.CRIMSON 		=> null,
																FlxColor.AZURE		=> null,
																FlxColor.GOLDEN		=> null,
																FlxColor.LAVENDER => null ];
																
}