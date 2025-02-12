unit DatabaseConnection;

interface

uses
  FireDAC.Comp.Client, DatabaseConfig, System.SysUtils;

type
  TDatabaseConnection = class
  private
    FConnection: TFDConnection;
    FConfig: TDatabaseConfig;
  public
    constructor Create(const AIniFilePath: string);
    destructor Destroy; override;
    function GetConnection: TFDConnection;
  end;

implementation

{ TDatabaseConnection }

constructor TDatabaseConnection.Create(const AIniFilePath: string);
begin
  FConfig := TDatabaseConfig.Create(AIniFilePath);
  FConnection := TFDConnection.Create(nil);

  // Configura a conex�o com base no arquivo .ini
  FConnection.DriverName := 'MySQL';
  FConnection.Params.Values['Database'] := FConfig.Database;
  FConnection.Params.Values['User_Name'] := FConfig.Username;
  FConnection.Params.Values['Password'] := FConfig.Password;
  FConnection.Params.Values['Server'] := FConfig.Server;
  FConnection.Params.Values['Port'] := IntToStr(FConfig.Port);
  FConnection.Params.Values['DriverID'] := 'MySQL';
  FConnection.Params.Values['LibraryLocation'] := FConfig.LibraryPath;
  FConnection.LoginPrompt := False;
end;

destructor TDatabaseConnection.Destroy;
begin
  FConnection.Free;
  FConfig.Free;
  inherited;
end;

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
