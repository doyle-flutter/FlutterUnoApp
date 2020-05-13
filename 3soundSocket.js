var app = require('express')(),
    http = require('http').Server(app),
    io = require('socket.io')(http),
    five = require("johnny-five"),
    board = new five.Board();

app.get('/', function(req, res){ 
    res.send("hi"); 
}); 

io.on('connection', (socket) => {
    board.on('ready', ()=> {
        var sound = new five.Sensor("A0",450);
        sound.on('change', () => {
            var checkSound = sound.scaleTo(0,500);
            
            if(checkSound < 250){
                
            }
            else{
                
                io.emit('receive_message', "Sssss")
                console.log("큰소리가 발생하고 있습니다");
            }
        })
            
    });
});

http.listen(3000, function(){ console.log('listening on *:3000'); });
