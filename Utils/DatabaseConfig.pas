unit DatabaseConfig;

interface

uses
  System.IniFiles, System.SysUtils;

type
  TDatabaseConfig = class
  private
    FDatabase: string;
    FUsername: string;
    FServer: string;
    FPort: Integer;
    FPassword: string;
    FLibraryPath: string;
  public
    constructor Create(const AIniFilePath: string);
    property Database: string read FDatabase;
    property Username: string read FUsername;
    property Server: string read FServer;
    property Port: Integer read FPort;
    property Password: string read FPassword;
    property LibraryPath: string read FLibraryPath;
  end;

implementation

constructor TDatabaseConfig.Create(const AIniFilePath: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(AIniFilePath);
  try
    FDatabase := IniFile.ReadString('Database', 'Database', '');
    FUsername := IniFile.ReadString('Database', 'Username', '');
    FServer := IniFile.ReadString('Database', 'Server', '');
    FPort := IniFile.ReadInteger('Database', 'Port', 3306);
    FPassword := IniFile.ReadString('Database', 'Password', '');
    FLibraryPath := IniFile.ReadString('Database', 'LibraryPath', '');
  finally
    IniFile.Free;
  end;
end;

end.
