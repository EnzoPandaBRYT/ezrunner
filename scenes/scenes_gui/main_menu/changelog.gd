extends Node2D

@onready var notes: RichTextLabel = $changelogs/version_list/rich_label

var changelogs_opened = false

var changelogs := {
	"0.7.0": {
		"title": "Versão 0.7.0",
		"notes": "[center][font_size=32][b]RUNNER - Versão 0.7.0[/b][/font_size]\n" +
			"[color=#A99AFF]Atualização de conteúdo e melhorias[/color][/center]\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]COMBATE[/color][/b][/font_size]\n\n" +
			"[b]Barras de vida[/b]\n" +
			"• As barras de vida dos inimigos só aparecem após receberem dano.\n\n" +
			"[b]Torretim[/b]\n" +
			"• Agora é possível rebater seus projéteis, eliminando-o instantaneamente!\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]DIÁLOGOS[/color][/b][/font_size]\n\n" +
			"• Avance as falas manualmente ou revele uma linha inteira de uma vez.\n" +
			"• As ações que dependem do fim de um diálogo não precisam mais de temporizadores fixos.\n" +
			"• O nome do personagem que está falando aparece no canto superior esquerdo.\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]MAPA E LEVEL DESIGN[/color][/b][/font_size]\n\n" +
			"[b]Primeiro mapa pós-tutorial concluído![/b]\n\n" +
			"• Novos desafios e mecanismos foram adicionados ao mapa.\n" +
			"• Alavancas ativam mecanismos espalhados pelo cenário.\n" +
			"• Portas podem exigir a ativação de mecanismos para serem desbloqueadas.\n" +
			"• Alçapões foram adicionados ao cenário.\n" +
			"• Objetos interagíveis recebem uma borda branca quando podem ser utilizados.\n" +
			"• Caixas destrutíveis podem ser quebradas com socos.\n" +
			"• O gancho permite impulsionar saltos no ar.\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]INTERFACE E CONFIGURAÇÕES[/color][/b][/font_size]\n\n" +
			"• O menu de pausa agora exibe corretamente as porcentagens de volume e efeitos sonoros.\n" +
			"• Os tutoriais indicam corretamente os botões dos controles de PlayStation.\n" +
			"• Não é mais possível pausar durante um tutorial, evitando problemas na exibição de suas etapas.\n\n" +
			"[hr]\n" +
			"[center][color=#A99AFF]Obrigado por jogar RUNNER![/color][/center]"
	},
	"0.6.3": {
		"title": "Versão 0.6.3",
		"notes": "[center][font_size=32][b]RUNNER - Versão 0.6.3[/b][/font_size]\n" +
			"[color=#A99AFF]Novos inimigos e melhorias na jogabilidade[/color][/center]\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]COMBATE[/color][/b][/font_size]\n\n" +
			"[b]Torretim adicionado![/b]\n\n" +
			"• Novo inimigo especializado em ataques à distância.\n" +
			"• Seus projéteis causam 4 pontos de dano.\n" +
			"• Os projéteis se dissipam após até 3 segundos no ar.\n" +
			"• O Torretim permanece imóvel durante o combate.\n" +
			"• Possui 2 pontos de vida, menos que o Batch.\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#C4B5FD]JOGABILIDADE[/color][/b][/font_size]\n\n" +
			"[b]Drops de vida[/b]\n\n" +
			"• Inimigos agora podem deixar orbes de vida ao morrer.\n" +
			"• Cada orbe restaura entre 3 e 5 pontos de vida do jogador.\n\n" +
			"[b]Diálogos adicionados![/b]\n\n" +
			"• Agora é possível conversar com personagens em Shadowlands.\n" +
			"• Experimente conversar com o Yellowmita!\n\n" +
			"[hr]\n" +
			"[font_size=18][b][color=#FFB86C]BUGS CONHECIDOS[/color][/b][/font_size]\n\n" +
			"• O menu de pausa pode exibir porcentagens incorretas de volume e efeitos sonoros.\n" +
			"• Pausar durante animações ou tutoriais pode causar problemas na exibição.\n" +
			"• Os diálogos apresentam um erro que pode causar o fechamento inesperado do jogo (crash).\n\n" +
			"[hr]\n" +
			"[center][color=#A99AFF]Obrigado por jogar RUNNER![/color][/center]"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_version_button_pressed() -> void:
	if changelogs_opened:
		hide_all()
		changelogs_opened = false
	else:
		show_all()
		show_version("0.7.0")
		$changelogs/version_list/version063.show()
		changelogs_opened = true
		
	
func _on_close_changelogs_pressed() -> void:
	hide_all()
	changelogs_opened = false

func show_all():
	$changelogs.show()
	$close_changelogs.show()
	$title.show()

func hide_all():
	$changelogs.hide()
	$close_changelogs.hide()
	$title.hide()


func _on_version_070_pressed() -> void:
	show_version("0.7.0")
	$changelogs/version_list/version063.show()
	
func _on_version_063_pressed() -> void:
	show_version("0.6.3")
	$changelogs/version_list/version063.hide()

func show_version(version: String) -> void:
	if not changelogs.has(version):
		return

	notes.text = changelogs[version]["notes"]
