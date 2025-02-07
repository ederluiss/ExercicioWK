object frmPedidosView: TfrmPedidosView
  Left = 0
  Top = 0
  Caption = 'Pedidos de Venda'
  ClientHeight = 752
  ClientWidth = 1289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    1289
    752)
  TextHeight = 15
  object lblDadosCliente: TLabel
    Left = 6
    Top = 8
    Width = 93
    Height = 15
    Margins.Left = 50
    Caption = 'Dados do Cliente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDadosProduto: TLabel
    Left = 6
    Top = 108
    Width = 99
    Height = 15
    Margins.Left = 50
    Caption = 'Dados do Produto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblItensPedidoVenda: TLabel
    Left = 8
    Top = 232
    Width = 140
    Height = 15
    Caption = 'Itens do Pedido de Venda'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object panCliente: TPanel
    Left = 6
    Top = 35
    Width = 353
    Height = 56
    Margins.Left = 50
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object lblCodigoCliente: TLabel
      Left = 0
      Top = 3
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
    end
    object lblNome: TLabel
      Left = 184
      Top = 3
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lblCidade: TLabel
      Left = 0
      Top = 35
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object lblUF: TLabel
      Left = 252
      Top = 35
      Width = 14
      Height = 15
      Caption = 'UF'
    end
    object edtCodigoCliente: TEdit
      Left = 45
      Top = 0
      Width = 121
      Height = 23
      TabOrder = 0
      OnKeyDown = edtCodigoClienteKeyDown
      OnKeyPress = edtCodigoClienteKeyPress
    end
    object edtNomeCliente: TEdit
      Left = 223
      Top = 0
      Width = 130
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object edtCidade: TEdit
      Left = 46
      Top = 31
      Width = 189
      Height = 23
      ReadOnly = True
      TabOrder = 2
    end
    object edtUF: TEdit
      Left = 272
      Top = 33
      Width = 49
      Height = 23
      ReadOnly = True
      TabOrder = 3
    end
  end
  object panProdutos: TPanel
    Left = 6
    Top = 129
    Width = 393
    Height = 72
    Margins.Left = 50
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    object lblCodigoProduto: TLabel
      Left = 0
      Top = 4
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
    end
    object lblProduto: TLabel
      Left = 184
      Top = 4
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
    end
    object lblQuantidadeProduto: TLabel
      Left = 0
      Top = 52
      Width = 62
      Height = 15
      Caption = 'Quantidade'
    end
    object lblValorUnitario: TLabel
      Left = 184
      Top = 52
      Width = 71
      Height = 15
      Caption = 'Valor Unit'#225'rio'
    end
    object edtCodigoProduto: TEdit
      Left = 45
      Top = 0
      Width = 121
      Height = 23
      TabOrder = 0
      OnKeyDown = edtCodigoProdutoKeyDown
      OnKeyPress = edtCodigoProdutoKeyPress
    end
    object edtQuantidade: TEdit
      Left = 68
      Top = 49
      Width = 98
      Height = 23
      TabOrder = 2
    end
    object edtDescricaoProduto: TEdit
      Left = 244
      Top = 0
      Width = 149
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object edtValorUnitario: TEdit
      Left = 261
      Top = 48
      Width = 121
      Height = 23
      TabOrder = 3
    end
  end
  object grdPanProdutos: TGridPanel
    Left = 0
    Top = 256
    Width = 1179
    Height = 396
    Anchors = []
    BevelEdges = []
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = gridProdutos
        Row = 0
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 2
    ExplicitLeft = -3
    ExplicitTop = 246
    object gridProdutos: TStringGrid
      Left = 0
      Top = 0
      Width = 1153
      Height = 393
      BevelInner = bvNone
      TabOrder = 0
      OnKeyDown = gridProdutosKeyDown
      OnKeyPress = gridProdutosKeyPress
    end
  end
  object TPanel
    Left = 0
    Top = 711
    Width = 1289
    Height = 41
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 694
    ExplicitWidth = 1283
    object lblTotalPedido: TLabel
      Left = 8
      Top = 16
      Width = 111
      Height = 15
      Caption = 'Valor Total do Pedido'
    end
    object lblValorTotal: TLabel
      Left = 125
      Top = 16
      Width = 3
      Height = 15
    end
  end
  object btnInserir: TButton
    Left = 432
    Top = 177
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 4
    OnClick = btnInserirClick
  end
  object btnGravarPedido: TButton
    Left = 1040
    Top = 672
    Width = 99
    Height = 25
    Caption = 'Gravar Pedido'
    TabOrder = 5
    OnClick = btnGravarPedidoClick
  end
  object btnCarregarPedido: TButton
    Left = 432
    Top = 34
    Width = 97
    Height = 25
    Caption = 'Carregar Pedido'
    TabOrder = 6
    OnClick = btnCarregarPedidoClick
  end
  object btnApagarPedido: TButton
    Left = 560
    Top = 34
    Width = 105
    Height = 25
    Caption = 'Cancelar Pedido'
    TabOrder = 7
    OnClick = btnCancelarPedidoClick
  end
  object btnLimpar: TButton
    Left = 936
    Top = 672
    Width = 83
    Height = 25
    Caption = 'Limpar Pedido'
    TabOrder = 8
    OnClick = btnLimparClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 400
    Top = 656
  end
end
