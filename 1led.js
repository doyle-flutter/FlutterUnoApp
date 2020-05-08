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

io.on('connection', function(socket){ 
    board.on('ready',() => {
        var led = new five.Led(13);
        socket.on('send_message', function(msg){ 
            console.log(msg);
            led.toggle();
            io.emit('receive_message', msg); 
        });
        
    });
     
});
