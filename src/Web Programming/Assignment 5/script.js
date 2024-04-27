function checkWin() { 

	var b1, b2, b3, b4, b5, b6, b7, b8, b9; 
	b1 = document.getElementById("b1").value; 
	b2 = document.getElementById("b2").value; 
	b3 = document.getElementById("b3").value; 
	b4 = document.getElementById("b4").value; 
	b5 = document.getElementById("b5").value; 
	b6 = document.getElementById("b6").value; 
	b7 = document.getElementById("b7").value; 
	b8 = document.getElementById("b8").value; 
	b9 = document.getElementById("b9").value; 

	var b1btn, b2btn, b3btn, b4btn, b5btn, 
		b6btn, b7btn, b8btn, b9btn; 
		
	b1btn = document.getElementById("b1"); 
	b2btn = document.getElementById("b2"); 
	b3btn = document.getElementById("b3"); 
	b4btn = document.getElementById("b4"); 
	b5btn = document.getElementById("b5"); 
	b6btn = document.getElementById("b6"); 
	b7btn = document.getElementById("b7"); 
	b8btn = document.getElementById("b8"); 
	b9btn = document.getElementById("b9"); 
 
	if (((b1 == b2 && b2 == b3 && b1 != "") || 
    (b1 == b5 && b5 == b9 && b1 != "") || 
    (b1 == b4 && b4 == b7 && b1 != "") || 
    (b5 == b2 && b5 == b8 && b2 != "") || 
    (b7 == b5 && b5 == b3 && b3 != "") || 
    (b6 == b9 && b9 == b3 && b3 != "") || 
    (b4 == b5 && b5 == b6 && b4 != "") || 
    (b7 == b8 && b8 == b9 && b7 != "")))
 { 
		document.getElementById('print') .innerHTML = "Game over"
			b1btn.disabled = true; 
		b2btn.disabled = true; 
		b3btn.disabled = true; 
		b4btn.disabled = true; 
		b5btn.disabled = true; 
		b6btn.disabled = true; 
		b7btn.disabled = true; 
		b8btn.disabled = true; 
		b9btn.disabled = true; 
	} 
	else if (b1 != "" &&b2 != "" &&b3 != "" &&b4 != "" &&b5 != "" &&b6 != "" &&b7 != "" &&b8 != "" &&
	b9 != "") { 
		document.getElementById('print') 
			.innerHTML = "Draw"; 
} 
	else { 
			document.getElementById('print') 
				.innerHTML = "Player's Turn"; 
	} 
} 

function resetBoard() { 
	location.reload(); 
	b1 = b2 = b3 = b4 = b5 = b6 = b7 = b8 = b9 = ''; 
} 

function setxo(tile) { 
	document.getElementById(tile).value = "X";
    document.getElementById(tile).disabled = true;
    
    checkWin();
    
    var emptyTiles = [];
    for (var i = 1; i <= 9; i++) {
        if (document.getElementById("b" + i).value === "") {
            emptyTiles.push("b" + i);
        }
    }
    var randomIndex = Math.floor(Math.random() * emptyTiles.length);
    var botTile = emptyTiles[randomIndex];
    document.getElementById(botTile).value = "0";
    document.getElementById(botTile).disabled = true;
    
    checkWin();
} 
