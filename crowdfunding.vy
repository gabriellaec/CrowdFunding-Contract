# APS

# Endereço do dono do contrato
owner: address

# Meta de arrecadacao
goal: uint256

# Data limite de arrecadacao
date_limit: uint256

# Arrecadacao atual
current: uint256

# Booleano se o evento acabou
end: bool

# Dicionário que indica se o usuário fez uma doação
users: public(HashMap[address, uint256])


# Função que roda quando é feito o deploy do contrato
@external
def __init__(goal: uint256, date_limit: uint256):
    self.owner = msg.sender
    self.goal = goal
    self.date_limit = date_limit
    self.current = 0
    self.end = False

# Função que encerra o evento
@external
def finish():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    # Testa se o evento ainda não acabou
    assert self.end == False

    # Termina o evento
    self.end = True

    # Envia a arrecadação para o dono se tiver atingido o objetivo
    if self.current >= self.goal:
        send(msg.sender, self.goal)
    

@external # Habilita para interação externa (função chamável)
@payable # Habilita o recebimento de valores pela função
def donate():
    # Testa se o evento ainda não acabou
    assert self.end == False
    
    # Atribui a doação ao doador
    self.users[msg.sender] = msg.value

    # Aumenta o valor atual arrecadado
    self.current += msg.value
    

@external
def withdraw():
    # Testa se o comprador já doou algo
    assert self.users[msg.sender] > 0
    
    # Testa se o evento acabou
    assert self.end == True
    
    # Devolve todo o dinheiro doado pela pessoa
    send(msg.sender, self.users[msg.sender])

    # Zera a doacao
    self.users[msg.sender] = 0
   