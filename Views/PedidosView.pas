unit PedidosView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Vcl.ExtCtrls, PedidosController, Cliente, Produto, ClientesRepository, ProdutosRepository,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, DatabaseConnection, Pedido;

type
  TfrmPedidosView = class(TForm)
    edtCodigoCliente: TEdit;
    edtCodigoProduto: TEdit;
    panCliente: TPanel;
    lblCodigoCliente: TLabel;
    lblNome: TLabel;
    lblCidade: TLabel;
    lblUF: TLabel;
    lblDadosCliente: TLabel;
    lblDadosProduto: TLabel;
    panProdutos: TPanel;
    lblCodigoProduto: TLabel;
    lblProduto: TLabel;
    lblQuantidadeProduto: TLabel;
    lblValorUnitario: TLabel;
    grdPanProdutos: TGridPanel;
    lblItensPedidoVenda: TLabel;
    gridProdutos: TStringGrid;
    lblTotalPedido: TLabel;
    btnInserir: TButton;
    lblValorTotal: TLabel;
    FDConnection1: TFDConnection;
    edtQuantidade: TEdit;
    edtNomeCliente: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    edtDescricaoProduto: TEdit;
    edtValorUnitario: TEdit;
    btnGravarPedido: TButton;
    btnCarregarPedido: TButton;
    btnApagarPedido: TButton;
    btnLimpar: TButton;
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure gridProdutosKeyPress(Sender: TObject; var Key: Char);
    procedure gridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnLimparClick(Sender: TObject);
  private
    FPedidosController: TPedidosController;
    FClientesRepository: TClientesRepository;
    FProdutosRepository: TProdutosRepository;
    FDatabaseConnection: TDatabaseConnection;
    procedure AtualizarGrid;
    procedure CarregarCliente(CodigoCliente: Integer);
    procedure CarregarProduto(CodigoProduto: Integer);
    procedure AutoSizeColumns(Grid: TStringGrid);
    procedure AtualizarValorTotal;
    procedure AtivaOcultaBotoes;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmPedidosView: TfrmPedidosView;

implementation

{$R *.dfm}

constructor TfrmPedidosView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TfrmPedidosView.Destroy;
begin
  if Assigned(FPedidosController) then FPedidosController.Free;
  if Assigned(FClientesRepository) then FClientesRepository.Free;
  if Assigned(FProdutosRepository) then FProdutosRepository.Free;
  if Assigned(FDatabaseConnection) then FDatabaseConnection.Free;
  inherited;
end;

procedure TfrmPedidosView.edtCodigoClienteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_TAB then
  begin
    CarregarCliente(StrToIntDef(edtCodigoCliente.Text, 0));
    Key := 0;
    AtivaOcultaBotoes;
  end;
end;

procedure TfrmPedidosView.edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
    CarregarCliente(StrToIntDef(edtCodigoCliente.Text, 0));
    Key := #0;
    AtivaOcultaBotoes;
  end;
end;

procedure TfrmPedidosView.edtCodigoProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_TAB then
  begin
    CarregarProduto(StrToIntDef(edtCodigoProduto.Text, 0));
    Key := 0;
  end;
end;

procedure TfrmPedidosView.edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    CarregarProduto(StrToIntDef(edtCodigoProduto.Text, 0));
    Key := #0;
  end;
end;

procedure TfrmPedidosView.FormCreate(Sender: TObject);
begin
  try
    // Configura a conexão com o banco de dados a partir do arquivo .ini
    FDatabaseConnection := TDatabaseConnection.Create('C:\Users\Eder\Documents\ExercicioWK\Utils\config.ini');

    FClientesRepository := TClientesRepository.Create(FDatabaseConnection.GetConnection);
    FProdutosRepository := TProdutosRepository.Create(FDatabaseConnection.GetConnection);
    FPedidosController := TPedidosController.Create(FDatabaseConnection.GetConnection);

    AtivaOcultaBotoes;

    gridProdutos.Cells[0, 0] := 'Código';
    gridProdutos.Cells[1, 0] := 'Descrição';
    gridProdutos.Cells[2, 0] := 'Quantidade';
    gridProdutos.Cells[3, 0] := 'Valor Unitário';
    gridProdutos.Cells[4, 0] := 'Valor Total';

    Self.OnResize := FormResize;
    gridProdutos.OnKeyPress := gridProdutosKeyPress;
    gridProdutos.OnKeyDown := gridProdutosKeyDown;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TfrmPedidosView.FormResize(Sender: TObject);
begin
  AutoSizeColumns(gridProdutos);
end;

procedure TfrmPedidosView.gridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i, LinhaSelecionada: Integer;
  ValorProduto: Double;
begin
  if Key = VK_DELETE then
  begin
    if (gridProdutos.Row > 0) and (gridProdutos.Row < gridProdutos.RowCount) then
    begin
      if MessageDlg('Deseja realmente apagar este produto?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        LinhaSelecionada := gridProdutos.Row;
        AtualizarGrid;

        for i := LinhaSelecionada to gridProdutos.RowCount - 2 do
          gridProdutos.Rows[i].Assign(gridProdutos.Rows[i + 1]);

        gridProdutos.RowCount := gridProdutos.RowCount - 1;
      end;
    end;
    Key := 0;
  end;

end;

procedure TfrmPedidosView.gridProdutosKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if (gridProdutos.Row > 0) and (gridProdutos.Row < gridProdutos.RowCount) then
    begin
      edtCodigoProduto.Text := gridProdutos.Cells[0, gridProdutos.Row];
      edtDescricaoProduto.Text := gridProdutos.Cells[1, gridProdutos.Row];
      edtQuantidade.Text := gridProdutos.Cells[2, gridProdutos.Row];
      edtValorUnitario.Text := gridProdutos.Cells[3, gridProdutos.Row];

      edtQuantidade.SetFocus;
    end;
    Key := #0;
  end;
end;

procedure TfrmPedidosView.CarregarCliente(CodigoCliente: Integer);
var
  Cliente: TCliente;
begin
  if CodigoCliente > 0 then
  begin
    Cliente := FClientesRepository.BuscarPorCodigo(CodigoCliente);
    try
      if Assigned(Cliente) then
      begin
        edtNomeCliente.Text := Cliente.Nome;
        edtCidade.Text := Cliente.Cidade;
        edtUF.Text := Cliente.UF;
        FPedidosController.GetPedido.CodigoCliente := Cliente.Codigo;
      end
      else
      begin
        edtNomeCliente.Text := 'Cliente não encontrado';
        FPedidosController.GetPedido.CodigoCliente := 0;
      end;
    finally
      Cliente.Free;
    end;
    edtCodigoProduto.SetFocus;
  end
  else
  begin
    ShowMessage('Digite um código de cliente válido.');
  end;
end;

procedure TfrmPedidosView.CarregarProduto(CodigoProduto: Integer);
var
  Produto: TProduto;
begin
  if CodigoProduto > 0 then
  begin
    Produto := FProdutosRepository.BuscarPorCodigo(CodigoProduto);
    try
      if Assigned(Produto) then
      begin
        edtDescricaoProduto.Text := Produto.Descricao;
        edtValorUnitario.Text := FloatToStr(Produto.PrecoVenda);
      end
      else
      begin
        edtDescricaoProduto.Text := 'Produto não encontrado';
        edtValorUnitario.Text := '0,00';
      end;
    finally
      Produto.Free;
    end;
    edtQuantidade.SetFocus;
  end
  else
  begin
    ShowMessage('Digite um código de produto válido.');
  end;
end;

procedure TfrmPedidosView.btnGravarPedidoClick(Sender: TObject);
begin
  FPedidosController.GravarPedido;
  ShowMessage('Pedido gravado com sucesso!');
end;

procedure TfrmPedidosView.btnInserirClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario: Double;
  Descricao: String;
  Produto: TProduto;
  RowIndex: Integer;
  Pedido: TPedido;
begin
  if (edtCodigoProduto.Text = '') or (edtQuantidade.Text = '') or (edtValorUnitario.Text = '') then
  begin
    ShowMessage('Preencha todos os campos do produto.');
    Exit;
  end;

  CodigoProduto := StrToInt(edtCodigoProduto.Text);
  Quantidade := StrToInt(edtQuantidade.Text);
  Descricao := edtDescricaoProduto.Text;
  ValorUnitario := StrToFloat(edtValorUnitario.Text);

  if (gridProdutos.Row > 1) then
  begin
    RowIndex := gridProdutos.Row;
    Pedido := FPedidosController.GetPedido;
    Produto := FPedidosController.GetPedido.Produtos[RowIndex - 1];
    Produto.Quantidade := Quantidade;
    Produto.PrecoVenda := ValorUnitario;

    gridProdutos.Cells[4, RowIndex] := FloatToStr(Quantidade * ValorUnitario);
  end
  else
  begin
    FPedidosController.AdicionarProduto(CodigoProduto, Quantidade, Descricao, ValorUnitario);
  end;

  AtualizarGrid;

  edtCodigoProduto.Clear;
  edtQuantidade.Clear;
  edtDescricaoProduto.Clear;
  edtValorUnitario.Clear;
end;

procedure TfrmPedidosView.btnLimparClick(Sender: TObject);
var
  i: Integer;
begin
  edtCodigoCliente.Clear;
  edtNomeCliente.Clear;
  edtCidade.Clear;
  edtUF.Clear;
  edtCodigoProduto.Clear;
  edtDescricaoProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;

  lblNome.Caption := '';
  lblCidade.Caption := '';
  lblUF.Caption := '';
  lblProduto.Caption := '';
  lblTotalPedido.Caption := '';

  for i := gridProdutos.RowCount - 1 downto 1 do
    gridProdutos.Rows[i].Clear;

  FPedidosController.LimparPedido;
  AtivaOcultaBotoes;
end;

procedure TfrmPedidosView.btnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  Pedido: TPedido;
  NumeroPedidoStr: String;
begin
  try
    NumeroPedidoStr := InputBox('Carregar Pedido', 'Informe o número do pedido:', '');

    if Trim(NumeroPedidoStr) = '' then
      Exit;

    NumeroPedido := StrToIntDef(NumeroPedidoStr, -1);

    if NumeroPedido = -1 then
    begin
      ShowMessage('Número do pedido inválido.');
      Exit;
    end;

    FPedidosController.CarregarPedido(NumeroPedido);
    Pedido := FPedidosController.GetPedido;

    edtCodigoCliente.Text := IntToStr(Pedido.Cliente.Codigo);
    edtNomeCliente.Text := Pedido.Cliente.Nome;
    edtCidade.Text := Pedido.Cliente.Cidade;
    edtUF.Text := Pedido.Cliente.UF;

    AtualizarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar pedido: ' + E.Message);
  end;
end;

procedure TfrmPedidosView.btnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  NumeroPedidoStr: String;
begin
  NumeroPedidoStr := InputBox('Cancelar Pedido', 'Informe o número do pedido:', '');

  if Trim(NumeroPedidoStr) = '' then
    Exit;

  NumeroPedido := StrToIntDef(NumeroPedidoStr, -1);

  if NumeroPedido = -1 then
  begin
    ShowMessage('Número do pedido inválido.');
    Exit;
  end;

  if MessageDlg(Format('Deseja realmente cancelar o pedido %d?', [NumeroPedido]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FPedidosController.CancelarPedido(NumeroPedido);

      edtCodigoCliente.Clear;
      edtCodigoProduto.Clear;
      edtQuantidade.Clear;
      edtValorUnitario.Clear;
      edtNomeCliente.Clear;
      edtDescricaoProduto.Clear;
      lblTotalPedido.Caption := 'Total do Pedido: 0,00';
      gridProdutos.RowCount := 1;
      AtivaOcultaBotoes;

      ShowMessage(Format('Pedido %d cancelado com sucesso!', [NumeroPedido]));
    except
      on E: Exception do
        ShowMessage('Erro ao cancelar o pedido: ' + E.Message);
    end;
  end;
end;

procedure TfrmPedidosView.AtualizarGrid;
var
  Produto: TProduto;
  i: Integer;
begin
  gridProdutos.ColCount := 5;
  gridProdutos.FixedRows := 1;

  for i := 0 to FPedidosController.GetPedido.Produtos.Count - 1 do
  begin
    Produto := FPedidosController.GetPedido.Produtos[i];
    gridProdutos.RowCount := gridProdutos.RowCount + 1; // Adiciona uma nova linha
    gridProdutos.Cells[0, i + 1] := IntToStr(Produto.Codigo);
    gridProdutos.Cells[1, i + 1] := Produto.Descricao;
    gridProdutos.Cells[2, i + 1] := IntToStr(Produto.Quantidade);
    gridProdutos.Cells[3, i + 1] := FloatToStr(Produto.PrecoVenda);
    gridProdutos.Cells[4, i + 1] := FloatToStr(Produto.Quantidade * Produto.PrecoVenda);
  end;

  AtualizarValorTotal;
  AutoSizeColumns(gridProdutos);
end;

procedure TfrmPedidosView.AutoSizeColumns(Grid: TStringGrid);
var
  i, j, MaxWidth, CellWidth: Integer;
begin
  for i := 0 to Grid.ColCount - 1 do
  begin
    MaxWidth := 0;

    for j := 0 to Grid.RowCount - 1 do
    begin
      CellWidth := Grid.Canvas.TextWidth(Grid.Cells[i, j]) + 10;
      if CellWidth > MaxWidth then
        MaxWidth := CellWidth;
    end;

    Grid.ColWidths[i] := MaxWidth;
  end;
end;

procedure TfrmPedidosView.AtualizarValorTotal;
var
  I: Integer;
  ValorTotal, ValorItem: Double;
begin
  ValorTotal := 0;

  for I := 1 to gridProdutos.RowCount - 1 do
  begin
    if TryStrToFloat(StringReplace(gridProdutos.Cells[4, I], 'R$ ', '', [rfReplaceAll]), ValorItem) then
      ValorTotal := ValorTotal + ValorItem;
  end;

  lblTotalPedido.Caption := FormatFloat('Total do Pedido: R$ #,##0.00', ValorTotal);
end;

procedure TfrmPedidosView.AtivaOcultaBotoes;
begin
  btnCarregarPedido.Visible := False;
  btnApagarPedido.Visible := False;
  if edtCodigoCliente.Text = '' then
  begin
    btnCarregarPedido.Visible := True;
    btnApagarPedido.Visible := True;
  end;
end;

end.
