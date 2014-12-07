package character;
import character.controllers.movement.MovementController;
import character.controllers.vision.VisionController;
import character.controllers.vision.VisionEvent;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.ShapeList;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author 
 */
class BaseCharacter extends FlxBasic
{
	public static var characterInteraction:CbType = new CbType();
	
	public var dispatcher:EventDispatcher;
	
	public var colorAm:Int;
	public var colorLike:Int;
	public var colorHate:Int;
	public var shy:Bool;
	
	public var view:FlxNapeSprite;
	//public var vision:FlxNapeSprite;
	public var vision:Shape;
	public var visionColor:Int;
	
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
		
		visionColor = FlxRandom.color(180);
		
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
		view.setBodyMaterial(.5, 0.2, 0, 1);
		view.body.position.set( Vec2.weak( FlxRandom.intRanged(64, FlxG.width - 64), FlxRandom.intRanged(64, FlxG.height - 64) ) );
		view.body.userData.character = this;
		/*view.body.rotation = FlxAngle.asRadians( FlxRandom.intRanged( 0, 360 ) );
		
		view.body.applyAngularImpulse( FlxRandom.floatRanged( -1000, 1000) );
		view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(10,80) , view.body.rotation, true ) );*/
		view.body.cbTypes.add( characterInteraction );
		
		
		Reg.VIEWS.add( view );
		
		
		//vision = new FlxNapeSprite(0, 0);
		
		//vision.body = 
		vision = new Polygon( Polygon.regular(128, 64, 3, Math.PI) );
		vision.body = new Body();
		
	
		
		
		
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
		
		if ( FlxRandom.chanceRoll(2) )
		{
			view.body.applyAngularImpulse( FlxRandom.floatRanged( -1000, 1000) );
			view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(10,80) , view.body.rotation, true ) );
		}
		
		view.body.velocity.rotate( view.body.rotation - view.body.velocity.angle );
		
		if ( currentLike == null )
		{
	
			FlxNapeState.debug.drawCircle( view.body.position, 128, visionColor );
			var l_bodyList:BodyList = FlxNapeState.space.bodiesInCircle( view.body.position, 128);
			for ( body in l_bodyList )
			{
				if ( body == view.body )
				{
					continue;
				}
				var l_character:BaseCharacter = body.userData.character;
				if ( l_character != null && l_character.colorAm == colorLike )
				{
					currentLike = l_character.view;
				}
			}
		}
		else
		{
			FlxNapeState.debug.drawLine( view.body.position, currentLike.body.position, visionColor );
		}
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