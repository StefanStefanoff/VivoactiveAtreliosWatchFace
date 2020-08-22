using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class BluetoothIndicator extends Ui.Drawable {
    hidden var x, y, bluetooth = null;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
    	var w = 15;
    	
    	if (bluetooth == null || System.getClockTime().sec == 0) {
    		bluetooth = System.getDeviceSettings().phoneConnected;
    	}
    	
    	var color = Gfx.COLOR_RED;
    	if (bluetooth == true) {
    		color = Gfx.COLOR_BLUE;
    	}
    	
    	drawBtIcon(dc, x, y, 1.4, 0, color);
    }
    
    function drawBtIcon(dc, centerX, centerY, symbolScale, radius, color) {
    	dc.setPenWidth(2);
	    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
		var btSymbol = [ [0, 9], [6, 3], [3, 0], [3, 12], [6, 9], [-1, 2] ];
		for (var i = 0; i < btSymbol.size() - 1; i++) {
			dc.drawLine(symbolScale * btSymbol[i][0] + centerX - 15,
			            symbolScale * btSymbol[i][1] + centerY - radius / 1.6,
			            symbolScale * btSymbol[i + 1][0] + centerX - 15,
			            symbolScale * btSymbol[i + 1][1] + centerY - radius / 1.6);
		}
		dc.setPenWidth(1);
    }
}