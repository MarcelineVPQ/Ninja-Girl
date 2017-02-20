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



class Design_1_1_AnimationManager extends ActorScript
{
	public var _PlayingOneTime:Bool;
	public var _CurrentCategory:String;
	public var _DefaultRightAnimation:String;
	public var _DefaultLeftAnimation:String;
	public var _CategoryHierarchy:Array<Dynamic>;
	public var _CurrentIndex:Bool;
	public var _RequestedIndex:Bool;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_PlayOnce(__Animation:String):Void
	{
		var __Self:Actor = actor;
		actor.setAnimation("" + __Animation);
		_PlayingOneTime = true;
		propertyChanged("_PlayingOneTime", _PlayingOneTime);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_LoopAnim(__Animation:String, __Category:String):Void
	{
		var __Self:Actor = actor;
		if(_PlayingOneTime)
		{
			return;
		}
		if(!hasValue(_CurrentCategory))
		{
			_CurrentCategory = __Category;
			propertyChanged("_CurrentCategory", _CurrentCategory);
		}
		_CurrentIndex = false;
		propertyChanged("_CurrentIndex", _CurrentIndex);
		_RequestedIndex = false;
		propertyChanged("_RequestedIndex", _RequestedIndex);
		for(item in cast(_CategoryHierarchy, Array<Dynamic>))
		{
			if((item == __Category))
			{
				_RequestedIndex = true;
				propertyChanged("_RequestedIndex", _RequestedIndex);
			}
			if((item == _CurrentCategory))
			{
				_CurrentIndex = true;
				propertyChanged("_CurrentIndex", _CurrentIndex);
			}
			if((_CurrentIndex && !(_RequestedIndex)))
			{
				return;
			}
		}
		actor.setAnimation("" + __Animation);
		_CurrentCategory = __Category;
		propertyChanged("_CurrentCategory", _CurrentCategory);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_ClearCat():Void
	{
		var __Self:Actor = actor;
		_CurrentCategory = getDefaultValue(_CurrentCategory);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetCat():String
	{
		var __Self:Actor = actor;
		return _CurrentCategory;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_CategorySameAs(__CheckCategory:String):Bool
	{
		var __Self:Actor = actor;
		return (__CheckCategory == _CurrentCategory);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_ClearAnimCat(__ChkCat:String):Void
	{
		var __Self:Actor = actor;
		if((__ChkCat == _CurrentCategory))
		{
			_CurrentCategory = getDefaultValue(_CurrentCategory);
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Playing One Time?", "_PlayingOneTime");
		_PlayingOneTime = false;
		nameMap.set("Current Category", "_CurrentCategory");
		_CurrentCategory = "";
		nameMap.set("Default Right Animation", "_DefaultRightAnimation");
		nameMap.set("Default Left Animation", "_DefaultLeftAnimation");
		nameMap.set("Category Hierarchy", "_CategoryHierarchy");
		_CategoryHierarchy = ["Ground Pounding", "Ducking", "Wall Sliding", "Falling", "Wall Jumping", "Air Jumping", "Jumping", "Running", "Walking"];
		nameMap.set("Current Index", "_CurrentIndex");
		_CurrentIndex = false;
		nameMap.set("Requested Index", "_RequestedIndex");
		_RequestedIndex = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_PlayingOneTime)
				{
					if(!(actor.isAnimationPlaying()))
					{
						_PlayingOneTime = false;
						propertyChanged("_PlayingOneTime", _PlayingOneTime);
					}
					else
					{
						return;
					}
				}
				if(!hasValue(_CurrentCategory))
				{
					if(asBoolean(actor.getActorValue("Facing Right?")))
					{
						actor.setAnimation("" + _DefaultRightAnimation);
					}
					else
					{
						actor.setAnimation("" + _DefaultLeftAnimation);
					}
					return;
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}