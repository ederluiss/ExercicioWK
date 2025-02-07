unit ProdutosRepository;

interface

uses
  Produto, FireDAC.Comp.Client, System.SysUtils;

type
  TProdutosRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function BuscarPorCodigo(Codigo: Integer): TProduto;
  end;

implementation

{ TProdutosRepository }

constructor TProdutosRepository.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TProdutosRepository.BuscarPorCodigo(Codigo: Integer): TProduto;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM produtos WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := Query.FieldByName('Codigo').AsInteger;
      Result.Descricao := Query.FieldByName('Descricao').AsString;
      Result.PrecoVenda := Query.FieldByName('PrecoVenda').AsFloat;
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
