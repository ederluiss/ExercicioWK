program Project1;

uses
  Vcl.Forms,
  DatabaseConfig in 'Utils\DatabaseConfig.pas',
  Cliente in 'Models\Cliente.pas',
  Produto in 'Models\Produto.pas',
  Pedido in 'Models\Pedido.pas',
  PedidosView in 'Views\PedidosView.pas' {frmPedidosView},
  PedidosRepository in 'Repositories\PedidosRepository.pas',
  ClientesRepository in 'Repositories\ClientesRepository.pas',
  ProdutosRepository in 'Repositories\ProdutosRepository.pas',
  PedidosController in 'Controllers\PedidosController.pas',
  DatabaseConnection in 'Utils\DatabaseConnection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedidosView, frmPedidosView);
  Application.Run;
end.
