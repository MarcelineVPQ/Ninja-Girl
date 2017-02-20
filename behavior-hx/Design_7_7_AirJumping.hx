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



class Design_7_7_AirJumping extends ActorScript
{
	public var _PreventAirJump:Bool;
	public var _CurrentJumps:Float;
	public var _CanJump:Bool;
	public var _ElapsedTime:Float;
	public var _OldY:Float;
	public var _MaxJumps:Float;
	public var _JumpKey:String;
	public var _MustBeRising:Bool;
	public var _JumpForce:Float;
	public var _JumpRightAnimation:String;
	public var _JumpLeftAnimation:String;
	public var _AnimationCategory:String;
	public function _customEvent_CheckPosition():Void
	{
		if((_CanJump && (actor.getY() > _OldY)))
		{
			_ElapsedTime += getStepSize();
			if((_ElapsedTime >= 150))
			{
				_CanJump = false;
				propertyChanged("_CanJump", _CanJump);
			}
		}
		if((actor.getY() < _OldY))
		{
			_CanJump = true;
			propertyChanged("_CanJump", _CanJump);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_PreventAirJump(__Prevent:Bool):Void
	{
		var __Self:Actor = actor;
		_PreventAirJump = __Prevent;
		propertyChanged("_PreventAirJump", _PreventAirJump);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Prevent Air Jump?", "_PreventAirJump");
		_PreventAirJump = false;
		nameMap.set("Current Jumps", "_CurrentJumps");
		_CurrentJumps = 0.0;
		nameMap.set("Can Jump?", "_CanJump");
		_CanJump = false;
		nameMap.set("Elapsed Time", "_ElapsedTime");
		_ElapsedTime = 0.0;
		nameMap.set("Old Y", "_OldY");
		_OldY = 0.0;
		nameMap.set("Max Jumps", "_MaxJumps");
		_MaxJumps = 999.0;
		nameMap.set("Jump Key", "_JumpKey");
		nameMap.set("Must Be Rising?", "_MustBeRising");
		_MustBeRising = false;
		nameMap.set("Jump Force", "_JumpForce");
		_JumpForce = 50.0;
		nameMap.set("Jump Right Animation", "_JumpRightAnimation");
		nameMap.set("Jump Left Animation", "_JumpLeftAnimation");
		nameMap.set("Animation Category", "_AnimationCategory");
		_AnimationCategory = "Air Jumping";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs:---------------------- */
		/* "Is Jumping?" -- Actor Level Attribute, from Behavior "Jumping" (required) */
		/* Outputs:--------------------- */
		/* "Is Air Jumping?" -- <Boolean> Actor Level Attribute */
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* Prevent Air Jump can be set via a custom block by other Behaviors that may want to temporarily prevent Air Jumping */
				if(_PreventAirJump)
				{
					return;
				}
				if(!(asBoolean(actor.getActorValue("Is Jumping?"))))
				{
					_CurrentJumps = asNumber(0);
					propertyChanged("_CurrentJumps", _CurrentJumps);
					_ElapsedTime = asNumber(0);
					propertyChanged("_ElapsedTime", _ElapsedTime);
					_CanJump = false;
					propertyChanged("_CanJump", _CanJump);
				}
				if(asBoolean(actor.getActorValue("Is Air Jumping?")))
				{
					if((asBoolean(actor.getActorValue("On Ground?")) || asBoolean(actor.getActorValue("Is Falling?"))))
					{
						actor.setActorValue("Is Air Jumping?", false);
						actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
					}
				}
				/* Check if the Actor is rising or falling */
				_customEvent_CheckPosition();
				if((isKeyPressed(_JumpKey) && (_CurrentJumps < _MaxJumps)))
				{
					if(asBoolean(actor.getActorValue("Is Jumping?")))
					{
						if((_MustBeRising && !(_CanJump)))
						{
							return;
						}
						runLater(1000 * 0.05, function(timeTask:TimedTask):Void
						{
							actor.setActorValue("Is Air Jumping?", true);
							if(asBoolean(actor.getActorValue("Facing Right?")))
							{
								actor.say("Animation Manager", "_customBlock_LoopAnim", [_JumpRightAnimation, _AnimationCategory]);
							}
							else
							{
								actor.say("Animation Manager", "_customBlock_LoopAnim", [_JumpLeftAnimation, _AnimationCategory]);
							}
						}, );
						actor.setYVelocity(0);
						actor.applyImpulse(0, -1, _JumpForce);
						_CurrentJumps += 1;
					}
				}
				_OldY = asNumber(actor.getY());
				propertyChanged("_OldY", _OldY);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}