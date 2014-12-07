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
import flixel.util.FlxVector;
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
	public static inline var TIME_GET_BACK_IN_BOUNDS_MAX:Float = 3;
	
	public static var characterInteraction:CbType = new CbType();
	
	public var dispatcher:EventDispatcher;
	
	public var colorAm:Int;
	public var colorLike:Int;
	public var colorHate:Int;
	public var shy:Bool;
	
	public var view:FlxNapeSprite;
	public var vision:Shape;
	public var visionColor:Int;
	
	//public var movementController:MovementController;
	//public var visionController:VisionController;
	
	public var angle:Float;
	
	public var currentLike:FlxNapeSprite;
	public var currentHate:FlxNapeSprite;
	
	private var _outOfBoundsTime:Float;

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
		view.setBodyMaterial(3, 0.2, 0, 1);
		view.body.position.set( Vec2.weak( FlxRandom.intRanged(64, FlxG.width - 64), FlxRandom.intRanged(64, FlxG.height - 64) ) );
		view.body.userData.character = this;
		view.body.rotation = FlxAngle.asRadians( FlxRandom.intRanged( 0, 360 ) );
		
		//view.body.applyAngularImpulse( FlxRandom.floatRanged( -1000, 1000) );
		view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(500,1000) , view.body.rotation, true ) );
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
			//view.body.applyAngularImpulse( FlxRandom.floatRanged( -1000, 1000) );
			//view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(10,80) , view.body.rotation, true ) );
		}
		
		view.body.velocity.rotate( view.body.rotation - view.body.velocity.angle );
		if ( view.body.velocity.length < .3 ) 
		{
			view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(1000, 2000) , view.body.rotation, true ) );
		
		}
		
		if ( _outOfBoundsTime > 0 )
		{
			FlxG.log.add( "angular velo: " + view.body.angularVel );
			//view.body.angularVel *= .98;
			
			var l_angleToCenter:Float = (FlxAngle.getAngle( FlxPoint.weak( view.body.position.x, view.body.position.y ), FlxPoint.weak( FlxG.width * .5, FlxG.height * .5 ) ) - 90) * FlxAngle.TO_RAD;
			var l_vectorToCenter:Vec2 = Vec2.fromPolar( 1, l_angleToCenter, true );
			var l_curVector:Vec2 = Vec2.fromPolar( 1, view.body.rotation, true );
			
			var l_distanceToCenterAngle:Float = Math.abs( Math.acos( FlxMath.dotProduct( l_curVector.x, l_curVector.y, l_vectorToCenter.x, l_vectorToCenter.y ) ) );
			
			while ( l_distanceToCenterAngle < Math.abs( view.body.angularVel / 60 ) )
			{
				view.body.angularVel = 0;
				//view.body.angularVel *= .5;
			}
			
			_outOfBoundsTime -= FlxG.elapsed;
		}
		else
		{
			if ( currentLike == null )
			{
		
				///FlxNapeState.debug.drawCircle( view.body.position, 128, visionColor );
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
				//FlxNapeState.debug.drawLine( view.body.position, currentLike.body.position, visionColor );
			}
		}
	}
	
	public function headingOutOfBounds():Void
	{
		if ( _outOfBoundsTime >= 0 )
		{
			return;
		}
		
		_outOfBoundsTime = TIME_GET_BACK_IN_BOUNDS_MAX;
		
		//view.body.rotation = 
		
		var pos_source:Vec2 = view.body.position.copy(true);
		var dir_source:Vec2 = Vec2.fromPolar(1, view.body.rotation, true);
		var pos_target:Vec2 = Vec2.weak( FlxG.width * .5, FlxG.height * .5 );
		
		if ( (pos_source.x - pos_target.x) * dir_source.y > (pos_source.y - pos_target.y) * dir_source.x )
		{
			// clockwise
			view.body.applyAngularImpulse( 10000  );
		}
		else
		{
			// counterclockwise
			view.body.applyAngularImpulse( -10000  );
		}
		//view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(250,500) , view.body.rotation, true ) );
		
		currentLike = null;
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