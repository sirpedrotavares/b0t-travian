# b0t-travian
B0t-Travian in Ruby on bash terminal

![](https://clubetravian.files.wordpress.com/2011/08/cropped-travian4_banner1.jpg)

Hoje em dia existem determinados bots a operar diretamente via navegador de Internet, especialmente plugins para o Mozilla Firefox, que gerem de forma automatizada a sua conta do jogo de navegador travian (http://www.travian.pt).

Se é um jogador que pretende um bot com a seguinte especificação:

    A operar via bash num servidor remoto, por exemplo, em uma Virtual Machine (VM).
    
então este é um programa de computador ideal para controlar o seu jogo.

É um bot bastante primata, com funcionalidades como farming, retirar tropas da aldeia em caso ataque, enviar héroi para aventuras, etc.

O autor desta peça de software desenhou  o *bot* consoante as suas necessidades. Para correr basta deter uma máquina com o Ruby instalado (por exemplo, uma maquina com o sistema operativo Linux).

Antes da primeira execução devem ser efetuadas algumas configurações.

#Ficheiro [configurations.yml]

```python
#bot configurations
:execute_in_background:   true
:tribe:                   'gauleses' # options[gauleses,romanos,salteadores]
:user:                    'username'
:pwd:                     'password'
:url_base:                'http://ts5.travian.pt'
:home:                    'http://ts5.travian.pt/dorf1.php'
:logout:                  'http://ts5.travian.pt/logout.php'
:farm_save_trops:         'farm_save'
:url_farming:             'http://ts5.travian.pt/build.php?tt=2&id=39'
:limit_trop_to_farm:      '7'
:url_hero_adventure:      'http://ts5.travian.pt/hero_adventure.php'
:hero_adventure_active:   false
```
**tribe** – A sua tribo, gauleses, romanos ou salteadores.

**user** – O seu utilizador de jogo.

**pwd** – A sua palavra-passe de jogo.

**farm_save_trops** – Nome da aldeia para onde deseja enviar as tropas em caso de ataque.

**limit_trop_to_farm** – Limite de tropas por *farm* ( nesta configuração foram definidas 7 tropas em cada ataque).

Os restantes deverão ser alterados conforme o servidor, por exemplo, alterar **ts5** para **ts4**.

#Ficheiro [farmlist.yml]
```python
:farm1:   'Aldeia do NoobAMS'
:farm2:   'Aldeia do gali'
:farm3:   '...'
```

Neste ficheiro poderá adicionar todos os seus *farms*, mantendo a estrutura definida.

Inicalmente deve efetuar o comando:

    bundle install

, todas as gems serão instaladas na sua máquina.

Em seguida, para executar deve introduzir o seguinte comando no seu terminal:

    ruby bot.rb &

, este irá operar em *background* e gerar um histórico de operações para o ficheiro **log.log**.

Para consultar o *log* pode usar o seguinte comando via terminal:

    cat log.log

Exemplo do log:
```python
D, [2015-01-31T16:39:36.691985 #18158] DEBUG — :  Try start the bot at [2015-01-31 16:39:36].
D, [2015-01-31T16:39:36.692150 #18158] DEBUG — :  Loading configurations.
D, [2015-01-31T16:39:36.693616 #18158] DEBUG — :  Configs and farmlist loaded.
D, [2015-01-31T16:39:36.693727 #18158] DEBUG — :  Try to login.
D, [2015-01-31T16:39:51.503283 #18158] DEBUG — :  Login sucessful.
D, [2015-01-31T16:39:51.503553 #18158] DEBUG — :  Executing loop.
D, [2015-01-31T16:40:05.276853 #18158] DEBUG — :  Send troops (7 falanges) to farm Aldeia do NoobAMS.
D, [2015-01-31T16:40:19.504539 #18158] DEBUG — :  Send troops (7 falanges) to farm Aldeia do gali.
D, [2015-01-31T16:55:35.535188 #18158] DEBUG — :  Send troops (7 falanges) to farm Aldeia do NoobAMS.
D, [2015-01-31T16:55:49.915096 #18158] DEBUG — :  Send troops (7 falanges) to farm Aldeia do gali.
(...)
```

#Histórico de updates e funcionalidades

**Versão: 1.3**

Funcionalidades:

    -Farming,
    -Enviar héroi para aventuras,
    -Tribos disponíveis: Gauleses, Romanos e Salteadores,
    -Log de operações.

 
[**Visita: http://seguranca-informatica.pt**]
