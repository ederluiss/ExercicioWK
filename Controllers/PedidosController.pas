unit PedidosController;

interface

uses
  Pedido, PedidosRepository, Produto, FireDAC.Comp.Client;

type
  TPedidosController = class
  private
    FPedido: TPedido;
    FPedidosRepository: TPedidosRepository;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure AdicionarProduto(CodigoProduto, Quantidade: Integer; Descricao: String; ValorUnitario: Double);
    function GetPedido: TPedido;
    procedure GravarPedido;
    procedure CarregarPedido(NumeroPedido: Integer);
    procedure CancelarPedido(NumeroPedido: Integer);
    procedure LimparPedido;
  end;

implementation

{ TPedidosController }

constructor TPedidosController.Create(AConnection: TFDConnection);
begin
  FPedido := TPedido.Create;
  FPedidosRepository := TPedidosRepository.Create(AConnection);
end;

destructor TPedidosController.Destroy;
begin
  FPedido.Free;
  FPedidosRepository.Free;
  inherited;
end;

procedure TPedidosController.AdicionarProduto(CodigoProduto, Quantidade: Integer; Descricao: String; ValorUnitario: Double);
var
  Produto: TProduto;
begin
  Produto := TProduto.Create;
  try
    Produto.Codigo := CodigoProduto;
    Produto.Descricao := Descricao;
    Produto.PrecoVenda := ValorUnitario;
    Produto.Quantidade := Quantidade;
    FPedido.Produtos.Add(Produto);
    FPedido.ValorTotal := FPedido.ValorTotal + (Quantidade * ValorUnitario);
  except
    Produto.Free;
    raise;
  end;
end;

function TPedidosController.GetPedido: TPedido;
begin
  Result := FPedido;
end;

procedure TPedidosController.GravarPedido;
begin
  FPedidosRepository.GravarPedido(FPedido);
end;

procedure TPedidosController.CarregarPedido(NumeroPedido: Integer);
begin
  FPedido := FPedidosRepository.CarregarPedido(NumeroPedido);
end;

procedure TPedidosController.CancelarPedido(NumeroPedido: Integer);
begin
  FPedidosRepository.CancelarPedido(NumeroPedido);
end;

procedure TPedidosController.LimparPedido();
begin
  FPedido.Free;
  FPedido := TPedido.Create;
end;

end.
