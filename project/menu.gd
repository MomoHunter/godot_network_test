extends Control


const PORT = 35565

var peer
var loaded_image = ImageTexture.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	var image = Image.new()
	image.load("res://test_pic.png")
	loaded_image.create_from_image(image)


func _on_CreateButton_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, 3)
	get_tree().set_network_peer(peer)
	$VBoxContainer/CreateButton.set_disabled(true)


func _on_JoinButton_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client($VBoxContainer/LineEdit.get_text(), PORT)
	get_tree().set_network_peer(peer)


func _connected_to_server():
	print("connected to server")


func _player_connected(id):
	print("player connected")
	rpc_id(id, "_get_that_shit", loaded_image.get_data().save_png_to_buffer())


func _connection_failed():
	print("connection failed")


func _player_disconnected(_id):
	print("player disconnected")


func _server_disconnected():
	print("server disconnected")


remote func _get_that_shit(picture_data):
	var image = Image.new()
	var image_texture = ImageTexture.new()
	image.load_png_from_buffer(picture_data)
	image_texture.create_from_image(image)
	$TextureRect.set_texture(image_texture)
