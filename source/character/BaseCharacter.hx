package character;
import character.controllers.movement.MovementController;
import character.controllers.vision.VisionController;
import character.controllers.vision.VisionEvent;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author 
 */
class BaseCharacter extends FlxBasic
{
	public var dispatcher:EventDispatcher;
	
	public var colorAm:Int;
	public var colorLike:Int;
	public var colorHate:Int;
	public var shy:Bool;
	
	public var view:FlxSprite;
	public var vision:FlxSprite;
	
	public var movementController:MovementController;
	public var visionController:VisionController;
	
	public var angle:Float;
	
	public var currentLike:FlxSprite;
	public var currentHate:FlxSprite;

	public function new() 
	{
		super();
		
		colorAm = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		colorLike = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		colorHate = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		shy = (Math.round( Math.random()) == 1 ) ? true : false;
		
		dispatcher = new EventDispatcher();
		
		dispatcher.addEventListener( VisionEvent.FOUND_HATE, onFoundHate, false, 0, true );
		dispatcher.addEventListener( VisionEvent.FOUND_LIKE, onFoundLike, false, 0, true );
		
		view = new FlxSprite( 0,0);
		view.makeGraphic( 64, 64, FlxColor.TRANSPARENT, true );
		
		
		var bodyLinestyle:LineStyle = { color: colorHate, thickness: 5 };
		//var bodyFillstyle:FillStyle = { color: _colorAm, alpha: 1 };
		
		var eyeLinestyle:LineStyle = { color: FlxColor.WHITE, thickness: 3 };
		//var eyeFillstyle:FillStyle = { color: _colorLike, alpha: 1 };
		
		FlxSpriteUtil.drawCircle( view, -1, -1, 30, colorAm, bodyLinestyle );
		FlxSpriteUtil.drawCircle( view, -1, -1, 10, colorLike, eyeLinestyle );
		
		Reg.VIEWS.add( view );
		Reg.CHARACTER_COLORS[ colorAm ].add( view );
		
		view.setPosition( FlxRandom.intRanged( 64, FlxG.width - 64), FlxRandom.intRanged( 64, FlxG.height - 64) );
		
		movementController = new MovementController();
		movementController.init( this, view );
		
		view.origin.set( 32, 32 );
		//view.offset.set( -32, -32 );
		
		
		
		vision = new FlxSprite(0, 0);
		vision.makeGraphic( 32, 256, FlxColor.TRANSPARENT, true );
		var verticies:Array<FlxPoint> = new Array<FlxPoint>();
		verticies.push( FlxPoint.weak( 0, 0 ) );
		verticies.push( FlxPoint.weak( 32, 0 ) );
		verticies.push( FlxPoint.weak( 16, 256 ) );
		
		FlxSpriteUtil.drawPolygon( vision, verticies, FlxColor.MAGENTA );
		
		
		
		Reg.VISIONS.add( vision );
		vision.origin.set( 16, 256 );
		vision.offset.set( 16, 256 );
		
		
		
		angle = FlxRandom.floatRanged(0, 360);
		vision.angle = angle;
		
		visionController = new VisionController();
		visionController.init( this, vision );
	}
	
	override public function update():Void 
	{
		super.update();
		
		movementController.update();
		visionController.update();
		
		vision.setPosition( view.getMidpoint().x, view.getMidpoint().y );
		
	}
	
	private function onFoundHate( e:VisionEvent ):Void
	{
		// probaby start a new view 
		currentHate = e.seenView;
		movementController.newAvoidFound();
	}
	
	private function onFoundLike( e:VisionEvent ):Void
	{
		if ( currentLike == null)
		{
			currentLike = e.seenView;
			movementController.newLikeFound();
		}
		// e.seenView;
	}
}