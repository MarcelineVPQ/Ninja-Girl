package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_2_2_SlopeDetection extends ActorScript
{
	public var onSlope:Bool;
	public var yNorm:Float;
	public var touchedSlope:Bool;
	public var preventSlide:Bool;
	public var canSlide:Bool;
	public var oldX:Float;
	public var LeftControl:String;
	public var RightControl:String;
	public var MaxSlopeGrade:Float;
	public var EnableDebugging:Bool;
	public var SlideWhileDucking:Bool;
	public var DuckControl:String;
	public var JumpControl:String;
	public var oldY:Float;
	public var SlopeGrade:Float;
	public var SlideSpeed:Float;
	public var SlideAcceleration:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("onSlope", "onSlope");
		onSlope = false;
		nameMap.set("yNorm", "yNorm");
		yNorm = 0.0;
		nameMap.set("touchedSlope", "touchedSlope");
		touchedSlope = false;
		nameMap.set("preventSlide", "preventSlide");
		preventSlide = false;
		nameMap.set("canSlide", "canSlide");
		canSlide = false;
		nameMap.set("oldX", "oldX");
		oldX = 0.0;
		nameMap.set("Left Control", "LeftControl");
		nameMap.set("Right Control", "RightControl");
		nameMap.set("Max Slope Grade", "MaxSlopeGrade");
		MaxSlopeGrade = 20.0;
		nameMap.set("Enable Debugging?", "EnableDebugging");
		EnableDebugging = false;
		nameMap.set("Slide While Ducking?", "SlideWhileDucking");
		SlideWhileDucking = true;
		nameMap.set("Duck Control", "DuckControl");
		nameMap.set("Jump Control", "JumpControl");
		nameMap.set("oldY", "oldY");
		oldY = 0.0;
		nameMap.set("Slope Grade", "SlopeGrade");
		SlopeGrade = 0.0;
		nameMap.set("Slide Speed", "SlideSpeed");
		SlideSpeed = 0.3;
		nameMap.set("Slide Acceleration", "SlideAcceleration");
		SlideAcceleration = 0.003;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((onSlope && !(touchedSlope)))
				{
					if(((actor.getY() < oldY) && !(isKeyDown(JumpControl))))
					{
						actor.setYVelocity(0.0);
					}
				}
				onSlope = touchedSlope;
				propertyChanged("onSlope", onSlope);
				canSlide = !(preventSlide);
				propertyChanged("canSlide", canSlide);
				touchedSlope = false;
				propertyChanged("touchedSlope", touchedSlope);
				preventSlide = false;
				propertyChanged("preventSlide", preventSlide);
				if(onSlope)
				{
					if((SlideWhileDucking && (isKeyDown(DuckControl) && !(isKeyDown(JumpControl)))))
					{
						actor.setActorValue("Is Slope Sliding?", true);
						canSlide = true;
						propertyChanged("canSlide", canSlide);
						actor.applyImpulse(0, 1, SlideAcceleration);
						print("Y Speed: " + actor.getYVelocity() + " Slope Grade: " + SlopeGrade);
						if((actor.getYVelocity() > (SlopeGrade + SlideSpeed)))
						{
							actor.setYVelocity((SlopeGrade + SlideSpeed));
						}
						if((actor.getYVelocity() < -((SlopeGrade + SlideSpeed))))
						{
							actor.setYVelocity(-((SlopeGrade + SlideSpeed)));
						}
					}
					else
					{
						actor.setActorValue("Is Slope Sliding?", false);
					}
					if((!(canSlide) && (!(isKeyDown(LeftControl)) && !(isKeyDown(RightControl)))))
					{
						if((!(SlideWhileDucking) || (SlideWhileDucking && !(isKeyDown(DuckControl)))))
						{
							actor.setXVelocity(0);
							actor.setX(oldX);
						}
					}
					if((isKeyReleased(LeftControl) || isKeyReleased(RightControl)))
					{
						actor.setYVelocity(0);
					}
				}
				else
				{
					actor.setActorValue("Is Slope Sliding?", false);
				}
				oldX = asNumber(actor.getX());
				propertyChanged("oldX", oldX);
				oldY = asNumber(actor.getY());
				propertyChanged("oldY", oldY);
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(event.collidedWithTile))
				{
					return;
				}
				for(point in event.points)
				{
					yNorm = asNumber(point.normal.y);
					propertyChanged("yNorm", yNorm);
					if (sameAs(event.actorB, actor)) yNorm = -(point.normal.y); 
					SlopeGrade = asNumber((100 - (yNorm * 100)));
					propertyChanged("SlopeGrade", SlopeGrade);
					if(EnableDebugging)
					{
						trace("" + (("" + "Slope Grade: ") + ("" + ("" + SlopeGrade))));
					}
					if((yNorm < 1))
					{
						touchedSlope = true;
						propertyChanged("touchedSlope", touchedSlope);
						if((SlopeGrade < (100 - (100 - MaxSlopeGrade))))
						{
							preventSlide = true;
							propertyChanged("preventSlide", preventSlide);
						}
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(EnableDebugging)
				{
					g.drawString("" + (("" + "On Slope: ") + ("" + ("" + onSlope))), 30, -60);
					g.drawString("" + (("" + "Prevent Sliding: ") + ("" + ("" + !(canSlide)))), 30, -30);
					g.drawString("" + asBoolean(actor.getActorValue("Is Slope Sliding?")), 30, -90);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}