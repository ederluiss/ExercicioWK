unit PedidosRepository;

interface

uses
  Pedido, Produto, Cliente, FireDAC.Comp.Client, FireDAC.Stan.Param, System.SysUtils, System.Classes;

type
  TPedidosRepository = class
  private
    FConnection: TFDConnection;
    function ObterProximoNumeroPedido: Integer;
    function ExisteNumeroPedido(NumeroPedido: Integer): Boolean;
  public
    constructor Create(AConnection: TFDConnection);
    procedure GravarPedido(Pedido: TPedido);
    function CarregarPedido(NumeroPedido: Integer): TPedido;
    procedure CancelarPedido(NumeroPedido: Integer);
  end;

implementation

{ TPedidosRepository }

constructor TPedidosRepository.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TPedidosRepository.ObterProximoNumeroPedido: Integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT COALESCE(MAX(NumeroPedido), 0) + 1 AS ProximoNumero FROM pedidos';
    Query.Open;
    Result := Query.FieldByName('ProximoNumero').AsInteger;
  finally
    Query.Free;
  end;
end;

function TPedidosRepository.ExisteNumeroPedido(NumeroPedido: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT CodigoCliente FROM pedidos where NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.Open;
    Result := Query.FieldByName('CodigoCliente').AsInteger > 0;
  finally
    Query.Free;
  end;
end;

procedure TPedidosRepository.GravarPedido(Pedido: TPedido);
var
  Query: TFDQuery;
  Transacao: TFDTransaction;
  Produto: TProduto;
  NumPedido: Integer;
begin
  Transacao := TFDTransaction.Create(nil);
  Query := TFDQuery.Create(nil);
  try
    Transacao.Connection := FConnection;
    Transacao.StartTransaction;

    Query.Connection := FConnection;
    Query.Transaction := Transacao;
    NumPedido := ObterProximoNumeroPedido;

    try
      Query.SQL.Text :=
        'INSERT INTO pedidos (NumeroPedido, CodigoCliente, ValorTotal) ' +
        'VALUES (:NumeroPedido, :CodigoCliente, :ValorTotal)';
      Query.ParamByName('NumeroPedido').AsInteger := NumPedido;
      Query.ParamByName('CodigoCliente').AsInteger := Pedido.CodigoCliente;
      Query.ParamByName('ValorTotal').AsFloat := Pedido.ValorTotal;
      Query.ExecSQL;

      for Produto in Pedido.Produtos do
      begin
        Query.SQL.Text :=
          'INSERT INTO pedidos_produtos (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) ' +
          'VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, :ValorUnitario, :ValorTotal)';
        Query.ParamByName('NumeroPedido').AsInteger := NumPedido;
        Query.ParamByName('CodigoProduto').AsInteger := Produto.Codigo;
        Query.ParamByName('Quantidade').AsInteger := Produto.Quantidade;
        Query.ParamByName('ValorUnitario').AsFloat := Produto.PrecoVenda;
        Query.ParamByName('ValorTotal').AsFloat := Produto.Quantidade * Produto.PrecoVenda;
        Query.ExecSQL;
      end;

      Transacao.Commit;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        raise Exception.Create('Erro ao gravar pedido: ' + E.Message);
      end;
    end;
  finally
    Query.Free;
    Transacao.Free;
  end;
end;

function TPedidosRepository.CarregarPedido(NumeroPedido: Integer): TPedido;
var
  Query: TFDQuery;
  Produto: TProduto;
begin
  Result := TPedido.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    Query.SQL.Text :=
      'SELECT p.NumeroPedido, p.DataEmissao, p.CodigoCliente, p.ValorTotal, ' +
      'c.Nome AS NomeCliente, c.Cidade, c.UF ' +
      'FROM pedidos p ' +
      'INNER JOIN clientes c ON p.CodigoCliente = c.Codigo ' +
      'WHERE p.NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result.NumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;
      Result.DataEmissao := Query.FieldByName('DataEmissao').AsDateTime;
      Result.CodigoCliente := Query.FieldByName('CodigoCliente').AsInteger;
      Result.ValorTotal := Query.FieldByName('ValorTotal').AsFloat;

      Result.Cliente := TCliente.Create;
      Result.Cliente.Codigo := Query.FieldByName('CodigoCliente').AsInteger;
      Result.Cliente.Nome := Query.FieldByName('NomeCliente').AsString;
      Result.Cliente.Cidade := Query.FieldByName('Cidade').AsString;
      Result.Cliente.UF := Query.FieldByName('UF').AsString;

      Query.Close;
      Query.SQL.Text :=
        'SELECT pp.*, pr.Descricao ' +
        'FROM pedidos_produtos pp ' +
        'INNER JOIN produtos pr ON pp.CodigoProduto = pr.Codigo ' +
        'WHERE pp.NumeroPedido = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      Query.Open;

      while not Query.Eof do
      begin
        Produto := TProduto.Create;
        Produto.Codigo := Query.FieldByName('CodigoProduto').AsInteger;
        Produto.Descricao := Query.FieldByName('Descricao').AsString;
        Produto.Quantidade := Query.FieldByName('Quantidade').AsInteger;
        Produto.PrecoVenda := Query.FieldByName('ValorUnitario').AsFloat;
        Result.Produtos.Add(Produto);
        Query.Next;
      end;
    end
    else
    begin
      raise Exception.Create('Pedido não encontrado.');
    end;
  finally
    Query.Free;
  end;
end;

procedure TPedidosRepository.CancelarPedido(NumeroPedido: Integer);
var
  Query: TFDQuery;
  Transacao: TFDTransaction;
begin
  if ExisteNumeroPedido(NumeroPedido) then
  begin
    Transacao := TFDTransaction.Create(nil);
    Query := TFDQuery.Create(nil);
    try
      Transacao.Connection := FConnection;
      Transacao.StartTransaction;

      Query.Connection := FConnection;
      Query.Transaction := Transacao;

      try
        Query.SQL.Text := 'DELETE FROM pedidos_produtos WHERE NumeroPedido = :NumeroPedido';
        Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
        Query.ExecSQL;

        Query.SQL.Text := 'DELETE FROM pedidos WHERE NumeroPedido = :NumeroPedido';
        Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
        Query.ExecSQL;

        Transacao.Commit;
      except
        on E: Exception do
        begin
          Transacao.Rollback;
          raise Exception.Create('Erro ao cancelar pedido: ' + E.Message);
        end;
      end;
    finally
      Query.Free;
      Transacao.Free;
    end;
  end
  else
  begin
    raise Exception.Create('Pedido não encontrado.');
  end;
end;

end.
