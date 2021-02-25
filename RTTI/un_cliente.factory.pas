unit un_cliente.factory;

interface

uses
  un_TCliente;

type
  TClienteFactory = class
    public
      {Class function p/ n precisar instanciar objeto e controlar memoria(criar e dar free)}
      Class function PreencherListagemDeClientes : TListaClientes;
  end;

implementation

uses
  Generics.Collections;

{ TClienteFactory }

class function TClienteFactory.PreencherListagemDeClientes: TListaClientes;
begin
  {Crio um lista Genérica (<>) inidca isso
   Dentro <InformoTipo> passo o tipo do objeto que pertencerá a lista, fazendo casting. }
  Result := Tlist<TClasseCliente>.Create;

  { Crio e preencho 1 cliente
  Criado para Violar a Regra do Custom:  CampoObrigatorio(Nome)
  }
  Result.Add(TClasseCliente.Create);
  Result[0].Nome  := '';
  Result[0].Idade := 15;
  Result[0].Peso  := 88.5;

  //Cliente Inserido correto
  Result.Add(TClasseCliente.Create);
  Result[1].Nome  := 'Cliente 3';
  Result[1].Idade := 4;
  Result[1].Peso  := 44.4;

  {Crio e preencho 3 cliente
  Criado para Violar a Regra do Custom: DefineIntervaloAceito(1,100) (Idade)
  }
  Result.Add(TClasseCliente.Create);
  Result[2].Nome  := 'Cliente 3';
  Result[2].Idade := 151;
  Result[2].Peso  := 99.9;



  Result.Add(TClasseCliente.Create);
end;

end.
