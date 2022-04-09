#Luiz Rodrigo Lacé Rodrigues, DRE:118049873
#Livia Barbosa Fonseca, DRE:118039721

#Importando a biblioteca ruby 2d
require 'ruby2d'

#Printando mensagens de boas vindas e introdução do game of life
puts "----------> SEJA BEM VINDO AO GAME OF LIFE"
puts"\nO Game of Life é um autómato celular desenvolvido pelo matemático John Horton Conway. Esse autômato foi criado de modo a reproduzir, através de regras simples, as alterações e mudanças em grupos de seres vivos, tendo aplicações em diversas áreas da ciência. As regras definidas são aplicadas a cada nova geração; assim, a partir de uma imagem em um tabuleiro bi-dimensional definida pelo jogador, percebem-se mudanças muitas vezes inesperadas e belas a cada nova geração, variando de padrões fixos a caóticos."

#Printando as regras do game of life
puts"\n-> As regras do Game of Life são as seguintes:
          1 - Qualquer célula viva com menos de dois vizinhos vivos morre de solidão;
          2 - Qualquer célula viva com mais de três vizinhos vivos morre de superpopulação;
          3 - Qualquer célula morta com exatamente três vizinhos vivos se torna uma célula viva;
          4 - Qualquer célula viva com dois ou três vizinhos vivos continua no mesmo estado para a próxima geração.
"
#Printando as funcionalidades do protótipo
puts"\n-> Funcionalidades do protótipo são:
          1 - Clicando na tecla 'p' o jogo é iniciado ou pausado;
          2 - Clicando na tecla 'l' o grid é limpo.
"

#Realizando o input do tamanho do grid
print "\nDigite a largura do grid: "
v1 = gets.chomp.to_i
print "\nDigite a altura do grid: "
v2 = gets.chomp.to_i

#Realizando o input da velocidade da animação
print"\nDigite a velocidade de visualização do jogo (1 à 10): "
v3 = gets.chomp.to_i

#Realizando o input da escolha do tipo do jogo (aleatório ou manual)
print"\n(1 - Automatico, 0 - Manual): "
v4 = gets.chomp.to_i

#Definindo a cor de fundo do grid 
set background: 'white'

#Definindo o tamanho dos quadrados do grid
TAMANHO_QUADRADO = 40

#Definindo as variáves de tamanho da janela, baseado no tamanho do quadrado do grid
set width: TAMANHO_QUADRADO * v1
set height: TAMANHO_QUADRADO * v2

#Classe responsável em desenhar o grid
class Grid
  #Método auxiliar que realiza a iniciação de alguns atributos do jogo, o hash do grid e o status do jogo (pausado ou não)
  def initialize
    @grid = {}
    @playing = false      
  end

  #Método randomiza as celulas vivas
  def auto
    #Definindo um novo hash
    new_grid = { }
    #Looping entre todos os quadrados do grid
    (Window.width / TAMANHO_QUADRADO).times do |x|
      (Window.height / TAMANHO_QUADRADO).times do |y|
        #Variável que sorteia um número de 0 a 9
        randNum = rand(10)
        #Tornando uma celula viva com 50% de chance
        if(randNum >= 5)
          new_grid[[x, y]] = true
        end
      end
    end
    #Atualizando o grid principal
    @grid = new_grid
  end

  #Método que remove todos os pares de valores-chave do grid
  def clear
    @grid = { }
  end

  #Método que faz a pausa e o inicio do jogo
  def play_pause
    @playing = !@playing
  end

  #Método que irá desenhar o grid
  def desenha_grid
    #Lopping que realiza o desenho das linhas verticais do grid. As linhas começam do topo e vão até a parte inferior da janela,
    #todas mantendo uma distância definida anteriormente.
    (Window.width / TAMANHO_QUADRADO).times do |x|
      #Definindo os atributos de cada linha vertical do grid
      Line.new(
        #Espessura da linha
        width: 1,
        #Cor da linha
        color: 'black',
        #Definindo onde a linha começa e termina
        y1: 0,
        y2: Window.height,
        x1: x * TAMANHO_QUADRADO,
        x2: x * TAMANHO_QUADRADO,
      )
      #Lopping que realiza o desenho das linhas horizontais do grid. Essas linhas começam do inicio da janela definida e vão até o seu final,
      #todas mantendo uma distância definida anteriormente.
      (Window.height / TAMANHO_QUADRADO).times do |y|
        #Definindo os atributos de cada linha horizontal do grid
        Line.new(
          #Espessura da linha
          width: 1,
          #Cor da linha
          color: 'black',
          #Definindo onde a linha começa e termina
          x1: 0,
          x2: Window.width,
          y1: y * TAMANHO_QUADRADO,
          y2: y * TAMANHO_QUADRADO,
        )
      end
    end

    #Método que recebe uma coordenada x e y dada pelo jogador no grid e faz a alternância entre célula viva e morta
    def marcar(x, y)
      #Se o valor fornecido estiver presente para alguma chave em hash, então esses dados são apagados.
      #Ou seja, se o jogador apertar em uma célula que já estava viva, ela morre
      if @grid.has_key?([x, y])
        @grid.delete([x, y])
      #Caso contrário, se o jogador clicar em uma célula morta, ela vive
      else
        @grid[[x, y]] = true
      end
    end

    #Método que realiza a pintura das células vivas
    def desenha_celulas_vivas
      #Lopping que percorre o hash do grid(coordenadas x e y selecionadas) para pintar as celulas vivas. 
      ###.keys - Retorna uma nova matriz preenchida com as chaves deste hash
      ###.each - Chama o bloco uma vez para cada chave em hsh, passando o par de valores-chave como parâmetros.
      @grid.keys.each do |x, y|
        #Definindo os atributos de cada quadrado (célula)
        Square.new(
          #Definindo a cor
          color: 'black',
          #Definindo o tamanho e posição
          x: x * TAMANHO_QUADRADO,
          y: y * TAMANHO_QUADRADO,
          size: TAMANHO_QUADRADO
        )
      end
    end

    #Método que mostra qual célula vive e qual morre de acordo com as regras do jogo "game of life" (calcula o próximo frame)
    def life
      #Quando o jogo está ativo (animado)
      if @playing
        #Criando um novo hash do grid
        new_grid = {}

        #Lopping entre todas as células do grid
        (Window.width / TAMANHO_QUADRADO).times do |x|
          (Window.height / TAMANHO_QUADRADO).times do |y|
          
            #Se o valor fornecido estiver presente para alguma chave em hash temos que a célula está viva (true), caso contrário, ela está morta (false)

            vivo = @grid.has_key?([x, y])  

            #Array que contém as informações sobre o estado das vizinhaças de uma célula (vivas ou mortas)
            vizinhos_vivos = [
              #Analizando cada uma das 8 vizinhanças (true = viva, false = morta)
              @grid.has_key?([x-1, y-1]), # Cima esquerda
              @grid.has_key?([x  , y-1]), # Cima
              @grid.has_key?([x+1, y-1]), # Cima direita
              @grid.has_key?([x+1, y  ]), # Direita
              @grid.has_key?([x+1, y+1]), # Baixo direita
              @grid.has_key?([x  , y+1]), # Baixo
              @grid.has_key?([x-1, y+1]), # Baixo esquerda
              @grid.has_key?([x-1, y  ]), # Esquerda
              #Contando quantas vizinhanças estão vivas para determinada célula
            ].count(true)

            #Se a célula selecionada está viva e possui 2 ou 3 vizinhanças vivas ou se a célula selecionada não está viva e possui exatamente 3 vizinhanças vivas,
            # iremos fazer uma nova entrada no novo grid 
            if((vivo && vizinhos_vivos.between?(2,3)) || (!vivo && vizinhos_vivos == 3))
              #Setando o novo grid como verdadeiro
              new_grid[[x, y]] = true
            end
          end
        end
        #Substituir o grid novo para o antigo para continuar o looping (animação)
        @grid = new_grid
      end
    end
  end
end

#daqui pra baixo é a "main"

#Criando um objeto do tipo Grid
grid = Grid.new

#Verificando o tipo do jogo selecionado (aleatório ou manual) e chamando o método que realiza o inicio do jogo aleatório
if(v4 == 1)
  grid.auto
end

#Looping de atualização que da vida a janela do jogo 
update do
  #Chamando os métodos da classe Grid
  clear
  grid.desenha_grid
  grid.desenha_celulas_vivas

  #Alterando a velocidade da animação
  if Window.frames % (100 - (v3 * 8)) == 0
    grid.life
  end
end

#Capturando eventos quando um botão do mouse é apertado
on :mouse_down do |event|
  grid.marcar(event.x / TAMANHO_QUADRADO, event.y / TAMANHO_QUADRADO)
end

#Capturando eventos quando uma tecla do teclado é pressionada
on :key_down do |event|
  #Se o usuário apertar a tecla 'p' o jogo é pausado
  if event.key == 'p'
    grid.play_pause
  end

  #Se o usuário apertar a tecla 'c' o grid do jogo é limpo
  if event.key == 'l'
    grid.clear
  end
end

#Mostrando na tela
show