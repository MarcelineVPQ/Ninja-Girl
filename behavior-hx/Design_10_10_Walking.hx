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



class Design_10_10_Walking extends ActorScript
{
	public var _MoveRightKey:String;
	public var _MoveLeftKey:String;
	public var _Acceleration:Float;
	public var _MaxWalkingSpeed:Float;
	public var _LimitSpeed:Bool;
	public var _WalkRightAnimation:String;
	public var _WalkLeftAnimation:String;
	public var _IdleRightAnimation:String;
	public var _IdleLeftAnimation:String;
	public var _PreventWalking:Bool;
	public var _DisableStatuses:Array<Dynamic>;
	public var _AnimationCategory:String;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AtMaxWalkingSpeed():Bool
	{
		var __Self:Actor = actor;
		if((asBoolean(actor.getActorValue("Facing Right?")) && (actor.getXVelocity() >= _MaxWalkingSpeed)))
		{
			if(_LimitSpeed)
			{
				actor.setXVelocity(_MaxWalkingSpeed);
			}
			return true;
		}
		if((!(asBoolean(actor.getActorValue("Facing Right?"))) && (actor.getXVelocity() <= -(_MaxWalkingSpeed))))
		{
			if(_LimitSpeed)
			{
				actor.setXVelocity(-(_MaxWalkingSpeed));
			}
			return true;
		}
		return false;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_WalkAccel(__Accel:Float):Void
	{
		var __Self:Actor = actor;
		_Acceleration = asNumber(__Accel);
		propertyChanged("_Acceleration", _Acceleration);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetWalkAccel():Float
	{
		var __Self:Actor = actor;
		return _Acceleration;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_MaxWalkSpeed(__MaxSpeed:Float):Void
	{
		var __Self:Actor = actor;
		_MaxWalkingSpeed = asNumber(__MaxSpeed);
		propertyChanged("_MaxWalkingSpeed", _MaxWalkingSpeed);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetMaxWalkSpeed():Float
	{
		var __Self:Actor = actor;
		return _MaxWalkingSpeed;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_PreventWalk(__Prevent:Bool):Void
	{
		var __Self:Actor = actor;
		_PreventWalking = __Prevent;
		propertyChanged("_PreventWalking", _PreventWalking);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_LimitSpeed(__Limit:Bool):Void
	{
		var __Self:Actor = actor;
		_LimitSpeed = __Limit;
		propertyChanged("_LimitSpeed", _LimitSpeed);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_SlowToMax(__Rate:Float):Void
	{
		var __Self:Actor = actor;
		if((Math.abs(__Self.getXVelocity()) > _MaxWalkingSpeed))
		{
			actor.setXVelocity((actor.getXVelocity() * __Rate));
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Move Right Key", "_MoveRightKey");
		nameMap.set("Move Left Key", "_MoveLeftKey");
		nameMap.set("Acceleration", "_Acceleration");
		_Acceleration = 85.0;
		nameMap.set("Max Walking Speed", "_MaxWalkingSpeed");
		_MaxWalkingSpeed = 20.0;
		nameMap.set("Limit Speed?", "_LimitSpeed");
		_LimitSpeed = false;
		nameMap.set("Walk Right Animation", "_WalkRightAnimation");
		nameMap.set("Walk Left Animation", "_WalkLeftAnimation");
		nameMap.set("Idle Right Animation", "_IdleRightAnimation");
		nameMap.set("Idle Left Animation", "_IdleLeftAnimation");
		nameMap.set("Prevent Walking?", "_PreventWalking");
		_PreventWalking = false;
		nameMap.set("Disable Statuses", "_DisableStatuses");
		nameMap.set("Animation Category", "_AnimationCategory");
		_AnimationCategory = "Walking";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs: ---------------------- */
		/* "On Ground?" -- <Boolean> Actor Level Attribute, from "On Ground" Behavior (required) */
		/* "Is Running?" -- <Boolean> Actor Level Attribute, from "Jumping" Behavior (NOT required) */
		/* "Is Ducking?" -- <Boolean> Actor Level Attribute, from "Ducking" Behavior (NOT required) */
		/* "Is Slope Sliding?" -- <Boolean> Actor Level Attribute, from "Slope Detection" Behavior (NOT required) */
		/* Outputs: --------------------- */
		/* "Facing Right?" -- <Boolean> Actor Level Attribute */
		actor.setActorValue("Facing Right?", true);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				for(item in cast(_DisableStatuses, Array<Dynamic>))
				{
					if(asBoolean(actor.getActorValue(("" + item))))
					{
						return;
					}
				}
				if(_PreventWalking)
				{
					return;
				}
				if((isKeyDown(_MoveRightKey) && !(isKeyDown(_MoveLeftKey))))
				{
					actor.setActorValue("Facing Right?", true);
					if(asBoolean(actor.getActorValue("On Ground?")))
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_WalkRightAnimation, _AnimationCategory]);
					}
					if(cast(actor.say("Walking", "_customBlock_AtMaxWalkingSpeed"), Bool))
					{
						return;
					}
					actor.push(1, 0, _Acceleration);
				}
				if((isKeyDown(_MoveLeftKey) && !(isKeyDown(_MoveRightKey))))
				{
					actor.setActorValue("Facing Right?", false);
					if(asBoolean(actor.getActorValue("On Ground?")))
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_WalkLeftAnimation, _AnimationCategory]);
					}
					if(cast(actor.say("Walking", "_customBlock_AtMaxWalkingSpeed"), Bool))
					{
						return;
					}
					actor.push(-1, 0, _Acceleration);
				}
				if((!(isKeyDown(_MoveRightKey)) && !(isKeyDown(_MoveLeftKey))))
				{
					if(asBoolean(actor.getActorValue("On Ground?")))
					{
						if(asBoolean(actor.getActorValue("Facing Right?")))
						{
							actor.say("Animation Manager", "_customBlock_LoopAnim", [_IdleRightAnimation, _AnimationCategory]);
						}
						else
						{
							actor.say("Animation Manager", "_customBlock_LoopAnim", [_IdleLeftAnimation, _AnimationCategory]);
						}
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}