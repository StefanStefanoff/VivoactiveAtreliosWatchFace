using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Activity as Activity;
using Toybox.Math as Math;

class Vivoactive3WatchFaceView extends WatchUi.WatchFace {
	var moonPhase = false;
	var pressure = null;
	var lastHr = 0;
	var hrUpdateInterval = 30;//seconds
	var dateSet = null;
	var batterySet = null;
	var altitude = null;
	var movement = null;
	
	var time, hrText, diText, prText, alText, moon, stepsGoal, steps, date, battery;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        time = View.findDrawableById("time");
        hrText = View.findDrawableById("hr");
        diText = View.findDrawableById("dist");
        prText = View.findDrawableById("pressure");
        alText = View.findDrawableById("altitude");
        moon = View.findDrawableById("moon");
        stepsGoal = View.findDrawableById("stepsGoal");
        steps = View.findDrawableById("steps");
        date = View.findDrawableById("date");
        battery = View.findDrawableById("batteryPercent");
        movement = View.findDrawableById("movement");
                
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	dc.clearClip();
    	
    	var hour = System.getClockTime().hour;
    	var min = System.getClockTime().min; 
    	var sec = System.getClockTime().sec;
    	
    	var activityInfo = Activity.getActivityInfo();
    	var info = ActivityMonitor.getInfo();
    	
    	var moveBarLevel = info.moveBarLevel; //0..5

    	var mvtTxt = "";
    	for (var i = 0; i < moveBarLevel; i++) {
    		if (i == 0) {
    			mvtTxt += "-";
    		} else {
    			mvtTxt += "-";
    		}
		}
    	
    	movement.setText(mvtTxt);
    	
        // Get and show the current time
        var timeString = Lang.format("$1$:$2$", [hour.format("%02d"), min.format("%02d")]);
        time.setText(timeString);

		// Get current heartRate and show it
		var currentHr = activityInfo.currentHeartRate;
		if (currentHr != null) {
			hrText.setText(Lang.format("$1$", [currentHr]));
		} else {
			hrText.setText("-");
		}
		
		var distance = (info != null && info.distance != null) ? info.distance.toFloat() : 0;
		var distanceKm = (distance/100000).format("%2.1f");
		diText.setText(distanceKm);
		
		// Get current pressure and show it
		if (pressure == null || min == 0 && sec == 0) {
			pressure = activityInfo.ambientPressure;
			if (pressure != null) {
				prText.setText(Lang.format("$1$", [Math.floor(pressure/100).toLong()]));
			} else {
				prText.setText("-");
			}
		}
		
		// Get current altitude and show it
		altitude = activityInfo.altitude;
		if (altitude != null) {
			alText.setText(Lang.format("$1$", [Math.floor(altitude).toLong()]));
		} else {
			alText.setText("-");
		}
		
		// Get MoonPhase and show it
		if (moonPhase == false || (hour % 3 == 0) && min == 0 && sec == 0) {
			moonPhase = (getMoonPhase(Time.now())).toChar().toString();
			moon.setText(moonPhase);
		}    
		
		stepsGoal.setText(info.stepGoal.toString());
		steps.setText(info.steps.toString());
		
		if (dateSet == null || hour == 0 && min == 0 && sec == 0) {
			var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
			var dateString = Lang.format(
			    "$1$ $2$ $3$ $4$",
			    [
			        today.day_of_week,
			        today.month,
			        today.day,
			        today.year
			    ]
			);
			dateSet = dateString;
			date.setText(dateSet);
		}
		
    	if (batterySet == null || min % 5 == 0 && sec == 0) {
    		batterySet = Lang.format("$1$%", [System.getSystemStats().battery.toLong()]);
	    	battery.setText(batterySet);
    	}
	    
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function getMoonPhase(timeNow) {
		var JD = timeNow.value().toDouble() / Gregorian.SECONDS_PER_DAY.toDouble() + 2440587.500d;
    	var IP = Normalize((JD.toDouble() - 2451550.1d) / 29.530588853d);
    	var Age = IP * 29.53d;
    	var phase = 0;

        return (96 + 26*(Age/29.53)).toNumber();
	}
	
	static function Normalize(value)
    {
    	var nValue = value - Math.floor(value);
    	if (nValue < 0)
    	{
    		nValue = nValue + 1;
    	}
    	return nValue;
    }
}
