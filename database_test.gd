extends Node
class_name UpstashDatabase

@onready var rest_url = "https://cheerful-cougar-87914.upstash.io"
@onready var rest_token = "gQAAAAAAAVdqAAIncDE3NTNhZGU1NGQ1MmY0OGVlOTVhZDM2NjVlOTRhZTA2ZnAxODc5MTQ"

@onready var http_request = $HTTPRequest

signal request_answer(value)

func _ready():
	# Connect the signal to see the result
	http_request.request_completed.connect(_on_request_completed)
	
	# Example: Save the string "Hello Godot" to the key "player_name"
	
	await save_highscore("Michi",10)
	await save_highscore("Gabl",10)
	await save_highscore("Michi",10)
	await save_highscore("Julia",10)
	
	print(await get_all_highscores())


func save_highscore(player_name:String, score:float):
	var url = rest_url + "/hset/ClimbingHighScore/" + player_name + "/" + str(score).pad_decimals(2)
	
	var headers = [
		"Authorization: Bearer " + rest_token
	]
	
	# Upstash SET commands use POST
	var error =  http_request.request(url, headers, HTTPClient.METHOD_POST)
	
	if error != OK:
		print("An error occurred in the HTTP request.")
		print(error)
	
	await get_tree().create_timer(0.5).timeout

func get_all_highscores():
	# URL format: URL/hgetall/YOUR_HASH_ID
	var url = rest_url + "/hgetall/ClimbingHighScore"
	
	var headers = [
		"Authorization: Bearer " + rest_token
	]
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	
	if error != OK:
		print("Error starting HGETALL request")
	
	var request_string = await request_answer
	var output = {}
	var switch := false
	for i in range(request_string.size()-1):
		switch = not switch
		if switch:
			output.set(request_string[i],request_string[i+1])
	
	return output
	

# Update your existing signal handler to handle the GET response
func _on_request_completed(_result, response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code == 200:
		# Upstash returns a JSON object. The actual value is in the "result" field.
		if json and json.has("result"):
			var saved_value = json["result"]
			if saved_value == null:
				print("Key not found in database.")
			else:
				request_answer.emit(saved_value)
	else:
		print("Error: ", response_code, " - ", body.get_string_from_utf8())
