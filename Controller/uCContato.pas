unit uCContato;

interface

uses
  DBClient, System.SysUtils, uMContato;

type
  TCContato = class
    private
      FDisplay: TProc<string>;
      function SerializarDatasetMContatoAntesDeSalvar(
        ocdsContato: TClientDataSet): TMContato;
    public
      constructor Create(aValue: TProc<string>);
      destructor Destroy; override;
      procedure SalvarContato(ocdsContato: TClientDataSet);
  end;

implementation

uses
  uMRepositorioContato;

{ TCContato }

constructor TCContato.Create(aValue: TProc<string>);
begin
  FDisplay := aValue;
end;

destructor TCContato.Destroy;
begin
  inherited;
end;

procedure TCContato.SalvarContato(ocdsContato: TClientDataSet);
var
  oMContato: TMContato;
  oMContatoRepositorio: TMRepositorioContato;
begin
  oMContatoRepositorio := TMRepositorioContato.Create;

  try
    try
      oMContato := SerializarDatasetMContatoAntesDeSalvar(ocdsContato);
      oMContatoRepositorio.Salvar(oMContato);
    except
      on E: Exception do
      begin
        if assigned(FDisplay) then
          FDisplay('Erro: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(oMContato);
    FreeAndNil(oMContatoRepositorio);
  end;
end;

function TCContato.SerializarDatasetMContatoAntesDeSalvar(
  ocdsContato: TClientDataSet): TMContato;
begin
  result := TMContato.Create;

  result.Id := TMRepositorioContato.GetIdMaxContatos + 1;
  result.Nome := ocdsContato.FieldByName('Nome').AsString;
  result.Sobrenome := ocdsContato.FieldByName('Sobrenome').AsString;
  result.Apelido := ocdsContato.FieldByName('Apelido').AsString;
  result.Nascimento := TMRepositorioContato.ValidarData(
    ocdsContato.FieldByName('Nascimento').AsString);
  result.Relacionamento := ocdsContato.FieldByName('Relacionamento').AsString;
  result.Excluido := 'N';
end;

end.
