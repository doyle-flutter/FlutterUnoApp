var app = require('express')(),
    http = require('http').Server(app),
    io = require('socket.io')(http),
    five = require("johnny-five"),
    board = new five.Board();

app.get('/', function(req, res){ 
    res.send("hi"); 
}); 
app.get("/chat",(req,res) =>{
    res.sendFile('.../index.html');
});

// board.on('ready',() => {
//     var lcd = new five.LCD({ pins: [7, 8, 9, 10, 11, 12], controller: "PCF8574" });
//     lcd.print("Hello");
// });

io.on('connection', function(socket){ 
    board.on('ready',() => {
        var key;
        var lcd = new five.LCD({ pins: [7, 8, 9, 10, 11, 12], controller: "PCF8574" });
        // var led = new five.Led(13);
        socket.on('send_message', function(msg){ 

            console.log(msg);
            lcd.clear();
            if(msg['name'] !== "Piter"){
                key = "James : ";
            }
            else{
                key = "Piter : ";
            }
            lcd.print(key+msg['message']);
                                                                                                                        
            // led.toggle();    
            io.emit('receive_message', msg); 
        });
        
    });
     
});


http.listen(3000, function(){ console.log('listening on *:3000'); });
