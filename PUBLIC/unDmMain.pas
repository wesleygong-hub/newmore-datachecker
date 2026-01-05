unit unDmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDmMain = class(TDataModule)
    DbMain: TDatabase;
    QrMain: TQuery;
    QrTemp: TQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function CreateAdoqry(var adoqryname: TQuery): Boolean; overload;
    function CreateADOQry: TQuery; overload;
  end;

var
  DmMain: TDmMain;
  check_ok:boolean;

implementation

{$R *.DFM}

function TdmMain.CreateAdoqry(var adoqryname: TQuery): Boolean;
begin
  try
    if not Assigned(adoqryname) then
      adoqryname := TQuery.Create(nil);
    adoqryname.DatabaseName := 'SFSCMIS';
    adoqryname.SQL.Clear;
    Result := True;
  except
    Result := False;
  end;
end;

function TdmMain.CreateAdoqry: TQuery;
begin
  Result := TQuery.Create(nil);
  Result.DatabaseName := 'SFSCMIS';
end;

end.
