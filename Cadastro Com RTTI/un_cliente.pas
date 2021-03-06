unit un_cliente;

interface

uses
  Generics.Collections, Un_CustomAttributes;

type
  [ATabela('CLIENTE')]
  TCliente = class
    private
      FCodigo  : Integer;
      FNome    : String;
      FIdade   : Double;
      FPeso    : Double;
      FObservacao     : String;

    public
      [ACampo('CODIGO'), APK]
      property Codigo  : integer read FCodigo   write FCodigo;

      [ACampo('NOME'), ANotNull]
      property Nome    : String  read FNome     write FNome;

      [ACampo('IDADE'), ANotNull]
      property Idade   : Double  read FIdade write FIdade;

      [ACampo('PESO'), ANotNull]
      property Peso    : Double  read FPeso   write FPeso;
  end;

  TClientes = TList<TCliente>;

implementation

end.
