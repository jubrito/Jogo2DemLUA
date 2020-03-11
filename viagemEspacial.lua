-- title: Space Travel
-- author: Juliana Witzke de Brito
-- desc: Grab the fuel and avoid the meteor
-- script: lua
-- input: arrow keys
		
-- OFICINA DE JOGOS 2D COM LUA
-- LAB DAS MINAS 


objetos = {

}

Constantes = {

			Direcao = {
			CIMA = 1,
			BAIXO = 2,
			ESQUERDA = 3,
			DIREITA = 4
			},
			
   LARGURA_DA_TELA = 240,
   ALTURA_DA_TELA = 138,
			VELOCIDADE_ANIMACAO_JOGADOR = 0.1,
			
			SPRITE_CHAVE = 364,
			SPRITE_PORTA = 155,
			SPRITE_INIMIGO = 324,
			BLOCO_PAREDE = 127,
			
			INIMIGO = "Asteroide"
}

---------------------------------------------
function temColisaoComMapa(ponto)
		blocoX = ponto.x/8
		blocoY = ponto.y/8
		blocoId = mget(blocoX, blocoY)
			if blocoId >= Constantes.BLOCO_PAREDE then
					return true
			end
					return false
end

---------------------------------------------
function tentaMoverPara(delta)
	local novaPosicao = {
				x= jogador.x +delta.deltaX,
				y= jogador.y +delta.deltaY
	}
	
 if verificaColisaoComObjetos(novaPosicao) then
				return
	end
	
		 superiorEsquerdo = {
      x = jogador.x - 8 + delta.deltaX,
      y = jogador.y - 8 + delta.deltaY
   }
   superiorDireito = {
      x = jogador.x + 7 + delta.deltaX,
      y = jogador.y - 8 + delta.deltaY
   }
   inferiorDireito = {
      x = jogador.x + 7 + delta.deltaX,
      y = jogador.y + 7 + delta.deltaY     
			}
   inferiorEsquerdo = {
      x = jogador.x - 8 + delta.deltaX,
      y = jogador.y + 7 + delta.deltaY
			}
			
   if temColisaoComMapa(inferiorDireito) or
      temColisaoComMapa(inferiorEsquerdo) or
      temColisaoComMapa(superiorDireito) or    
      temColisaoComMapa(superiorEsquerdo) then
      -- colisao

   else
      jogador.quadroDeAnimacao = jogador.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR --personagem caminha a cada 0.1 quadro 
					 if jogador.quadroDeAnimacao >= 3 then
								 jogador.quadroDeAnimacao = 1
						end
						jogador.y = jogador.y + delta.deltaY
						jogador.x = jogador.x + delta.deltaX
   end
end
---------------------------------------------
function atualizaInimigo(inimigo)
    if jogador.y > inimigo.x then
        inimigo.y = inimigo.x + 1
    elseif jogador.y < inimigo.x then
        inimigo.y = inimigo.x - 1
    end
				
				local AnimacaoInimigo = {
							322, 354
				}
				
				inimigo.quadroDeAnimacao = inimigo.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR
					if inimigo.quadroDeAnimacao >= 3 then
        inimigo.quadroDeAnimacao = 1
   	 end
					
			 local quadro =  math.floor(inimigo.quadroDeAnimacao)
			 inimigo.sprite = AnimacaoInimigo[quadro]
	
end

function atualizaPosicoes()
--verifica com y-1 para saber antes de se mover se la tem parede
 --blocos de colisao foram colocados em 128+
	
  local  AnimacoesPersonagem = {
    {384, 416},
    {386, 418},
    {388, 420},
    {390, 422}
   } -- em lua, array comeca no 1
					-- math.floor(numero) == arredondamento

 Direcao = {
  {deltaX = 0, deltaY = -1},
  {deltaX = 0, deltaY = 1},
  {deltaX = -1, deltaY = 0},
  {deltaX = 1, deltaY = 0}
 }
	
	for indice, objeto in pairs(objetos) do
 	 if objeto.tipo == Constantes.INIMIGO then
   atualizaInimigo(objeto)
	  end
 end
		
	for tecla = 0,3 do
		if btn(tecla) then
		quadros = AnimacoesPersonagem[tecla+1]
		quadro = math.floor(jogador.quadroDeAnimacao)
			jogador.sprite = quadros[quadro]
				
					tentaMoverPara(Direcao[tecla+1])
		end
 end
end

---------------------------------------------
function desenha()
	cls() 
	desenhaMapa()
	desenhaJogador()
	desenhaObjetos()
	
 -- print(jogador.x) --posicao que o jogador ocupar
		print(blocoId, 0, 16) --imprimir duas coisas, x na pos 0 e y na pos 16

	end
																-- bloco Id --
	--mget: nao passamos a pos x, y da tela, e sim em qual bloco da tela o jogador esta
	--(-8)= o jogador nao eh apenas 1 pixel, mas 1 pixel com 8 acima e 8 a esquerda)
	--(/8)= pixels = 1 bloco


function desenhaMapa()
	map(0,   -- posicao x no mapa
     0,   -- posicao y no mapa
    Constantes.LARGURA_DA_TELA, -- quantos blocos desenhar x
    Constantes. ALTURA_DA_TELA, -- quantos blocos desenhar y
     0,   --  em qual ponto colocar o x
     0)   -- em qual ponto colocar o y
	end
	
function desenhaJogador()	
 spr	(
	jogador.sprite,				 -- sprite do jogador
 jogador.x - 8, 									-- posicao x
 jogador.y - 8,						-- posicao y
 jogador.corDeFundo, -- cor de fundo (transparente)
 1, 															  -- escala
 0, 															  -- espelhar
 0, 															  -- rotacionar
 2, 															  -- quantos blocos para direita 
 2) 											 				 -- quantos blocos para baixo  
 -- A tela do computador tem 240 x 136 pixels. Para deixarmos o personagem no centro, usaremos esse valores divididos pela metade, ou seja, 120 e 68, respectivamente.

	print("GIRLS IN EUROPA",78,115)
	end
	
function desenhaObjetos()
--Executaremos for para cada objeto dentro de objetos, passaremos por cada um como se fosse um par (pairs).
	 for indice, objeto in pairs(objetos) do	
			spr(objeto.sprite,
							objeto.x - 8,
							objeto.y - 8,
							objeto.corDeFundo,
							1,
							0,
							0,
							2,
							2)
		end
end				

---------------------------------------------

function colisaoComAChave(indice)
		jogador.chaves = jogador.chaves + 1
		table.remove(objetos,indice)
		return false
end

function colisaoComAPorta(indice)
		if jogador.chaves > 0 then
					jogador.chaves = jogador.chaves - 1
					table.remove(objetos,indice)
					return false
		end
		return true
end

function colisaoComOInimigo(indice)
    inicializa()
    return true
end

function temColisao(objetoA, objetoB)
local A_esquerda = objetoA.x - 8
local A_direita = objetoA.x + 7
local A_baixo = objetoA.y + 7
local A_cima = objetoA.y - 8

local B_esquerda = objetoB.x - 8
local B_direita = objetoB.x + 7
local B_baixo = objetoB.y + 7
local B_cima = objetoB.y - 8

    if B_esquerda > A_direita  or
       B_direita  < A_esquerda or
							A_baixo    < B_cima     or
							A_cima     > B_baixo    then
							return false
				end
				return true
end

	
function verificaColisaoComObjetos(novaPosicao)
		for indice, objeto in pairs(objetos) do
			
				if temColisao(novaPosicao, objeto) then
							return objeto.funcaoDeColisao(indice)
				end
				
		end
		return false
end	
					
---------------------------------------------
	
function TIC()
	atualizaPosicoes()
	desenha()
end

---------------------------------------------
	-- *************** OBJETOS *****************
	
 -- x = pixel x. x*8 = bloco x (ja que cada bloco tem 8 pixeis)
	-- +8 evita que o objeto fique colado na parede
function criaPorta(coluna, linha)
  local porta = {
  sprite = Constantes.SPRITE_PORTA,
		x = coluna*8 + 8, 
		y = linha*8 + 8, 
		corDeFundo = 0,
		funcaoDeColisao = colisaoComAPorta
		}
		return porta
end

function criaChave(coluna, linha)

		local chave = {
		sprite = Constantes.SPRITE_CHAVE, 
		x = coluna*8 + 8, 
		y = linha*8 + 8, 
		corDeFundo = 0,
		funcaoDeColisao = colisaoComAChave
		}
	
		return chave
end

function criaInimigo(coluna, linha) 
 local inimigo = {
	
		tipo = Constantes.INIMIGO,
		
  sprite = Constantes.SPRITE_INIMIGO, 
	 x = coluna * 8 + 8,
  y = linha * 8 + 8,
  corDeFundo = 0,
		quadroDeAnimacao = 1,
		funcaoDeColisao = colisaoComOInimigo  
	}
  return inimigo
end
---------------------------------------------

function inicializa()
		objetos = {}
		
		local chave = criaChave(20,3)
		table.insert(objetos, chave)
		local porta = criaPorta(28,8)
		table.insert(objetos, porta)
		local inimigo = criaInimigo(10,5)
		table.insert(objetos,inimigo)
		
		jogador = {
  sprite = 422,	 -- sprite do jogador
	 x = 38, 								-- posicao x inicial
  y = 68,									-- posicao y inicial
		corDeFundo = 0, -- cor do fundo
		quadroDeAnimacao = 1, -- quadro de animacao
		chaves = 0	
		}

end

inicializa()