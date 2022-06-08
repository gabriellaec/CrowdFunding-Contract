# Crowdfunding - APS

# Endereço do dono do contrato
owner: address

# Meta de arrecadacao
target: uint256

# Data limite de arrecadacao
endtime: uint256

# Arrecadacao atual
current: uint256

# Dicionário que indica se o usuário fez uma doação
donations: public(HashMap[address, uint256])


# Função que roda quando é feito o deploy do contrato
@external
def __init__(target: uint256, endtime: uint256):
    self.owner = msg.sender
    self.target = target
    self.endtime = block.timestamp + endtime
    self.current = 0


# Função que encerra o evento
@external
def finish():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    # Testa se o evento acabou
    assert block.timestamp >= self.endtime

    # Testa se atingiu a meta
    assert self.current >= self.target

    # Envia a arrecadação para o dono se tiver atingido o objetivo
    send(msg.sender, self.target)
    

@external # Habilita para interação externa (função chamável)
@payable # Habilita o recebimento de valores pela função
def donate():

    # Testa se o evento ainda não acabou
    assert block.timestamp < self.endtime
    
    # Atribui a doação ao doador
    self.donations[msg.sender] += msg.value

    # Aumenta o valor atual arrecadado
    self.current += msg.value
    

@external
def withdraw():
    # Testa se o comprador já doou algo
    assert self.donations[msg.sender] > 0
    
    # Testa se o evento acabou
    assert block.timestamp >= self.endtime

    # Testa se nao atingiu a meta
    assert self.current < self.target
    
    # Devolve todo o dinheiro doado pela pessoa
    send(msg.sender, self.donations[msg.sender])

    # Zera a doacao da pessoa
    self.donations[msg.sender] = 0
   