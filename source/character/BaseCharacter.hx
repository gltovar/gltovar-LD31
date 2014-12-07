package character;
import character.controllers.movement.MovementController;
import character.controllers.vision.VisionController;
import character.controllers.vision.VisionEvent;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import nape.geom.Vec2;
import nape.phys.BodyType;
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
	
	public var view:FlxNapeSprite;
	public var vision:FlxNapeSprite;
	
	//public var movementController:MovementController;
	//public var visionController:VisionController;
	
	public var angle:Float;
	
	public var currentLike:FlxNapeSprite;
	public var currentHate:FlxNapeSprite;

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
		
		view = new FlxNapeSprite( 0,0);
		view.makeGraphic( 64, 64, FlxColor.TRANSPARENT, true );
		
		
		var bodyLinestyle:LineStyle = { color: colorHate, thickness: 5 };
		
		var eyeLinestyle:LineStyle = { color: FlxColor.WHITE, thickness: 3 };
		
		FlxSpriteUtil.drawCircle( view, -1, -1, 30, colorAm, bodyLinestyle );
		FlxSpriteUtil.drawCircle( view, 48, -1, 10, colorLike, eyeLinestyle );
		
		view.antialiasing = true;
		
		view.createCircularBody( 32, BodyType.DYNAMIC );
		view.setBodyMaterial();
		view.body.position.set( Vec2.weak( FlxRandom.intRanged(64, FlxG.width - 64), FlxRandom.intRanged(64, FlxG.height - 64) ) );
		view.body.rotation = FlxAngle.asRadians( FlxRandom.intRanged( 0, 360 ) );
		
		view.body.applyAngularImpulse( FlxRandom.floatRanged( -10000, 10000) );
		view.body.applyImpulse( Vec2.fromPolar( 500, view.body.rotation, true ) );
		
		
		
		Reg.VIEWS.add( view );
		
		//Reg.VIEWS.add( view );
		//Reg.CHARACTER_COLORS[ colorAm ].add( view );
		
		//view.setPosition( FlxRandom.intRanged( 64, FlxG.width - 64), FlxRandom.intRanged( 64, FlxG.height - 64) );
		
		//movementController = new MovementController();
		//movementController.init( this, view );
		
		//view.origin.set( 32, 32 );
		//view.offset.set( -32, -32 );
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		view.body.velocity.rotate( view.body.rotation - view.body.velocity.angle );
		
		/*movementController.update();
		visionController.update();
		
		vision.setPosition( view.getMidpoint().x, view.getMidpoint().y );*/
		
	}
	
	private function onFoundHate( e:VisionEvent ):Void
	{
		// probaby start a new view 
		/*currentHate = e.seenView;
		movementController.newAvoidFound();*/
	}
	
	private function onFoundLike( e:VisionEvent ):Void
	{
		/*if ( currentLike == null)
		{
			currentLike = e.seenView;
			movementController.newLikeFound();
		}*/
		// e.seenView;
	}
}