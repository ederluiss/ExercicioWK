unit Pedido;

interface

uses
  System.Generics.Collections, Cliente, Produto;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Double;
    FProdutos: TObjectList<TProduto>;
    FCliente: TCliente;
  public
    constructor Create;
    destructor Destroy; override;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property Produtos: TObjectList<TProduto> read FProdutos;
    property Cliente: TCliente read FCliente write FCliente;
  end;

implementation

constructor TPedido.Create;
begin
  FProdutos := TObjectList<TProduto>.Create;
  FCliente := TCliente.Create;
end;

destructor TPedido.Destroy;
begin
  FProdutos.Free;
  FCliente.Free;
  inherited;
end;

end.
