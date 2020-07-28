extends Node2D

# Cria o objeto serial
const SERCOMM = preload("res://bin/GDsercomm.gdns")
onready var PORT = SERCOMM.new()

# Cria uma lista com todas as portas presentes na maquina
onready var port_list = PORT.list_ports()

# Interface visual
onready var RecevedMessages = $RecevedMessages
onready var SendMessage = $SendMessage

# Configuração Inicial
func _ready():
	# Desabilita o physics_process até que uma porta esteja aberta
	set_physics_process(false)
	
	# Aguarda um frame, para que as funções do onready sejam executadas
	yield(get_tree(),"idle_frame")
	
	# Abre a Porta COM1
	open_port('COM1');


func _physics_process(delta):
	# Verifica se recebeu algum dado
	if PORT.get_available()>0:
		# Se recebeu, então adiciona a tela de msg recebidas
		RecevedMessages.add_text(PORT.read())
	pass
		
		

# Abre uma Porta
func open_port(port_name, baudrate=9600):
	# Se houver alguma porta aberta, fecha
	PORT.close()
	
	# Verifica se o nome do port existe
	if port_name!=null:
		# Tenta abrir a porta por 1000ms
		PORT.open(port_name, baudrate,1000)
	# pressupõe que a porta foi aberta e habilita a physics_process
	# para receber dados externos
	set_physics_process(true)

# Quando pressionar o botão
func _on_Button_pressed():
	# Envia a mensage	
	PORT.write(SendMessage.text)
	
	# Apaga a caixa de texto
	SendMessage.text = ""
