unit ClientesRepository;

interface

uses
  Cliente, FireDAC.Comp.Client, System.SysUtils, FireDAC.DApt;

type
  TClientesRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function BuscarPorCodigo(Codigo: Integer): TCliente;
  end;

implementation

{ TClientesRepository }

constructor TClientesRepository.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TClientesRepository.BuscarPorCodigo(Codigo: Integer): TCliente;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM clientes WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Codigo := Query.FieldByName('Codigo').AsInteger;
      Result.Nome := Query.FieldByName('Nome').AsString;
      Result.Cidade := Query.FieldByName('Cidade').AsString;
      Result.UF := Query.FieldByName('UF').AsString;
    end
    else
    begin
      Result := nil;
    end;
  finally
    Query.Free;
  end;
end;

end.
