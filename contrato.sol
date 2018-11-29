pragma solidity 0.4.25;

contract TrabalhoIntermitente {
    
    struct Proposta {
        string texto;
        address proponente;
        uint valorPorHora;
        uint minimodeDeHoras;
        uint maximoDeHoras;
        bool existe;
        mapping(address=>Trabalhador) quemTrabalhou;
    }


    struct Trabalhador {
        address conta;
        string identificationID;
        uint quantidadeDeHoras;
        bool existe;
        uint balancoDeSegundosAReceber;
    }
    
    event Trabalhou(address quemTrabalhou, uint segundosTrabalhados);
     
    //Informações gerais 
    Proposta[] propostas;
    Trabalhador[] trabalhadores;
    
    
    function definirProposta (string qualTextoDaProposta, address qualProponente, uint qualValorDaHora, uint qualMinimoDeHoras, uint qualMaximoDeHoras) public {
        Proposta memory novaProposta = Proposta(qualTextoDaProposta, qualProponente, qualValorDaHora, qualMaximoDeHoras, qualMaximoDeHoras, true);
        propostas.push(novaProposta);
    }
    
    
    function definirTrabalhadores (uint indiceProposta, address qualConta, string qualId, uint quantidadeDeHoras) public {
        Proposta storage prop = propostas[indiceProposta];
        require (prop.existe);
        Trabalhador memory trab = Trabalhador(qualConta, qualId, quantidadeDeHoras, true, 0);
        prop.quemTrabalhou[qualConta] = trab;
        trabalhadores.push(trab);
    }
    
    
    function fazerDeposito() public payable {
    }
    
    function marcarPonto(uint indiceProposta, uint quandoIniciou) public {
        Proposta storage prop = propostas[indiceProposta];
        Trabalhador memory trab = prop.quemTrabalhou[msg.sender];
        require (trab.existe);
        trab.balancoDeSegundosAReceber = trab.balancoDeSegundosAReceber + (now - quandoIniciou);
        Trabalhou(trab.conta, (now - quandoIniciou));
    }
        
    function receberSalario(uint indiceProposta) public {
        Proposta storage prop = propostas[indiceProposta];
        Trabalhador memory trab = prop.quemTrabalhou[msg.sender];
        require (trab.existe);
        trab.conta.transfer(trab.balancoDeSegundosAReceber);
    }
}
    
     
