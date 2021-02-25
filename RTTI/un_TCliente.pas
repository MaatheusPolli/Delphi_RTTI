unit un_TCliente;

interface

uses
  Generics.Collections, un_CustomAttributes;

type
  TClasseCliente = class
    private
      FNome: String;
      FIdade: Integer;
      FPeso : Double;
      procedure SetIdade(const Value: Integer);
      procedure SetNome(const Value: String);
      procedure SetPeso(const Value: Double);
    public
      [CampoObrigatorio]  // Custo Atrributes - Valida em CustomAttributes
      property Nome: String read FNome write SetNome;

      [DefineIntervaloAceito(1,100)]
      property Idade: Integer read FIdade write SetIdade;

      property Peso: Double read FPeso write SetPeso;
  end;

  TListaClientes = Tlist<TClasseCliente>;

implementation

{ TClasseCliente }

procedure TClasseCliente.SetIdade(const Value: Integer);
begin
  FIdade := Value;
end;

procedure TClasseCliente.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TClasseCliente.SetPeso(const Value: Double);
begin
  FPeso := Value;
end;

end.
